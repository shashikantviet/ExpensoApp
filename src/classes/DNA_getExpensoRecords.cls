@RestResource(urlMapping='/expensemanage/*')
global class DNA_getExpensoRecords {
	
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String ExpenseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug('test-------->'+ExpenseId);
        System.debug('test-------->'+req.requestURI);
        if(string.isNotBlank(ExpenseId)){
            list<Expense__c> lstExpense = [SELECT id, Date__c,Location__c, Vendor__c, SalesTax__c, Amount__c,  Department__c,Expense_Type__c, Description__c, Status__c,  Client__c 
                                FROM Expense__c 
                                WHERE Id = :ExpenseId];
            if(lstExpense.size() > 0){
                System.debug('test--->');
                set<ID> contDocId = new set<Id>();
                for(ContentDocumentLink cdl : [SELECT ContentDocumentId 
                                            FROM ContentDocumentLink
                                            WHERE LinkedEntityId =: ExpenseId])
                {
                    contDocId.add(cdl.ContentDocumentId);                
                }
                if(contDocId.size()>0){
                list<contentversion> relatedFiles = [SELECT ID, Title, fileType
                                                    FROM ContentVersion
                                                    WHERE ContentDocumentId =: contDocId AND IsLatest = TRUE ];
                    wrapperRet obj = new wrapperRet(lstExpense[0], relatedFiles);
                    res.responseBody = Blob.valueof( JSON.serialize(obj));
                }else{
                    wrapperRet obj = new wrapperRet(lstExpense[0]);
                    res.responseBody = Blob.valueof( JSON.serialize(obj));
                }
            }else{
                res.statusCode = 400;
                res.responseBody = Blob.valueof( '{"error" : "No Expense record Found"}');
            }
        }else{
            res.statusCode = 400;
            res.responseBody = Blob.valueof( '{"error" : "expense record Id is missing."}');
        }
        
    }

    @HttpPost
    global static void doPost(DNA_wrapperCallout createRequest){
        System.debug('testing inside post');
        RestResponse res = RestContext.response;
        res = expeneRecordHandler.createExpensoRecord(createRequest, res);
        //return 'anup Kage';
    }
    
    @HttpPatch 
    global static void doPatch(DNA_wrapperCallout updateRequest){
        System.debug('testing inside patch');
        RestResponse res = RestContext.response;
        res = expeneRecordHandler.updateExpensoRecord(updateRequest, res);
        //return 'updated';
    }
    @HttpDelete
    global static void doDelete(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //String strIds = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        list<String> lstID = req.requestURI.split('/');
        System.debug('req.requestURI------>'+req.requestURI);
        System.debug('lstID'+lstID.size());
        if(lstID.size() == 4 && String.isNotEmpty(lstID[2]) && String.isNotEmpty(lstID[3]) ){
            res = expeneRecordHandler.unMapContentDocRecord(lstID[2], lstID[3], res);
        }else{
            res.statusCode = 400;
            res.responseBody = Blob.valueof('{"error": "recordID\'s are missing"}'); 
        }
        //return 'deleted';
    }
    global class wrapperRet{
        global Expense__c Expense;
        global list<ContentVersion> relatedFiles;

        global wrapperRet(Expense__c Expense, list<ContentVersion> relatedFiles){
            this.relatedFiles = relatedFiles;
            this.Expense = Expense;
        }
        global wrapperRet(Expense__c Expense){
            this.Expense = Expense;
        }
    }
}