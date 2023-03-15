/*
- Create an Apex class that uses Batch Apex to update Lead records.
- Create an Apex class that implements the Database.Batchable interface to update all Lead records in the org with a specific LeadSource.

- Create an Apex class:
    * Name: LeadProcessor
    * Interface: Database.Batchable
    * Use a QueryLocator in the start method to collect all Lead records in the org
    * The execute method must update all Lead records in the org with the LeadSource value of Dreamforce

    - Create an Apex test class:
    * Name: LeadProcessorTest
    * In the test class, insert 200 Lead records, execute the LeadProcessor Batch class and test that all Lead records were updated correctly
    * The unit tests must cover all lines of code included in the LeadProcessor class, resulting in 100% code coverage

- Before verifying this challenge, run your test class at least once using the Developer Console Run All feature

*/


public with sharing class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    public Integer recordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope){
        List<Lead> toUpdate = new List<Lead>();
        for(Lead l:scope){
            l.LeadSource = 'Dreamforce';
            toUpdate.add(l);
            recordsProcessed = recordsProcessed + 1;
        }
        update toUpdate;
    }
    public void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }
}