/* 
When you use bulk design patterns, your triggers have better performance, 
consume less server resources, 
and are less likely to exceed platform limits.

The benefit of bulkifying your code is that bulkified code can process large numbers of records efficiently
*/

//EXAMPLE:
trigger MyTriggerBulk on Account(before insert){
    for(Account a:Trigger.new){
        a.Description = 'Testing Bulk'
    }
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

// * BULK WITH SOQL

//Without bulking
trigger SoqlTriggerNotBulk on Account(after update) {   
    for(Account a : Trigger.new) {
        // Get child records for each account
        // Inefficient SOQL query as it runs once for each account!
        Opportunity[] opps = [SELECT Id,Name,CloseDate 
                             FROM Opportunity WHERE AccountId=:a.Id];
        // Do some other processing
    }
}
//Runs the query many times 'cause it's in loop

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

//With bulking
trigger SoqlTriggerBulk on Account(after update) {
    // * Perform SOQL query once.    
    // Get the accounts and their related opportunities.
    List<Account> acctsWithOpps = [SELECT Id,(SELECT Id,Name,CloseDate FROM Opportunities)  
    FROM Account WHERE Id IN :Trigger.new];
    
    
    
    for(Account a:acctsWithOpps){
        Opportunity[] relatedOpps = a.Opportunities;
        // Do some other processing
    }
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

//BULK DML

//Without Bulking
trigger DmlTriggerNotBulk on Account(after update) {   
    // Get the related opportunities for the accounts in this trigger.        
    List<Opportunity> relatedOpps = [SELECT Id,Name,Probability FROM Opportunity
        WHERE AccountId IN :Trigger.new];          
    // Iterate over the related opportunities
    for(Opportunity opp : relatedOpps) {      
        // Update the description when probability is greater 
        // than 50% but less than 100% 
        if ((opp.Probability >= 50) && (opp.Probability < 100)) {
            opp.Description = 'New description for opportunity.';
            // * Update once for each opportunity -- not efficient!
            update opp;
        }
    }    
}

//With Bulking
trigger DmlTriggerBulk on Account(after update){
    List<Opportunity> relatedOpps = [SELECT Id,Name,Probability FROM Opportunity
        WHERE AccountId IN :Trigger.new]; 
    
    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    
    // Iterate over the related opportunities
    for(Opportunity opp:relatedOpps){
        // Update the description when probability is greater 
        // than 50% but less than 100% 
        if((opp.Probability >= 50) && (opp.Probability < 100)){
            opp.Description = 'Testing Bulking DML';
            oppsToUpdate.add(opp)
        } 
    }
    // Perform DML on a collection
    update oppsToUpdate;
}

