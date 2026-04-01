trigger PinValidationTrigger on Account (before insert, before update) {
    List<Account> accountsToValidate = new List<Account>();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            for (Account acc : Trigger.new) {
                if (acc.IsPersonAccount == true) {
                    accountsToValidate.add(acc);
                }
            }
        }
        if (Trigger.isUpdate) {
            for (Account acc : Trigger.new) {
                Account oldAcc = Trigger.oldMap.get(acc.Id);
                if ((acc.PIN__c != oldAcc.PIN__c) || (acc.PersonBirthdate != oldAcc.PersonBirthdate)) {
                accountsToValidate.add(acc);
                } 
            }
        }
    }
    
    if (!accountsToValidate.isEmpty()) {
        PinValidation.validateAccountPin(accountsToValidate);
        System.debug('accountsToValidate >>' + accountsToValidate);
    }

}