public with sharing class exercise04ExtensionClass {
    public Map<String, String> weatherData { get; set; }
    
    public exercise04ExtensionClass(ApexPages.StandardController controller) {
        String cityName = (String)controller.getRecord().get('BillingCity');
        weatherData = getWeather(cityName);
    }
    
    public static Map<String, String> getWeather(String cityName) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.openweathermap.org/data/2.5/weather?q=' + cityName + '&appid=a5647ca659adaeb55ad536705a446dbd&units=metric');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Map<String, String> weatherData = new Map<String, String>();

        if(response.getStatusCode() == 200){
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> mainMap = (Map<String, Object>) result.get('main');
            List<Object> weatherList = (List<Object>) result.get('weather');
            Map<String, Object> weatherMap = (Map<String, Object>) weatherList[0];
            weatherData.put('temperature', String.valueOf(mainMap.get('temp')));
            weatherData.put('description', String.valueOf(weatherMap.get('description')));
            weatherData.put('iconCode', String.valueOf(weatherMap.get('icon')));
        }
        return weatherData;
    }
}
