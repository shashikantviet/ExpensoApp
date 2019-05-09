/*
* @ClassName    : Expense_Submit
* @CreatedOn    : 26/03/2019
* @CreatedBy    : Shashi Yadav
* @Description  : To submit expense records for approval.
*/
@RestResource(urlMapping='/expenseForSubmit/*')
global with sharing class Expense_Submit {

		/*
	* @ClassName    : SubmitExpenseWrapper
	* @Description  : To bind the newWorkitemIds and submitted results
	*/
	global class SubmitExpenseWrapper{
		global String recordId;
		global List<Id> newWorkitemIds;
		global Boolean submitResult;

		global SubmitExpenseWrapper (String recordId, List<Id> newWorkitemIds, Boolean submitResult){
			this.recordId = recordId;
			this.newWorkitemIds = newWorkitemIds;
			this.submitResult = submitResult;
		}
	}

	

	/*
	* @MethodName    : doPost
	* @Description  : submitting the records based on current user
	*/
	@HttpPost
	global static List<SubmitExpenseWrapper> doPost( List<String> recordIds, String approvalProcessName){
		Id loggedInUserID = UserInfo.getUserId();
		List<SubmitExpenseWrapper> SubmitExpenses =  new List<SubmitExpenseWrapper>();
		for(String recId : recordIds){

			Approval.ProcessSubmitRequest aprovReq =  	new Approval.ProcessSubmitRequest();
			aprovReq.setComments('Submitting request for approval.');
			aprovReq.setObjectId(recId);

			// Submit on behalf of a specific submitter
			aprovReq.setSubmitterId(loggedInUserID);

			//Set Approver IDs
			//aprovReq.setNextApproverIds(new Id[] {});


			// Submit the record to specific process and skip the criteria evaluation
			aprovReq.setProcessDefinitionNameOrId(approvalProcessName);
			aprovReq.setSkipEntryCriteria(true);

			// Submit the approval request for the account
			Approval.ProcessResult result = Approval.process(aprovReq);
			
			// Store result for NewWorkitemIds
			SubmitExpenseWrapper sew = new SubmitExpenseWrapper(recId, result.getNewWorkitemIds(), result.isSuccess());
			SubmitExpenses.add(sew);
		}
		return SubmitExpenses;




		/*User financeMangerDetail = [SELECT ID, Email, DA_Expenso_App__User_Type__c FROM User Where DA_Expenso_App__User_Type__c = 'Expenso Finance Manager'][0];
		System.debug('>>>>>>>>>'+recordIds);
		
		Set<ID> recCreatedByIds =  new Set<Id>();
		List<String> setOfApprovarIds = new List<String>();
		List<String> setOfUserEmails =  new List<String>();

		for(DA_Expenso_App__Expense__c rec : [SELECT ID, createdBy.ID FROM DA_Expenso_App__Expense__c where ID IN :recordIds]){
   			 recCreatedByIds.Add(rec.createdBy.ID);
		}

		String FMEmail = '';
		List<String> lstOfMEmails =  new List<String>();
		
		for(User users : [SELECT Id, ManagerId, Email, DA_Expenso_App__User_Type__c FROM User WHERE ID IN : recCreatedByIds] ){
			if(users.managerId  != null || users.ManagerId != ''){
				lstOfMEmails.add(users.Email);
				setOfApprovarIds.add(users.ID);
			}
		}
        

        String managerEmials = '';
        if(!lstOfMEmails.isEmpty()){
        	for(String strEmail: lstOfMEmails){
             managerEmials+=strEmail+',';         
       		}
        }
        
       managerEmials=managerEmials.substring(0,managerEmials.lastIndexOfIgnoreCase(','));
             				
		List<SubmitExpenseWrapper> SubmitExpenses =  new List<SubmitExpenseWrapper>();

		EmailTemplate etForFM = [Select Id from EmailTemplate where Name=:'TempForFM'];
		EmailTemplate etForM = [Select Id from EmailTemplate where Name=:'TempForM'];
		//EmailTemplate etForSU = [Select Id from EmailTemplate where Name=:'TempForSU'];

		for(String recId : recordIds){

			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			//lstIfMEmails
			message.toAddresses = new String[] {financeMangerDetail.Email};

			if(managerEmials != null || managerEmials != ''){
				message.setCcAddresses(new String[] {managerEmials});
				message.setTemplateId(etForM.Id); 
			}else{
				message.setTemplateId(etForFM.Id); 
			}
			
			message.setTargetObjectId(loggedInUserID); 
			message.setSenderDisplayName('Expense Management'); 
			message.setUseSignature(false); 
			message.setBccSender(false); 
			message.setSaveAsActivity(false);
			Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
			*/
	}

}