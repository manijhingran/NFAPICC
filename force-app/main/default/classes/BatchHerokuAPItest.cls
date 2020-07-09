@isTest
public class BatchHerokuAPItest {
    
    @testSetup
    static void testSetup() {
        Contact con = new Contact();
        con.firstname = 'Test';
        con.lastname = 'Gonzalez';
        insert con;
        
        Case cs = new Case();
        cs.contactId = con.id;
        cs.Status = 'New';
        cs.Origin = 'Phone';
        cs.Type = 'Electrical';
        cs.Subject = 'Starting generator after electrical failure';
        insert cs;
        
        cs.Status = 'Closed';
        update cs;
    }
    
    @isTest
    static void testcallout()
    {
        Case objCase = [Select id from case LIMIT 1];
        Test.StartTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorBatchHerokuAPI());
            Database.ExecuteBatch(new BatchHerokuAPI(),1);
        Test.StopTest();
    }
}