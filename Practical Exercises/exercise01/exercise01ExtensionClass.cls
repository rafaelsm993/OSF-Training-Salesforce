public with sharing class exercise01ExtensionClass {
    public Id contactId { get; set; }
    

    // Add constructor that takes a StandardController parameter
    public exercise01ExtensionClass(ApexPages.StandardController controller) {
        contactId = controller.getId();
    }

    public PageReference updateField() {
        
        Contact conData = [SELECT Id, IsPrimaryContact__c FROM Contact WHERE Id = :contactId];
        conData.IsPrimaryContact__c = true;

        update conData;

        // Redirect the user back to the Visualforce page
        return new PageReference('/apex/popup');
    }
}
