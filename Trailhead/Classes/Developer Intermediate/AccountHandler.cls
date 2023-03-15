public with sharing class AccountHandler {
    public static Account insertNewAccount(String accName){
        try{
            Account newAccount = new Account(Name = accName);
            insert newAccount;
            return newAccount;
        } catch (DmlException e){
            System.debug('A DML exception has occurred: ' + e.getMessage());
            return null;
        } 
    } 
}