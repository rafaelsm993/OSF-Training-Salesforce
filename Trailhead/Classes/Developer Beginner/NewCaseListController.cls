public with sharing class NewCaseListController {
    public List<Case> getNewCases(){
        List<Case> query = [SELECT Id, Subject, Contact.Name, Account.Name, CaseNumber FROM Case WHERE Status = 'New'];
        return query;
    }
}