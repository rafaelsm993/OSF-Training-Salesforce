/* 
CONTEXT VARIABLES
To access records that caused the trigger to fire.

- Trigger.new: Contains all the records that were inserted in INSERT or UPDATE triggers. 
- Trigger.old: Contains the old version of sObjects before they were updated in update triggers, 
or a list of deleted sObjects in delete triggers.

This example is a modified version of the HelloWorldTrigger example trigger. 
It iterates over each account in a for loop and updates the Description field for each.
*/

trigger HelloWorldTrigger on Account (before insert) {
    for(Account a : Trigger.new) {
        a.Description = 'New description';
    }   
}

/*
TRIGGER EXCEPTIONS
To add restriction on certain database operations.

- To prevent a operation use addError() method on the sObject in question.

EXAMPLE:

This trigger prevents DELETION of an account if it has related opportuinities.
By default, deleting an account causes a cascade delete of all its related records. 

* This trigger prevents the cascade delete of opportunities.
*/

trigger AccountDeletion on Account (before delete) {
    // Prevent the deletion of accounts if they have related opportunities.
    for (Account a : [SELECT Id FROM Account
                     WHERE Id IN (SELECT AccountId FROM Opportunity) AND
                     Id IN :Trigger.old]) {
        Trigger.oldMap.get(a.Id).addError(
            'Cannot delete account with related opportunities.');
    }
}