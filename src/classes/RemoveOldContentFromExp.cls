global class RemoveOldContentFromExp implements Database.Batchable<sObject>{

    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return database.getQueryLocator('SELECT Id, IsLatest, ContentDocumentId FROM ContentVersion WHERE (IsLatest = false OR isUnmapped__c = TRUE)');
    }
    global void execute(Database.BatchableContext bc, List<ContentVersion> records){
        RemoveOldContentFromExpHandler.removeOldContent(records);
    }
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
    
}