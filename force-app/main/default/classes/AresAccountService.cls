public with sharing class AresAccountService {
    private static Http http = new Http();

    @InvocableMethod( label='HTTP Call get Company Information from ARES (ICO)')
    public static List<Response> AresAccountService(List<Requests> requests) {
        List<Response> responses = new List<Response>();

        String endpointUrl = 'https://ares.gov.cz/ekonomicke-subjekty-v-be/rest/ekonomicke-subjekty/';

        for (Requests req : requests) {
            Response res = new Response();
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpointUrl + req.ico);
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            handleAresResponse(response, res);
            System.debug(JSON.serializePretty(responses));
            responses.add(res);
        } catch (Exception e) {
                res.success = false;
                res.errorMessage =  e.getMessage();
        }
      }
        return responses;
    }

    public static void handleAresResponse(HttpResponse response, Response res) {
          // If the request is successful, parse the JSON response.
            if(response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Account account = new Account();
                
                account.ICO__c = (String) result.get('ico');
                account.Name = (String) result.get('obchodniJmeno');
                account.Legal_Form_Id__c = (String) result.get('pravniForma');
                Map<String,Object> billingAddress = (Map<String,Object>) result.get('sidlo');
                Object billingAddressFromJson = billingAddress.get('cisloOrientacni');
                String streetNumber = billingAddressFromJson != null ? (' / ' + String.valueOf(billingAddressFromJson)) : '';
                account.BillingCity = (String) billingAddress.get('nazevObce');
                account.BillingPostalCode = String.valueOf(billingAddress.get('psc')) + ' ' + (String) billingAddress.get('nazevMestskeCastiObvodu');
                account.BillingCountry = (String) billingAddress.get('nazevStatu');
                account.BillingStreet = (String) billingAddress.get('nazevUlice') + ' ' + String.valueOf(billingAddress.get('cisloDomovni')) + streetNumber;
                account.BillingState = (String) billingAddress.get('nazevCastiObce');
                account.Region_Name__c = (String) billingAddress.get('nazevKraje');
                account.Full_Address__c = (String) billingAddress.get('textovaAdresa');
                
                res.account = account;
                res.success = true;
            } else if (response.getStatusCode() == 400) {
                res.errorMessage = 'Chyba vstupu (například špatný formát IČO)';
                res.success = false;
            } else if (response.getStatusCode() == 401) {
                res.errorMessage = 'Chyba autentizace';
                res.success = false;
            } else if (response.getStatusCode() == 403) {
                res.errorMessage = 'Přístup zamítnut';
                res.success = false;
            } else if (response.getStatusCode() == 404) {
                res.errorMessage = 'Zdroj nenalezen';
                res.success = false;
            } else if (response.getStatusCode() == 500) {
                res.errorMessage = 'Neočekávaná chyba';
                res.success = false;
            }
    }

    public class Requests {
        @InvocableVariable
        public String ico;
       
    }
    
    public class Response {
    @InvocableVariable
    public Account account;

    @InvocableVariable
    public String errorMessage;

    @InvocableVariable
    public Boolean success;
}
  
}