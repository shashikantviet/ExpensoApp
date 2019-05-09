global class ReminderForExpenseRecApproval implements Database.Batchable<sObject>{
	global Set<Id> setOFIds =  new Set<ID>();
    global Database.QueryLocator start(Database.BatchableContext BC){
       
        String query = 'SELECT ID,Name,CreatedBy.Id,DA_Expenso_App__Amount__c,DA_Expenso_App__AP_Invoice_Number__c,DA_Expenso_App__Chargeback_to_Customer__c, DA_Expenso_App__Client__c,DA_Expenso_App__Date__c,DA_Expenso_App__Department__c,DA_Expenso_App__Description__c,DA_Expenso_App__User__c,DA_Expenso_App__Expense_Type__c,DA_Expenso_App__isDeleted__c,DA_Expenso_App__IsSubmitted__c,DA_Expenso_App__Location__c,DA_Expenso_App__Manager_For_Approval__c,DA_Expenso_App__Related_Opportunity__c,DA_Expenso_App__SalesTax__c,DA_Expenso_App__Status__c,DA_Expenso_App__Total__c,DA_Expenso_App__Vendor__c,DA_Expenso_App__Week_Ending__c from DA_Expenso_App__Expense__c WHERE Status ="Pending"';
        return Database.getQueryLocator(query);
        }
          
   global void execute(Database.BatchableContext BC, List<DA_Expenso_App__Expense__c> scope){
             
        
        For(DA_Expenso_App__Expense__c exp : scope){
            if(Approval.isLocked(exp.Id)==true){
                setOFIds.Add(exp.CreatedBy.ID);
            }
       }
      
   }
   global void finish(Database.BatchableContext BC){
      List<Messaging.SingleEmailMessage> mail = New List<Messaging.SingleEmailMessage>();
      for(User users : [Select ID,Email,DA_Expenso_App__User_Type__c,UserRole.Id, Manager.ID FROM User Where ID IN: setOFIds]){
         if((users.DA_Expenso_App__User_Type__c == 'Expenso Finance Manger') || (users.DA_Expenso_App__User_Type__c =='Expenso Sales User') || (users.DA_Expenso_App__User_Type__c == 'Expenso Manager')){
                Messaging.SingleEmailMessage msg = New Messaging.SingleEmailMessage();
                msg.setSubject('test Subject');
                msg.setHtmlBody('test body');
                List<String> sendTo = new List<String>();
                sendTo.add(users.Email);
                msg.setToAddresses(sendTo);
                mail.add(msg);
            }
        }
        if(mail.size()>0){
          Messaging.sendEmail(mail);
        }
    }
}