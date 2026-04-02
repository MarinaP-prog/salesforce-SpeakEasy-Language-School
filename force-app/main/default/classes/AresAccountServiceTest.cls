@isTest
public with sharing class AresAccountServiceTest {
    @isTest
    public static void AresAccountServiceTestSuccess() {
  
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetARESResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test

        AresAccountService.Requests req = new AresAccountService.Requests();
        req.ico = '03024130';

        List<AresAccountService.Requests> requests = new List<AresAccountService.Requests>{req};
        Test.startTest();
        List<AresAccountService.Response> results = AresAccountService.AresAccountService(requests);
        Test.stopTest();

        Assert.areEqual(1, results.size());
        AresAccountService.Response res = results[0];
        Assert.areEqual('03024130', res.account.ICO__c);
        Assert.areEqual('VELKÁ PECKA s.r.o.', res.account.Name);
        Assert.areEqual('Praha', res.account.City_Name__c);
        Assert.areEqual('18600', res.account.Zip_Code__c);
        Assert.areEqual('Česká republika', res.account.Country_Name__c);
        Assert.areEqual('Karolinská', res.account.Street_Name__c);
        Assert.areEqual('654', res.account.Building_Number__c);
        Assert.areEqual('Karlín', res.account.District_Name__c);
        Assert.areEqual('Praha 8', res.account.City_District_Name__c);
        Assert.areEqual('Hlavní město Praha', res.account.Region_Name__c);
        Assert.areEqual('Karolinská 654/2, Karlín, 18600 Praha 8', res.account.Full_Address__c);
        Assert.areEqual(true, res.success);
        Assert.areEqual(null, res.errorMessage);

    }

    @isTest
    public static void AresAccountServiceTestStatusCode400() {
  
        Test.setMock(HttpCalloutMock.class, new AresMockError(400));
        // Call method to test

        AresAccountService.Requests req = new AresAccountService.Requests();
        req.ico = 'invalid';

        List<AresAccountService.Requests> requests = new List<AresAccountService.Requests>{req};
        Test.startTest();
        List<AresAccountService.Response> results = AresAccountService.AresAccountService(requests);
        Test.stopTest();

        AresAccountService.Response res = results[0];
        Assert.areEqual('Chyba vstupu (například špatný formát IČO)', res.errorMessage);
        Assert.areEqual(false, res.success);
        Assert.areEqual(null, res.account);
    }

     @isTest
    public static void AresAccountServiceTestStatusCode404() {
  
        Test.setMock(HttpCalloutMock.class, new AresMockError(404));
        // Call method to test

        AresAccountService.Requests req = new AresAccountService.Requests();
        req.ico = 'invalid';

        List<AresAccountService.Requests> requests = new List<AresAccountService.Requests>{req};
        Test.startTest();
        List<AresAccountService.Response> results = AresAccountService.AresAccountService(requests);
        Test.stopTest();

        Assert.areEqual(1, results.size());
        AresAccountService.Response res = results[0];
        Assert.areEqual('Zdroj nenalezen', res.errorMessage);
        Assert.areEqual(false, res.success);
        Assert.areEqual(null, res.account);
    }

     @isTest
    public static void AresAccountServiceTestStatusCode401() {
  
        Test.setMock(HttpCalloutMock.class, new AresMockError(401));
        // Call method to test

        AresAccountService.Requests req = new AresAccountService.Requests();
        req.ico = 'invalid';

        List<AresAccountService.Requests> requests = new List<AresAccountService.Requests>{req};
        Test.startTest();
        List<AresAccountService.Response> results = AresAccountService.AresAccountService(requests);
        Test.stopTest();

        Assert.areEqual(1, results.size());
        AresAccountService.Response res = results[0];
        Assert.areEqual('Chyba autentizace', res.errorMessage);
        Assert.areEqual(false, res.success);
        Assert.areEqual(null, res.account);
    }

     @isTest
    public static void AresAccountServiceTestStatusCode403() {
  
        Test.setMock(HttpCalloutMock.class, new AresMockError(403));
        // Call method to test

        AresAccountService.Requests req = new AresAccountService.Requests();
        req.ico = 'invalid';

        List<AresAccountService.Requests> requests = new List<AresAccountService.Requests>{req};
        Test.startTest();
        List<AresAccountService.Response> results = AresAccountService.AresAccountService(requests);
        Test.stopTest();

        Assert.areEqual(1, results.size());
        AresAccountService.Response res = results[0];
        Assert.areEqual('Přístup zamítnut', res.errorMessage);
        Assert.areEqual(false, res.success);
        Assert.areEqual(null, res.account);
    }
     @isTest
    public static void AresAccountServiceTestStatusCode500() {
  
        Test.setMock(HttpCalloutMock.class, new AresMockError(500));
        // Call method to test

        AresAccountService.Requests req = new AresAccountService.Requests();
        req.ico = 'invalid';

        List<AresAccountService.Requests> requests = new List<AresAccountService.Requests>{req};
        Test.startTest();
        List<AresAccountService.Response> results = AresAccountService.AresAccountService(requests);
        Test.stopTest();

        Assert.areEqual(1, results.size());
        AresAccountService.Response res = results[0];
        Assert.areEqual('Neočekávaná chyba', res.errorMessage);
        Assert.areEqual(false, res.success);
        Assert.areEqual(null, res.account);
    }

     @isTest
    public static void AresAccountServiceTestException() {
  
        Test.setMock(HttpCalloutMock.class, new AresMockError(null));
        // Call method to test

        AresAccountService.Requests req = new AresAccountService.Requests();
        req.ico = null;

        List<AresAccountService.Requests> requests = new List<AresAccountService.Requests>{req};
        Test.startTest();
        List<AresAccountService.Response> results = AresAccountService.AresAccountService(requests);
        Test.stopTest();

        Assert.areEqual(1, results.size());
        AresAccountService.Response res = results[0];
        System.assertNotEquals(null, results[0].errorMessage);
        Assert.areEqual(false, res.success);
        Assert.areEqual(null, res.account);
    }
}