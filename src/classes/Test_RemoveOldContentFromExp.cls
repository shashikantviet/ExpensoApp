@IsTest
public class Test_RemoveOldContentFromExp {
    
    @TestSetup
    static void makeData(){
        Account objAcc = new Account(Name='Test_Method_Rec');
        INSERT objAcc;
        
        Expense__c record = new Expense__c();
        record.Date__c=Date.today(); 
        record.Location__c='locv';
        record.Vendor__c='ven';
        record.SalesTax__c=9;
        record.Amount__c=9000;
        record.Department__c='Dept'; 
        record.Expense_Type__c='Hotel';
        record.Client__c = objAcc.ID; //required
        
        INSERT record;
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'test file.txt'; //'ionicLogo.png'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title ='text file' ; // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode('test file'); // converting your binary string to Blog
        INSERT conVer;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        Set<ID> setOfDocIds = new Set<ID>();
        for(ContentVersion cv :[SELECT id, ContentDocumentId FROM ContentVersion]){
            setOfDocIds.add(cv.ContentDocumentId);
        }
        List<ContentVersion> lstContentVersion = new list<ContentVersion>();
        for(ContentVersion o : [SELECT Id, isUnmapped__c
                                FROM ContentVersion
                                WHERE ContentDocumentId =: setOfDocIds ]){
                                    o.isUnmapped__c = true;
                                    lstContentVersion.add(o);
                                }
        if(lstContentVersion.size() > 0){
            Database.update(lstContentVersion, false);
        }
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = record.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
      /*  list<ContentVersion> lstConVer = new List<ContentVersion>();
        for(ContentVersion oCV :[SELECT ID, ContentDocumentID, ContentLocation, PathOnClient, Title, VersionData, Description, oldContentDocID__c
                                 FROM ContentVersion
                                 WHERE IsLatest = true AND ContentDocumentID =: setOfDocIds AND isUnmapped__c = false ])
        {
            ContentVersion cv = new ContentVersion();
            cv.ContentLocation = oCV.ContentLocation; 
            cv.PathOnClient = oCV.PathOnClient; 
            cv.Title = oCV.Title ; 
            cv.VersionData = oCV.VersionData; 
            cv.oldContentDocID__c = oCV.ContentDocumentID;
            lstConVer.add(cv);   
        }
        INSERT lstConVer;
        List<ContentVersion> lstConVersion  = [SELECT ID, ContentDocumentId , oldContentDocID__c
                                FROM ContentVersion 
                                WHERE id =: lstConVer]; */
        
    }
    
    static testMethod void test_RemoveOldContentFromExpforDelete() {
        makeData();
        RemoveOldContentFromExp roc = new RemoveOldContentFromExp();
        database.executeBatch(roc);
    }
}