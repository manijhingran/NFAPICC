global class BatchHerokuAPI implements Database.Batchable<sObject>,   Database.AllowsCallouts {
    
    String failedStatus = 'Fail';
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select ID,LastModifiedById,Integration_Status__c,Integration_Count__c,Integration_ErrorMessage__c from Case Where isClosed = true ';
        query += 'AND (Integration_Status__c = null OR (Integration_Status__c =:failedStatus AND Integration_Count__c < 3))';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> records) {
        list<Case>lstCaseToBeUpdated = new list<Case>();
        try{
            for(Case cs:records){
                HerokuAPI.HerokuRequest herokuReq = new HerokuAPI.HerokuRequest();
                HerokuAPI.HerokuResponse herokuResp = new HerokuAPI.HerokuResponse();
                herokuReq.id = cs.ID;
                herokuReq.agentid = cs.LastModifiedById;
                herokuResp = HerokuAPI.postHerokuRequest(herokuReq);
                
                system.debug('@@@@herokuReq '+herokuReq);
                system.debug('@@@@herokuResp '+herokuResp);
                
                if(herokuResp != null){
                    cs.Integration_Status__c = herokuResp.Success?'Success':failedStatus;
                    cs.Integration_Count__c  = cs.Integration_Count__c != null?(cs.Integration_Count__c+1):1;
                    cs.Integration_ErrorMessage__c = !String.IsBlank(herokuResp.error)?herokuResp.error:'';
                    lstCaseToBeUpdated.add(cs);
                }
            }
            
            if(!lstCaseToBeUpdated.isEmpty()){
                update lstCaseToBeUpdated;
            }
        }catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
        }
    } 
    
    global void finish(Database.BatchableContext BC){   
        
    }
}