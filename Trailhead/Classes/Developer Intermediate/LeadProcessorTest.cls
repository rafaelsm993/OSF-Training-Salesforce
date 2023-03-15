@isTest
private with sharing class LeadProcessorTest {
    @TestSetup
    static void makeData(){
        List<Lead> leads = new List<Lead>();
        for(Integer i=0; i<=10; i++){
            Lead newLead = new Lead(FirstName='test'+i, LastName='TEST', Company='test'+10+i);
            leads.add(newLead);
        }
        insert leads;
    }
    @isTest
    static void LeadProcessorTest() {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchid = Database.executeBatch(lp);
        Test.stopTest();
        }
}