/*
Generate an Apex class using WSDL2Apex and write a test class.

Generate an Apex class using WSDL2Apex for a SOAP web service, 
write unit tests that achieve 100% code coverage for the class using a mock response, and run your Apex tests.

Prework: Be sure the Remote Sites from the first unit are set up.

- Generate a class using this using this WSDL file:
    
    * Name: ParkService (Tip: After you click the Parse WSDL button, 
    change the Apex class name from parksServices to ParkService)
    
    * Class must be in public scope

- Create a class:
    * Name: ParkLocator
    * Class must have a country method that uses the ParkService class
    * Method must return an array of available park names for a particular country passed to the web service (such as Germany, India, Japan, and United States)

- Create a test class:
    * Name: ParkLocatorTest
    * Test class uses a mock class called ParkServiceMock to mock the callout response

- Create unit tests:
    * Unit tests must cover all lines of code included in the ParkLocator class, resulting in 100% code coverage.
    * Run your test class at least once (via Run All tests the Developer Console) before attempting to verify this challenge.
*/


public with sharing class ParkLocator {
    public static List<String> country(String countryName) {
        ParkService.ParksImplPort parkservice = new ParkService.ParksImplPort();
        return parkservice.byCountry(countryName);
    }
}