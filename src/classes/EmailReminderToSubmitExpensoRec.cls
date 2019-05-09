global class EmailReminderToSubmitExpensoRec implements Database.Batchable<sObject>{
   global final String Query='SELECT ID, CreatedBy.Id, DA_Expenso_App__IsSubmitted__c FROM DA_Expenso_App__Expense__c where DA_Expenso_App__IsSubmitted__c = false';
      
       List<String> lstOfUsersIds= new List<String>();
       List<String> lstOfuserMEmails =  new List<String>();
       List<String> lstOfmanagerEmail = new List<String>();
       List<String> lstOfFinanceMngEmail = new List<String>();
       EmailTemplate etForFM;  
       Id loggedInUserID = UserInfo.getUserId();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
   global void execute(Database.BatchableContext BC, List<DA_Expenso_App__Expense__c> scope){
              
       Id loggedInUserID = UserInfo.getUserId();
       map<Id, User> mapOfmngerId =new Map<Id, User>();
       
       for(DA_Expenso_App__Expense__c objexpenso :scope)
       { 
          lstOfUsersIds.add(objexpenso.CreatedBy.Id);                         
       }    
            
      for(User usr: [SELECT Id, ManagerId, Email, DA_Expenso_App__User_Type__c FROM User WHERE ID IN : lstOfUsersIds]){
          if(usr.managerId != null){
				lstOfuserMEmails.add(usr.Email);
             //   mapOfmngerId.put(usr.managerId,usr);
		}
        }// End of for loop
      etForFM = [Select Id from EmailTemplate where Name=:'TempForFM'];
       
       
    }
    global void finish(Database.BatchableContext BC){
         //Send an email to the User after your batch completes
       
       For(String Emails :lstOfuserMEmails)
       {
           Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		   message.toAddresses = new String[] {Emails};
	       message.setTemplateId(etForFM.Id); 
		   message.setTargetObjectId(loggedInUserID); 
		   message.setSenderDisplayName('Expense Management'); 
		   message.setUseSignature(false); 
		   message.setBccSender(false); 
		   message.setSaveAsActivity(false);
		   Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
		   Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
     }  
           
    }
}