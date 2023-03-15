@isTest
private with sharing class AccountProcessorTest {
    @isTest
    private static void AccountProcessorTest() {
        List<Id> ids = new List<id>();
        Id accId = createAcc();
        ids.add(accId);

        Test.startTest();
        AccountProcessor.countContacts(ids);
        Test.stopTest();
        
    }

    private static Id createAcc(){
        Account test = new Account(Name='testAccount1');
        insert test;
        createCont(test.Id);
        return test.Id;
    }
    private static void createCont(Id accId){
        List<Contact> contList = new List<Contact>();

        for(Integer i=0; i<4; i++){
            Contact con = new Contact(FirstName='test '+i, LastName='TEST', AccountId=accId);
            contList.add(con);
        }
        insert contList;
    }

}