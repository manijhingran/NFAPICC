public class HerokuAPI 
{
    
    public static HerokuResponse postHerokuRequest(HerokuRequest reqData)
    {
        HerokuResponse responseData = new HerokuResponse();
        try{
            HttpRequest req = new HttpRequest();  
            req.setTimeOut(120000);
            req.setMethod('POST');
            req.setEndpoint('https://nfapihub.herokuapp.com');
            req.setHeader('Content-Type','application/json');            
            req.setBody(JSON.serialize(reqData)); 
            
            HttpResponse res = new Http().send(req);
            
            if(res.getStatusCode() == 200){
                responseData = (HerokuResponse)System.JSON.deserialize(res.getBody(), HerokuResponse.class);
            }
            else{
                responseData = (HerokuResponse)System.JSON.deserialize(res.getBody(), HerokuResponse.class);
            }
        }
        catch(Exception e){
            responseData.Success = false;
            responseData.secretKey = '';
            responseData.error = e.getMessage();
            System.debug('Exception:' + e.getMessage() + 'StackTrace:' + e.getStackTraceString() );
        }
       
        return responseData;
    }
    
    public class HerokuRequest{
        public string id {get;set;}
        public string agentid {get;set;}
    }
    
    public class HerokuResponse{
        public boolean Success {get;set;}
        public string secretKey {get;set;}
        public string error {get;set;}
    }
}