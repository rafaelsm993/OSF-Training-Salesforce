/*
Requirements:
    1. Create a batch class that summarizes all Opportunity Amounts for each Account;
    2. An email should be sent to the primary contact of all Accounts,
    containing a table with the Closed Won/Open/Closed Lost summarized Opportunity Amounts;
    3. The schedulable class that calls the batch class should be created;
    4. The class should be scheduled from the Developer Console.
    Please provide the script to schedule the job daily at 10:00 AM, once a week (Friday at 1:00 PM),
    once a month(Last Friday of the Month at 6:00 PM).
*/

global with sharing class exercise03BatchClass implements Database.Batchable<SObject> {
   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all accounts and their related opportunities
        return Database.getQueryLocator(
            'SELECT Id, (SELECT Id FROM Opportunities) FROM Account'
        );
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        // Set the same list of accounts as the batch's state
        BC.getJobExecutionContext().put('scope', scope);
        // Create a list of custom object records to store the related opportunities
        List<exercise03Object__c> accountOpps = new List<exercise03Object__c>();
        for (Account acc : scope) {
            // Create a new custom object record for the account
            exercise03Object__c accOpp = new exercise03Object__c();
            accOpp.accId__c = acc.Id;
            // Serialize the opportunities as JSON and store them in a custom field on the record
            accOpp.opps__c = JSON.serialize(acc.Opportunities);
            accountOpps.add(accOpp);
        }
        // Insert the custom object records
        insert accountOpps;
    }
    global void finish(Database.BatchableContext BC, List<Account> scope) {
       
        // Get a list of Account IDs from the scope
        List<Id> accountIds = new List<Id>();
        for (Account acc : (List<Account>)scope) {
            accountIds.add(acc.Id);
        }
   
        // Query the custom object to get the related opportunities for the accounts
        List<exercise03Object__c> accOpps = [SELECT Id, accId__c, opps__c FROM exercise03Object__c WHERE accId__c IN :accountIds];
   
        // Map the account IDs to their corresponding primary contact IDs
        Map<Id, Id> accIdToContactId = new Map<Id, Id>();
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE IsPrimaryContact__c = true AND AccountId IN :accountIds]) {
            accIdToContactId.put(con.AccountId, con.Id);
        }
   
        // Loop through the accounts and send the email to their primary contacts
        for (exercise03Object__c accOpp : accOpps) {
            Id contactId = accIdToContactId.get(accOpp.accId__c);
            if (contactId != null) {
                // Create the email message and set the recipient
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{Contact.getSobjectType().getDescribe().getKeyPrefix() + contactId});
   
                // Set the email template and merge fields
                email.setTemplateId('00XDn00000136nl');
                email.setTargetObjectId(contactId);
   
                // Set the merge field values for the email template
                email.setTemplateData(new Map<String, Object>{
                    'AccountName' => accOpp.accId__r.Name,
                    'oppList' => (List<Opportunity>)JSON.deserialize(accOpp.opps__c, List<Opportunity>.class)
                });
   
                // Send the email
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
            }
        }
    }
   
}