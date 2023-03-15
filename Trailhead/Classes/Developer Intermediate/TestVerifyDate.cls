/*

Create a Unit Test for a Simple Apex Class
Create and install a simple Apex class to test if a date is within a proper range, and if not, returns a date that occurs at the end of the month within the range. 
You'll copy the code for the class from GitHub. Then write unit tests that achieve 100% code coverage.

Create an Apex class:

* Name: VerifyDate
* Code: Copy from GitHub
* Place the unit tests in a separate test class:
* Name: TestVerifyDate
* Goal: 100% code coverage
* Run your test class at least once

*/


@isTest
public class TestVerifyDate {
    @isTest static void testDateWithin30Days(){
        Date test = VerifyDate.CheckDates(Date.valueOf('2023-03-01'), Date.valueOf('2023-03-10'));
        System.assertEquals(Date.valueOf('2023-03-10'), test, "date1 is within 30 days to date2");
        
        Date test1 = VerifyDate.CheckDates(Date.valueOf('2023-03-01'), Date.valueOf('2023-05-10'));
        System.assertEquals(Date.valueOf('2023-03-31'), test1,  "date1 is not within 30 days to date2");
        
    }
}