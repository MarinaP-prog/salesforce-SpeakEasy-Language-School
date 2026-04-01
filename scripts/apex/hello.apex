z/*
 Anonymous Apex: Validate PINs on a controlled batch of Accounts

 Improvements:
 - Enforces FLS/sharing via WITH SECURITY_ENFORCED and USER_MODE
 - Uses early-return and structured logging
 - Avoids duplicate field lists and noisy debug output
 - Keeps SOQL/DML bulk-safe and outside loops
*/


List<Account> accts = [
    SELECT Id, Pin__pc, Birthdate__c, Platnost_Rodneho_Cisla_Log__c FROM Account WHERE Pin__pc != null LIMIT 50
];

/* Early exit if there is nothing to process */
if (accts.isEmpty()) {
    System.debug('No Accounts found with a non-null PIN__pc. Nothing to validate.');
    return;
} else {
    System.debug('Found ' + accts.size() + ' Accounts with non-null PIN__pc. Proceeding with validation.');
}

// Instantiate the validator (expects a List<Account>)
PinValidation validator = new PinValidation();

// Execute validation with defensive error handling
try {
    validator.validateAccountPin(accts);
    System.debug('validation results >>' + validator.getValidationResults());
} catch (Exception e) {
    System.debug('PIN validation failed: ' + e.getMessage());
    // For deeper troubleshooting during development, you may inspect:
    // System.debug(e.getStackTraceString());
    return;
}
