public class RemoveOldContentFromExpHandler {
   
   public static void removeOldContent(List<ContentVersion> records ){

       set<ID> potentialContentDocIDs = new set<ID>();
       for(ContentVersion oCV : records){
           potentialContentDocIDs.add(oCV.ContentDocumentId);
       }
        Date mydate = Date.today().addDays(-30);
        // here we quired those record whose LastModifiedDate is greater then 30 days and contentdocument which contain the records of older versions
        list<ContentDocument> lstContentDoc = [ SELECT ID 
                                                FROM ContentDocument 
                                                WHERE ID =: potentialContentDocIDs ]; // AND LastModifiedDate <: mydate
        set<ID> conformLstContentDocuIDs = new set<ID>();
        for(ContentDocument oCD: lstContentDoc){
            conformLstContentDocuIDs.add(oCD.ID); // set of contentDocumentid which are deleted in further process.
        }
        
        set<id> lstLinkedEntityId = new set<Id>();
        
        // get related record id
        // getting the junction object record detail to link reinserted file.
        map<Id, list<ContentDocumentLink>> mapRelatedRec = new map<Id, list<ContentDocumentLink>>();

        for(ContentDocumentLink oCDL : [SELECT id, LinkedEntityId, ContentDocumentId 
                                        FROM ContentDocumentLink
                                        WHERE ContentDocumentId IN : conformLstContentDocuIDs])
        {
            if(!mapRelatedRec.containsKey(oCDL.ContentDocumentId)){
                mapRelatedRec.put(oCDL.ContentDocumentId, new list<ContentDocumentLink>());
            }
            mapRelatedRec.get(oCDL.ContentDocumentId).add(oCDL);
            lstLinkedEntityId.add(oCDL.LinkedEntityId);                    
        }
        // avoid the user link with the file.
        Set<id> userIDs = new Set<Id>();
        for(user oU : [select id from user where id IN : lstLinkedEntityId]){
            userIDs.add(oU.Id);
        }

        list<ContentVersion> lstConVer = new List<ContentVersion>();
        for(ContentVersion oCV :[SELECT ID, ContentDocumentID, ContentLocation, PathOnClient, Title, VersionData, Description, oldContentDocID__c
                                FROM ContentVersion
                                WHERE IsLatest = true AND ContentDocumentID =: conformLstContentDocuIDs AND isUnmapped__c = false ])
        {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = oCV.ContentLocation; 
            conVer.PathOnClient = oCV.PathOnClient; 
            conVer.Title = oCV.Title ; 
            conVer.VersionData = oCV.VersionData; 
            conVer.oldContentDocID__c = oCV.ContentDocumentID;
            lstConVer.add(conVer);   
        }
        INSERT lstConVer;
        list<ID> lstRecordsToDeleteContentDoc = new list<ID>();
        list<ContentDocumentLink> lstRecordsToDeleteContentDocLink = new list<ContentDocumentLink>();

        list<ContentDocumentLink> lstContentDocLinkInsert = new list<ContentDocumentLink>();
        for(ContentVersion oCV: [SELECT ID, ContentDocumentId , oldContentDocID__c
                                FROM ContentVersion 
                                WHERE id =: lstConVer ]){
            if(mapRelatedRec.containsKey(oCV.oldContentDocID__c)){
                for(ContentDocumentLink oCDL : mapRelatedRec.get(oCV.oldContentDocID__c)){
                    if(!userIDs.contains(oCDL.LinkedEntityId)){
                        ContentDocumentLink cloneObject = oCDL.clone(false,false,false,false);
                        cloneObject.ContentDocumentId = oCV.ContentDocumentId;
                        cloneObject.ShareType = 'I';
                        lstContentDocLinkInsert.add(cloneObject);
                        lstRecordsToDeleteContentDocLink.add(oCDL); 
                    }                  
                }    
               //lstRecordsToDeleteContentDoc.add(oCV.oldContentDocID__c);
            }
        }
        INSERT lstContentDocLinkInsert;
        list<Id> lstContentversionRecDelete = new list<ID>();
        lstContentversionRecDelete.addAll( conformLstContentDocuIDs);
        Database.delete(lstContentversionRecDelete, false);
        Database.delete(lstRecordsToDeleteContentDocLink, false);

       // remove 
   }

    
}