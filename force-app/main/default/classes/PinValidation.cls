public with sharing class PinValidation {
    public static void validateAccountPin(List<Account> accounts) {
    
        for (Account account : accounts) {
           processSingleAccount(account);
        }
    }


    private static void processSingleAccount(Account account){
        try {
            validateAccountPin(account);

        } catch (Exception e) {
            System.debug('error >>' + e.getMessage()); 
        }
    }

    private static void checkOldPinFormat(PINValidationWrapper wrapper, Account account){
         wrapper.yearFromPinAsInteger += 1900;

           if (wrapper.yearFromPinAsInteger >= 1954) {
            account.Platnost_Rodneho_Cisla_Log__c += 'Datum narození je po roce 1954, ale rodné číslo má pouze 9 číslic / ';
           }
    }

    private static void validateAccountPin(Account account){

         if (String.isBlank(account?.PIN__c)) {
                account.Platnost_Rodneho_Cisla_Log__c = 'Chybí rodné číslo';
                return;
            }

        PINValidationWrapper wrapper = new PINValidationWrapper();
        account.Platnost_Rodneho_Cisla_Log__c = '';

        if (account.PIN__c.contains('/')) {
            account.Platnost_Rodneho_Cisla_Log__c += 'Rodné číslo obsahuje "/" / ';
        }

        wrapper.pin = account.PIN__c.replace('/', '');

         if (wrapper.pin.length() != 9 && wrapper.pin.length() != 10) {
            account.Platnost_Rodneho_Cisla_Log__c += 'Délka rodného čísla je nesprávná';
            return;
        }

        if (!isPinFormatValid(wrapper)) {
            account.Platnost_Rodneho_Cisla_Log__c += 'Nesedí formát rodného čísla';
            return;
        }

         setWrapperValues(wrapper);

        if (wrapper.pin.length() == 9) {
           checkOldPinFormat(wrapper, account);
        }

        if (wrapper.pin.length() == 10) {
           checkNewPinFormat(wrapper, account);
        }

        setMonthFromPIN(wrapper);
        validatePersonBirthdate(account, wrapper);

        account.Platnost_Rodneho_Cisla_Log__c = account.Platnost_Rodneho_Cisla_Log__c.substringBeforeLast(' / ');
    }

    private static void checkNewPinFormat(PINValidationWrapper wrapper, Account account) {
         wrapper.yearFromPinAsInteger += 2000;

            if (wrapper.yearFromPinAsInteger > wrapper.currentYear) {
                wrapper.yearFromPinAsInteger -= 100;
            }

            wrapper.lastFourDigitsAsString = wrapper.pin.substring(6,10);
            if (wrapper.lastFourDigitsAsString != '0000' && wrapper.lastFourDigitsAsString != '9999') {
               checkModulo(wrapper, account);
            }
    }

    private static void checkModulo(PINValidationWrapper wrapper, Account account) { 
        Long numberPart = Long.valueOf(wrapper.pin.substring(0,9));
        Integer controlDigit = Integer.valueOf(wrapper.pin.substring(9,10));
        Long mod = Math.mod(numberPart, 11);
        if (mod == 10) {
            mod = 0;
        }

        if (mod != controlDigit) {
            account.Platnost_Rodneho_Cisla_Log__c += 'Nesedí modulo / ';

        }
    }

    private static void setMonthFromPIN(PINValidationWrapper wrapper) {
        if (wrapper.monthFromPinAsInteger > 70 && wrapper.yearFromPinAsInteger > 2003) {
            wrapper.monthFromPinAsInteger -= 70;
        } else if (wrapper.monthFromPinAsInteger > 50) {
            wrapper.monthFromPinAsInteger -= 50;
        } else if (wrapper.monthFromPinAsInteger > 20 && wrapper.yearFromPinAsInteger > 2003) {
            wrapper.monthFromPinAsInteger -= 20;
        }
    }
    private static void validatePersonBirthdate(Account account, PINValidationWrapper wrapper) {
        Date dateFromPin;

        try {
            dateFromPin = Date.valueOf(wrapper.yearFromPinAsInteger + '-' + wrapper.monthFromPinAsInteger + '-' + wrapper.dayFromPinAsInteger);
        } catch (Exception e) {
            account.Platnost_Rodneho_Cisla_Log__c += 'Neplatný datum z rodného čísla / ';
        }

        if (account.PersonBirthdate == null) {
            account.Platnost_Rodneho_Cisla_Log__c += 'Chybí datum narození / ';
            return;
        }

        if (dateFromPin != null && dateFromPin != account.PersonBirthdate) {
            Integer differenceInDays = dateFromPin.daysBetween(account.PersonBirthdate);
            differenceInDays = differenceInDays < 0 ? -differenceInDays : differenceInDays;
            String daysInCzech = differenceInDays == 1 ? ' den' : differenceInDays > 1 && differenceInDays < 5 ? ' dny' : ' dnů' ;
            account.Platnost_Rodneho_Cisla_Log__c += 'Rodné číslo neodpovídá datu narození o ' + differenceInDays + daysInCzech + ' / ';
        }

        wrapper.fullYearFromPersonBirthdate = account.PersonBirthdate.year();

        if (wrapper.fullYearFromPersonBirthdate > wrapper.currentYear) {
            account.Platnost_Rodneho_Cisla_Log__c += 'Rok narození je v budoucnu / ';
        }
    }

      private static Boolean isPinFormatValid(PINValidationWrapper wrapper) {
        // checking that PIN contains only numbers
        Pattern pinFormatPattern = Pattern.compile('^[0-9]+$');
        Matcher pinFormatMatcher = pinFormatPattern.matcher(wrapper.pin);
        Boolean isPinFormatValid = pinFormatMatcher.matches();
        return isPinFormatValid;
    }

     private static void setWrapperValues(PINValidationWrapper wrapper) {
        wrapper.yearFromPinAsString = wrapper.pin.substring(0, 2);
        wrapper.monthFromPinAsString = wrapper.pin.substring(2, 4);
        wrapper.dayFromPinAsString = wrapper.pin.substring(4, 6);
        wrapper.yearFromPinAsInteger = Integer.valueOf(wrapper.yearFromPinAsString);
        wrapper.monthFromPinAsInteger = Integer.valueOf(wrapper.monthFromPinAsString);
        wrapper.dayFromPinAsInteger = Integer.valueOf(wrapper.dayFromPinAsString);
        wrapper.currentYear = Date.today().year();
    }

    private class PINValidationWrapper {
        private String pin;
        private String yearFromPinAsString;
        private String monthFromPinAsString;
        private String dayFromPinAsString;
        private Integer yearFromPinAsInteger;
        private Integer monthFromPinAsInteger;
        private Integer dayFromPinAsInteger;
        private String lastFourDigitsAsString;
        private Integer fullYearFromPersonBirthdate;
        private Integer currentYear;
    }
}
