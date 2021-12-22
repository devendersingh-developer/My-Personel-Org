public class HttpCallout {
    @future(callout = true)
    public static void process(String calloutString) {
        Callout calloutObj = (Callout)JSON.deserialize(calloutString, Callout.class);
        HttpRequest req = setupHttpRequest(calloutObj);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        system.debug('in HttpCallout response ==> '+response.getBody());
    }
    
    private static HttpRequest setupHttpRequest(Callout callout) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(callout.Endpoint);
        req.setMethod(callout.RestMethod);
        req.setTimeout(callout.Timeout);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(callout.BodyString);
        return req;
    }
    public static string getbody(string firstP,string secondP){
        return 'Name='+firstP+'&Email='+secondP+ '';
    }
    
    public static String getJsonResults(
        decimal address1,
        decimal address2) {
            
            
            string skey='AIzaSyBUfUoSD04T482GG-8-F29HwOyT96XRA-E';
           // skey='AIzaSyD-PcqkWbvcOHAOLKxaDPrOp6u33bm2S1Q';
            String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=' + address1+ '&destinations=' + address2+'&key='+skey;
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setEndPoint(url);
            HTTPResponse resp = http.send(req);
           // String jsonResults = resp.getBody();//.replace('\n', '');
            String jsonResults='';
            system.debug('jsonResults --> '+ resp.getBody());
            return jsonResults;
        }
}