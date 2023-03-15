public with sharing class ContactSearch {
    public static Contact[] searchForContacts(String lastName, String mail){
        Contact[] query = [SELECT Id, Name FROM Contact WHERE (LastName=:lastName AND MailingPostalCode=:mail)];
        return query;
    }
}