@IsTest
private class PinValidationTest {
    @IsTest
    private static void testValidScenario() {
        Account account = new Account(
            LastName = 'PIN and BD valid',
            PIN__c = '0403121235',
            PersonBirthdate = Date.newInstance(2004, 3, 12),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual(null, updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testInvalidDateFromPINWithReminderOfTen() {
        Account account = new Account(
            LastName = 'PIN and BD valid',
            PIN__c = '1000000090', // remainder of Math.mod is 10
            PersonBirthdate = Date.newInstance(2010, 1, 1),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Neplatný datum z rodného čísla', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINNotequalPersonBirthdateScenario() {
        Account account = new Account(
            LastName = 'PIN and BD different',
            PIN__c = '0403121235',
            PersonBirthdate = Date.newInstance(2009, 3, 12),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Rodné číslo neodpovídá datu narození o 1826 dnů', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINIsEmptyScenario() {
        Account account = new Account(
            LastName = 'Missing PIN',
            PIN__c = null,
            PersonBirthdate = Date.newInstance(2004, 3, 12),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Chybí rodné číslo', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPersonBirthdateIsEmptyScenario() {
        Account account = new Account(
            LastName = 'Missing BD',
            PIN__c = '0403121235',
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Chybí datum narození', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPersonBirthdateIsEmptyAndInvalidNineDigitPIN() {
        Account account = new Account(
            LastName = 'Missing BD And Invalid Nine Digit PIN',
            PIN__c = '424213413',
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Neplatný datum z rodného čísla / Chybí datum narození', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPersonBirthdateAndPINAreEmptyScenario() {
        Account account = new Account(
            LastName = 'Missing PIN and BD',
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Chybí rodné číslo', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINIsInvalidScenario() {
        Account account = new Account(
            LastName = 'Invalid PIN',
            PIN__c = '0552296788',
            PersonBirthdate = Date.newInstance(2005, 2, 28),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Nesedí modulo / Neplatný datum z rodného čísla', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPersonBirthdateIsInFutureScenario() {
        Account account = new Account(
            LastName = 'BD in future',
            PIN__c = '0403121235',
            PersonBirthdate = Date.newInstance(2034, 3, 12),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Rodné číslo neodpovídá datu narození o 10957 dnů / Rok narození je v budoucnu', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINLengthIsSixScenario() {
        Account account = new Account(
            LastName = 'PIN only 6 digits',
            PIN__c = '040312',
            PersonBirthdate = Date.newInstance(2004, 3, 12),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Délka rodného čísla je nesprávná', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINEndsFourZerosScenario() {
        Account account = new Account(
            LastName = 'PIN ends with 0000',
            PIN__c = '0403120000',
            PersonBirthdate = Date.newInstance(2004, 3, 12),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual(null, updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINIsLessThan54Scenario() {
        Account account = new Account(
            LastName = 'PIN before 1954',
            PIN__c = '5303120000',
            PersonBirthdate = Date.newInstance(1953, 3, 12),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual(null, updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }


    @IsTest
    private static void testPersonBirthdateIsEmptyAndModuloInvalidScenario() {
        Account account = new Account(
            LastName = 'Invalid PIN and BD missing',
            PIN__c = '0403121234',
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Nesedí modulo / Chybí datum narození', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPersonBirthdateIsEmptyAndPINIsValidScenario() {
        Account account = new Account(
            LastName = 'Valid PIN and missing BD',
            PIN__c = '7704063345',
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Chybí datum narození', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testOldPINIsValidScenario() {
        Account account = new Account(
            LastName = 'Old PIN',
            PIN__c = '530406334',
            PersonBirthdate = Date.newInstance(1953, 04, 06),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual(null, updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testNewPINHasNineDigitsScenario() {
        Account account = new Account(
            LastName = 'New PIN with 9 digits',
            PIN__c = '550406334',
            PersonBirthdate = Date.newInstance(1955, 04, 06),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Datum narození je po roce 1954, ale rodné číslo má pouze 9 číslic', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINIsValidMinus70Scenario() {
        Account account = new Account(
            LastName = 'Valid PIN minus 70',
            PIN__c = '0774061233',
            PersonBirthdate = Date.newInstance(2007, 04, 06),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual(null, updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINIsValidMinus20Scenario() {
        Account account = new Account(
            LastName = 'Valid PIN minus 20',
            PIN__c = '0724060007',
            PersonBirthdate = Date.newInstance(2007, 04, 06),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual(null, updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINContainsLetterScenario() {
        Account account = new Account(
            LastName = 'A letter in PIN',
            PIN__c = '0724k60007',
            PersonBirthdate = Date.newInstance(2007, 04, 06),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Nesedí formát rodného čísla', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testPINContainsBackslashScenario() {
        Account account = new Account(
            LastName = 'PIN with "/"',
            PIN__c = '072406/0007',
            PersonBirthdate = Date.newInstance(2007, 04, 06),
            Platnost_Rodneho_Cisla_Log__c = null
        );
        insert account;

        Test.startTest();
        PinValidation.validateAccountPin(new List<Account>{account});
        Test.stopTest();

        Account updatedAcc = [SELECT Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Id = :account.Id LIMIT 1];
        Assert.areEqual('Rodné číslo obsahuje "/"', updatedAcc.Platnost_Rodneho_Cisla_Log__c);
    }

    @IsTest
    private static void testAccountWithoutPIN() {
        Account account = new Account();
       
        PinValidation.validateAccountPin(new List<Account>{account});
        Assert.areEqual('Chybí rodné číslo', account.Platnost_Rodneho_Cisla_Log__c);
    }


}