// Trigger Example 

trigger restrictContactByName on Contact (before insert) {
    //check contacts prior to insert or update for invalid data
	for (Contact c : Trigger.New) {
		if(c.LastName == 'INVALIDNAME') {	//invalidname is invalid
			c.AddError('The Last Name "'+c.LastName+'" is not allowed for DML');
		}

	}
}

// Testing the trigger

@IsTest
public class TestRestrictContactByName {
    @IsTest static void testTrigger(){
        Contact test = New Contact(LastName = 'INVALIDNAME');
        
		System.Test.startTest();
		Database.SaveResult result = Database.insert(test, false);
        System.Test.stopTest();
        
        System.Assert(!result.isSuccess());
               
    }
}