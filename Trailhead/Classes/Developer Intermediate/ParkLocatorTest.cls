@isTest
public with sharing class ParkLocatorTest {
    @isTest static void ParkLocatorTest() {
        Test.setMock(WebServiceMock.class, new ParkServiceMock());

        String country = 'United States';
        List<String> result = ParkLocator.country(country);
        
        List<String> parks = new List<String>();
            parks.add('Yosemite');
            parks.add('Yellowtone');
            parks.add('Another Park');
            
        System.assertEquals(parks, result);       

    }
}

