/*
1.  Create a custom field on the Contact object: Primary Contact Phone(Phone);

2.  Validation should be added so that if the Account already has a Primary Contact set a new one cannot be added;

3.  When contact is set as primary, the Primary Contact Phone should be updated to all Contacts related to the same account. 
    This should be an asynchronous process. Make sure that if one Contact update fails, it doesn’t roll back the changes for the others.
*/
trigger primaryContact on Contact (before insert, before update) {
    Set<Id> accountIds = new Set<Id>();
    Map<Id, String> primaryContactPhonesByAccount = new Map<Id, String>();
    List<Contact> nonPrimaryContactsToUpdate = new List<Contact>();

    // Collect all account Ids referenced by the contacts being processed
    for (Contact contact : Trigger.new) {
        accountIds.add(contact.AccountId);
    }

    // Query for all primary contacts for these accounts, along with their phone numbers
    for (Contact primaryContact : [SELECT AccountId, Phone FROM Contact WHERE AccountId IN :accountIds AND IsPrimaryContact__c = true]) {
        primaryContactPhonesByAccount.put(primaryContact.AccountId, primaryContact.Phone);
    }

    // Loop through the Contacts being processed
    for (Contact contact : Trigger.new) {
        // If this Contact is becoming a primary contact, make sure no other primary contacts exist for its account
        if (contact.IsPrimaryContact__c && (Trigger.isInsert || contact.IsPrimaryContact__c != Trigger.oldMap.get(contact.Id).IsPrimaryContact__c)) {
            if ([SELECT COUNT() FROM Contact WHERE AccountId = :contact.AccountId AND IsPrimaryContact__c = true] > 0) {
                contact.IsPrimaryContact__c.addError('An account can only have one primary contact.');
            }
        }
        // If this Contact is not the primary contact, make sure it has the same phone as the primary contact for its account
        else if (!contact.IsPrimaryContact__c && primaryContactPhonesByAccount.containsKey(contact.AccountId)) {
            String primaryContactPhone = primaryContactPhonesByAccount.get(contact.AccountId);
            if (contact.PrimaryContactPhone__c != primaryContactPhone || contact.PrimaryContactPhone__c == null) {
                contact.PrimaryContactPhone__c = primaryContactPhone;
                nonPrimaryContactsToUpdate.add(contact);
            }
        }
    }

    // Update non-primary contacts to reflect the phone number of the primary contact for their account
    if (!nonPrimaryContactsToUpdate.isEmpty()) {
        update nonPrimaryContactsToUpdate;
    }
}

