global with sharing class DNA_wrapperCallout {
    global Expense__c expense;
    global list<wrapperFile> relatedFiles;
    global DNA_wrapperCallout(Expense__c expense, list<wrapperFile> relatedFiles){
        this.expense = expense;
        this.relatedFiles = relatedFiles;
    }
    global class wrapperFile{
        global String ContentDocumentId;
        global String Title;
        global String PathOnClient;
        global String VersionData;
        global String Id;
        
        global wrapperFile(String ContentDocumentId, String Title, String PathOnClient, String VersionData){
            this.ContentDocumentId = ContentDocumentId;
            this.Title = Title;
            this.PathOnClient = PathOnClient;
            this.VersionData = VersionData;
        }
    }
}