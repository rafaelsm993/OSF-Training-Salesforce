public with sharing class ContactAndLeadSearch {
    public static List<List< sObject>> searchContactsAndLeads(String input){
        List<List <sObject>> query = [FIND :input IN NAME FIELDS RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)];
        Contact[] cont = (Contact[])query[0];
        Lead[] leads = (Lead[])query[1];
        System.debug('CONTACTS: ');
        for(Contact c : cont){
            System.debug(c.FirstName + ' ' + c.LastName);
        }
        System.debug('LEADS: ');
        for(Lead l : leads){
            System.debug(l.FirstName + ' ' + l.LastName);
        }

        return query;
    }
}