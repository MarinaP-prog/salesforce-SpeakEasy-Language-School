public with sharing class AresAccountService {
    private static Http http = new Http();

    @InvocableMethod( label='HTTP Call get Company Information from ARES (ICO)')
    public static List<Response> AresAccountService(List<Requests> requests) {
        List<Response> responses = new List<Response>();

        String endpointUrl = 'https://ares.gov.cz/ekonomicke-subjekty-v-be/rest/ekonomicke-subjekty/';
        //String icoFromFlow = '03024130';

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
        //upsert responses;
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
                System.debug(res);
                   /* 15:04:30:254 USER_DEBUG [39]|DEBUG|(Account:{ICO__c=03024130, Name=VELKÁ PECKA s.r.o., Legal_Form_Id__c=112, City_Name__c=Praha, Zip_Code__c=18600,
                     Country_Name__c=Česká republika, Street_Name__c=Karolinská, Building_Number__c=654, Street_Number__c=2, District_Name__c=Karlín, 
                     City_District_Name__c=Praha 8, Region_Name__c=Hlavní město Praha, Full_Address__c=Karolinská 654/2, Karlín, 18600 Praha 8}) */
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