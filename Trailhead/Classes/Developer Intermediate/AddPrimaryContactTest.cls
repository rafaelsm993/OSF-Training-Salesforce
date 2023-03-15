@isTest
public with sharing class AddPrimaryContactTest {
    static testmethod void AddPrimaryContact() {
        List<Account> newAcc = new List<Account>();
        for(Integer i = 0; i<=50; i++){
            newAcc.add(new Account(Name='Test'+i, BillingState='NY'));
            newAcc.add(new Account(Name='Test'+i+10, BillingState='CA'));
        }
        insert newAcc;    

        Contact test = new Contact(FirstName='John', LastName='Doe');
        insert test;

        AddPrimaryContact updater = new AddPrimaryContact(test, 'CA');

        // startTest/stopTest block to force async processes to run
        
        System.Test.startTest();
        System.enqueueJob(updater);
        System.Test.stopTest();
        // Validate the job ran. Check if record have correct parentId now
        System.assertEquals(50, [SELECT count() FROM Contact WHERE AccountId IN (SELECT Id FROM Account WHERE BillingState='CA')]);
    }
}
