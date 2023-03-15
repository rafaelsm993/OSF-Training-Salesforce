/*Create a bulkified Apex trigger that adds a follow-up task to an opportunity if its stage is Closed Won. 
Fire the Apex trigger after inserting or updating an opportunity.*/

trigger ClosedOpportunityTrigger on Opportunity (after update, after insert) {
    List<Opportunity> Opps = [SELECT Id, StageName FROM Opportunity WHERE Id IN :Trigger.new];
    List<Task> tasks = new List<Task>();

    for(Opportunity o:Opps){
        if(o.StageName == 'Closed Won'){
            tasks.add(New Task(Subject = 'Follow Up Test Task', WhatId = o.Id));
        }
    }

    if(tasks.size() > 0){
        insert tasks;
    }
}