@RestResource(urlMapping='/fileUpload/*')
global class Fileuploader {
   /* 
    global class wrapperReq{
        string PathOnClient; //
        String Title;
        String VersionData; //base64data 
        String isInsert;
        String isUpdate;
        String parentId; //recordId 
        //String        
    }
    global class wrapperErrorResponse{
        string state;
        string message;
        global wrapperErrorResponse(String state, string message){
            this.state = state;
            this.message = message;
        }
    }
    @HttpPost
    global static String doPost(wrapperReq expenseRequest){
        if(expenseRequest.isInsert.equalsIgnoreCase('true')){
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = expenseRequest.PathOnClient; //'ionicLogo.png'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = expenseRequest.Title ; // Display name of the files
            conVer.VersionData = EncodingUtil.base64Decode(expenseRequest.VersionData); // converting your binary string to Blog
            insert conVer;
            
            ContentVersion conDoc = [SELECT ContentDocumentId, Title, PathOnClient, versionNumber,VersionData 
                                     FROM ContentVersion 
                                     WHERE Id =:conVer.Id];
        
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc.ContentDocumentId;
            cDe.LinkedEntityId = expenseRequest.parentId; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            cDe.Visibility = 'AllUsers';
            insert cDe;
            
            return JSON.serialize(conDoc);
            
        }else if(expenseRequest.isUpdate.equalsIgnoreCase('true')){
           
            wrapperErrorResponse res = new wrapperErrorResponse('error', 'update code is not written');
            return json.serialize(res);
        }
        wrapperErrorResponse res = new wrapperErrorResponse('error', 'error message need to be added');
        return json.serialize(res);
    }
    */
}