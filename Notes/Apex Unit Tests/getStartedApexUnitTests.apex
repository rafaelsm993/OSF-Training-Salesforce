/* 
Syntax - Test methods are defined using the @isTest annotation and have the following syntax:
*/

@isTest static void testName() {
    // code_block
}

//Test methods must be defined in test classes, which are classes annotated with @isTest. This sample class shows a definition of a test class with one test method.

@isTest
private class MyTestClass {
    @isTest static void myTest() {
        // code_block
    }
}

//EXAMPLE:
@isTest
private class TemperatureConverterTest {
    @isTest static void testWarmTemp() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(70);
        //The verifications are done by calling the System.assertEquals() method
        System.assertEquals(21.11,celsius);
    }
    @isTest static void testFreezingPoint() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(32);
        System.assertEquals(0,celsius);
    }
    @isTest static void testBoilingPoint() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(212);        
        System.assertEquals(100,celsius,'Boiling point temperature is not expected.');
    } 
    @isTest static void testNegativeTemp() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(-10);
        System.assertEquals(-23.33,celsius);
    }
}
/* System.assertEquals() method takes two parameters: the first is the expected value, and the second is the actual value
You can hava a third parameter but it's option, this parameter receive a string that is logged if the ASSERTION FAILS.