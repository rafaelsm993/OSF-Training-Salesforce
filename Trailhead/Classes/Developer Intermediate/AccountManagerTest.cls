@isTest
public with sharing class AccountManagerTest {
    @isTest
    public static void AccountManagerTest() {
        Id recordId = createTestRecord();
        
        RestRequest request = new RestRequest();
        request.requestURI = 'https://playful-koala-b3ettl-dev-ed.trailblaze.my.salesforce.com/Accounts/'+ recordId +'/contacts';
        request.httpMethod = 'GET';
        
        RestContext.request = request; //If the method you're testing accesses request values through RestContext, assign the request to RestContext to populate it
        Account test = AccountManager.getAccount();
        
        System.assert(test != null);
    }

    // Helper method
    static Id createTestRecord() {
        // Create test record
        Account accTest = new Account(
            Name='Test record');

        Contact conTest = new Contact(
            AccountId = accTest.Id,
            FirstName='Test',
            LastName='Contact');

        insert accTest;
        insert conTest;

        return accTest.Id;
    }   
}

