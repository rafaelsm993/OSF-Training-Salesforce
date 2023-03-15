/* 
Queueable Versus Future

- Queueable methods are functionally equivalent to future methods, most of the time you’ll probably want to use queueable instead of future methods.
- A reason to use future methods instead of queueable is when your functionality is sometimes executed synchronously, and sometimes asynchronously.

Syntax example:

Future 
*/
@future
static void myFutureMethod(List<String> params) {
    // call synchronous method
    mySyncMethod(params);
}

// Queueable
public class SomeClass implements Queueable {
    public void execute(QueueableContext context) {
        // awesome code here
    }
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/* Sample Code 
Because @future methods are limited to primitive data types (or arrays or collections of primitives), queueable Apex is an ideal choice. 
The following code takes a collection of Account records, sets the parentId for each record, and then updates the records in the database.
*/
public class UpdateParentAccount implements Queueable {
    private List<Account> accounts;
    private ID parent;
    public UpdateParentAccount(List<Account> records, ID id) {
        this.accounts = records;
        this.parent = id;
    }
    public void execute(QueueableContext context) {
        for (Account account : accounts) {
          account.parentId = parent;
          // perform other processing or callout
        }
        update accounts;
    }
}

// INVOKE 
// find all accounts in ‘NY’
List<Account> accounts = [select id from account where billingstate = 'NY'];
// find a specific parent account for all records
Id parentId = [select id from account where name = 'ACME Corp'][0].Id;
// instantiate a new instance of the Queueable class
UpdateParentAccount updateJob = new UpdateParentAccount(accounts, parentId);
// enqueue the job for processing
ID jobID = System.enqueueJob(updateJob);
// Monitor de Progress
SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// Testing Queueable Apex

@isTest
public class UpdateParentAccountTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        // add a parent account
        accounts.add(new Account(name='Parent'));
        // add 100 child accounts
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(
                name='Test Account'+i
            ));
        }
        insert accounts;
    }
    static testmethod void testQueueable() {
        // query for test data to pass to queueable class
        Id parentId = [select id from account where name = 'Parent'][0].Id;
        List<Account> accounts = [select id, name from account where name like 'Test Account%'];
        // Create our Queueable instance
        UpdateParentAccount updater = new UpdateParentAccount(accounts, parentId);
        // startTest/stopTest block to force async processes to run
        Test.startTest();
        System.enqueueJob(updater);
        Test.stopTest();
        // Validate the job ran. Check if record have correct parentId now
        System.assertEquals(100, [select count() from account where parentId = :parentId]);
    }
}

/* Chaining Jobs
 - You can add only one job from an executing job, which means that only one child job can exist for each parent job
 For example, if you have a second class called SecondJob that implements the Queueable interface, you can add this class to the queue in the execute() method as follows:
*/
public class FirstJob implements Queueable {
    public void execute(QueueableContext context) {
        // Awesome processing logic here
        // Chain this job to next job by submitting the next job
        System.enqueueJob(new SecondJob());
    }
}