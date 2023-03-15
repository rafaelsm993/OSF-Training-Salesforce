// Callout Class
public class AwesomeCalculator {
    public static Double add(Double x, Double y) {
        calculatorServices.CalculatorImplPort calculator = 
            new calculatorServices.CalculatorImplPort();
        return calculator.doAdd(x,y);
    }
}

// Callout Mock
@isTest
global class CalculatorCalloutMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        calculatorServices.doAddResponse response_x = 
            new calculatorServices.doAddResponse();
        response_x.return_x = 3.0;
        // end
        response.put('response_x', response_x); 
   }
}

// Unit Test
@isTest
private class AwesomeCalculatorTest {
    @isTest static void testCallout() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new CalculatorCalloutMock());
        // Call the method that invokes a callout
        Double x = 1.0;
        Double y = 2.0;
        Double result = AwesomeCalculator.add(x, y);
        // Verify that a fake result is returned
        System.assertEquals(3.0, result); 
    }
}