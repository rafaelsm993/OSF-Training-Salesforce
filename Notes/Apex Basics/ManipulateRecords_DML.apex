//Create new Account (sObject)
Account test = new Account(Name='Acme', Phone='(415)555-1212', NumberOfEmployees=100);
// Insert on SalesForce
insert test;

// Get info of a sObject
ID testID =  test.id;
System.debug('ID = '+ testID);

//Update a field

Account query = [SELECT id, name FROM Account WHERE id = '001Dn00000HhEM2IAN' LIMIT 1];
query.name = 'Acm';
update query;


//----------------------------------------------------------------------------------------

//Bulk DML (Need List)
List<Contact> myList = new List<Contact>{
    new Contact(FirstName='Joe',LastName='Smith',Department='Finance'),
    new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
    new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
    new Contact(FirstName='Kim',LastName='Shain',Department='Education')
};
insert myList;

List<Contact> updateList = new List<Contact>();

for(Contact con : myList){
    if(con.Department == 'Finance'){
        con.Title = 'Financial analyst';
        updateList.add(con);
    } 
}
update updateList;

//----------------------------------------------------------------------------------------

//Database Methods (For a lot of data)
// If you want to allow partial success of a bulk DML operation—if a record fails, 
the remainder of the DML operation can still succeed.

// Create a list of contacts
List<Contact> conList = new List<Contact> {
        new Contact(FirstName='Joe',LastName='Smith',Department='Finance'),
        new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
        new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
        new Contact()};
// Bulk insert all contacts with one DML call
Database.SaveResult[] srList = Database.insert(conList, false);
// Iterate through each returned result
for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully inserted contact. Contact ID: ' + sr.getId());
    } else {
        // Operation failed, so get all errors
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Contact fields that affected this error: ' + err.getFields());
	 }
    }
}


//----------------------------------------------------------------------------------------

//Related Records

Account testAccount = new Account(Name='Test');
insert testAccount;

//Need to get the account ID
ID testAccountID = testAccount.id;

//Create a new Contact
Contact testContact = new Contact(FirstName='Mario', 
LastName='Bros',
Phone='415.555.1212',
Accountid= testAccountID);

insert testContact;


//Change Account field through contact (Need a separate call), need to select Account.Name to change related Account info
Contact test = [SELECT id, Account.Name FROM Contact WHERE FirstName = 'Mario' and LastName = 'Bros' LIMIT 1];

//Update just a Conatact field
test.Phone = '(415)555-1213';
//Update a Account field
test.Account.Industry = 'Technology';

// First Call
update test;
// Second Call
update test.Account;
