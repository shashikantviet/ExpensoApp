/**
* \arg ClassName        : expeneRecordHandler 
* \arg CreatedOn        : 19/Feb/2019
* \arg LastModifiedOn   : 
* \arg CreatededBy      : Anup
* \arg ModifiedBy       : 
* \arg Description      : Insert/Update the expense record and content document.
*/


public with sharing class expeneRecordHandler {
    
    public class wrapperReturn{
        sObject expense;
        Boolean isSuccess;
        String ErrorMessage;

        public wrapperReturn(Boolean isSuccess, sObject expense){
                this.isSuccess = isSuccess;
                this.expense = expense;
        }
        public wrapperReturn(Boolean isSuccess, String ErrorMessage){
                this.isSuccess = isSuccess;
                this.ErrorMessage = ErrorMessage;
        }
    }


    public static RestResponse createExpensoRecord(DNA_wrapperCallout createRequest, RestResponse res){
        wrapperReturn ret;
        if(createRequest.expense != null){
            ret = insertExpenseRec(createRequest.expense);            
            if(ret.isSuccess && !createRequest.relatedFiles.isEmpty()){
                res = insertFilesNdRelate(createRequest.relatedFiles, ret.expense.Id,  res);
            }else if(!ret.isSuccess){
                res.statusCode = 400;
                res.responseBody = Blob.valueof(JSON.serialize( new wrapperReturnOnUpsert('error', ret.ErrorMessage )));
            }else if(createRequest.relatedFiles.isEmpty() && ret.isSuccess){
                res.statusCode = 201;
                res.responseBody = Blob.valueof(JSON.serialize( new wrapperReturnOnUpsert(ret.expense.ID ,'success' )));
            }   
        }
        return res;
    }   

     private static wrapperReturn insertExpenseRec(Expense__c objExp){
        try{
            INSERT objExp;
        }catch(DmlException e) {
            return new wrapperReturn(false, e.getMessage());
        }
        return new wrapperReturn(true, objExp);
    }
    // update the expense record 

    public static RestResponse updateExpensoRecord(DNA_wrapperCallout updateRequest, RestResponse res){
        wrapperReturn ret;
        if(updateRequest.expense != null && updateRequest.expense.Id != null){
            ret = updateExpenseRec(updateRequest.expense);            
            if(ret.isSuccess && !updateRequest.relatedFiles.isEmpty()){
               res = insertFilesNdRelate(updateRequest.relatedFiles, ret.expense.Id, res);
            }else if(!ret.isSuccess){
                res.statusCode = 500;
                res.responseBody = Blob.valueof(JSON.serialize( new wrapperReturnOnUpsert('error', ret.ErrorMessage )));
            }else if(updateRequest.relatedFiles.isEmpty() && ret.isSuccess){
                res.statusCode = 201;
                res.responseBody = Blob.valueof(JSON.serialize( new wrapperReturnOnUpsert(ret.expense.ID ,'success' )));
            }  
        }else{
            res.statusCode = 405;
            res.responseBody = Blob.valueof('{"error": "expense record Id is missing"}');
        }
        return res;
    }

    private static wrapperReturn updateExpenseRec(Expense__c objExp){
        try{
            UPDATE objExp;
        }catch(DmlException e) {
            return new wrapperReturn(false, e.getMessage());
        }
        return new wrapperReturn(true, objExp);
    }

    private static RestResponse insertFilesNdRelate(list<DNA_wrapperCallout.wrapperFile> lstcontVer, Id RecordId , RestResponse res){
        try {
            list<ContentVersion> lstContentVersion = new list<Contentversion>();
           
            for(DNA_wrapperCallout.wrapperFile oCV : lstcontVer){
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
                conVer.PathOnClient = oCV.PathOnClient; //'ionicLogo.png'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = oCV.Title ; // Display name of the files
                conVer.VersionData = EncodingUtil.base64Decode(oCV.VersionData); // converting your binary string to Blog
                if(String.isNotBlank(oCV.ContentDocumentId) && oCV.ContentDocumentId != null && !oCV.ContentDocumentId.equalsIgnoreCase('null')){
                    conVer.contentDocumentID = oCV.ContentDocumentId;
                }                
                lstContentVersion.add(conVer);
            }
            INSERT lstContentVersion;

            // after insert query contentDocumentID 
            set<ID> lstConDocID = new set<ID>();
            set<ID> retlstConDocID = new set<ID>();
            for(ContentVersion oCv :[SELECT ContentDocumentId, Title, PathOnClient, versionNumber,Id 
                                FROM ContentVersion 
                                WHERE Id =: lstContentVersion])
            {
                lstConDocID.add(oCv.ContentDocumentId);
                retlstConDocID.add(oCv.ContentDocumentId);  // return to the call request
            }

            // here checking of update the excisting document 
            for(ContentDocumentLink cdl : [SELECT ContentDocumentId 
                                           FROM ContentDocumentLink
                                           WHERE LinkedEntityId =: RecordId])
            {
                if(lstConDocID.contains(cdl.ContentDocumentId)){ // 
                    lstConDocID.remove(cdl.ContentDocumentId);
                }                
            }
            if(!lstConDocID.isEmpty()){
                list<ContentDocumentLink> lstCDL = new list<ContentDocumentLink>();
                for(ID cdID : lstConDocID){
                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = cdID;
                    cDe.LinkedEntityId = RecordId; // you can use objectId,GroupId etc
                    cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                    cDe.Visibility = 'AllUsers';
                    lstCDL.add(cDe);
                }
                INSERT lstCDL;
            }
            res.statusCode = 201;
            res.responseBody = Blob.valueof(JSON.serialize( new wrapperReturnOnUpsert(RecordId , retlstConDocID, 'success')));
            
        } catch(Exception e){
            res.statusCode = 500;
           // res.responseBody = Blob.valueof(JSON.serialize( new wrapperReturnOnUpsert(RecordId , 'error', e.getTypeName() )));
            res.responseBody = Blob.valueof(JSON.serialize( new wrapperReturnOnUpsert(RecordId , 'error', e.getMessage() )));
        }
        return res;
    }

    public static RestResponse  unMapContentDocRecord(Id recordId, ID contentDocID, RestResponse res){
        
        list<Expense__c> result = [ SELECT id 
                                    FROM Expense__c 
                                    WHERE Id = :recordId ];
        if(result.isEmpty()){
            res.statusCode = 400;
            res.responseBody = Blob.valueof('{"error": "No expense record found. wrong expense recordid."}'); 
            return res;
        }

        list<ContentDocument> lstConDoc = [SELECT ID
                                            FROM ContentDocument
                                            WHERE Id =: contentDocID];
        if(lstConDoc.isEmpty()){
            res.statusCode = 400;
            res.responseBody = Blob.valueof('{"error": "No contentDocument record found. wrong contentDocumentId."}'); 
            return res;
        }
        List<ContentVersion> lstContentVersion = new list<ContentVersion>();
        for(ContentVersion o : [SELECT Id, isUnmapped__c
                                FROM ContentVersion
                                WHERE ContentDocumentId =: lstConDoc ]){
            o.isUnmapped__c = true;
            lstContentVersion.add(o);
        }
        if(lstContentVersion.size() > 0)
            Database.update(lstContentVersion, false);
            
        set<ID> contDocId = new set<Id>();
        list<ContentDocumentLink> lstConDocLink = [ SELECT ContentDocumentId 
                                                    FROM ContentDocumentLink
                                                    WHERE LinkedEntityId =: recordId AND ContentDocumentId =: contentDocID];
        if(lstConDocLink.isEmpty()){
            res.statusCode = 400;  // status code 204 (No Content)
            res.responseBody = Blob.valueof('{"error": "no link between record and file"}');
            return res;
        }
        Database.DeleteResult[] objDeleresult = Database.delete(lstConDocLink, false);
        res.statusCode = 200;  // status code 204 (No Content)
        
        if(objDeleresult[0].isSuccess()){
             res.responseBody = Blob.valueof('{ "success" : "true" }');
        }else{
            res.statusCode = 404;  // status code 204 (No Content)
            res.responseBody = Blob.valueof('{ "error" : '+ objDeleresult[0].getErrors() +' }');
        }
             
        return res;        
    }

    public class wrapperDeleteReturn{
        public Database.DeleteResult[] deletedRecords;
        public String status; 
        public wrapperDeleteReturn( Database.DeleteResult[] deletedRecords,String status){
            this.deletedRecords = deletedRecords;
            this.status = status;
        } 
    }

    public class wrapperReturnOnUpsert{
        public ID expense;
        public set<ID> Attachments;
        public String message;
        public String errorCode;

        public wrapperReturnOnUpsert(Id expense,set<Id> Attachments, String message){
            this.expense = expense;
            this.Attachments = Attachments;
            this.message = message;
        }
        public wrapperReturnOnUpsert(id expense, String message){
            this.expense = expense;
            this.message = message;
        }
        public wrapperReturnOnUpsert(id expense, String message,String errorCode){
            this.expense = expense;
            this.message = message;
            this.errorCode = errorCode;
        }       
        public wrapperReturnOnUpsert(String message, String errorCode){
            this.message = message;
            this.errorCode = errorCode;
        }
    }
    
}