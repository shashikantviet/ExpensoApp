/*
* @ClassName    : Expense_Approval
* @CreatedOn    : 26/03/2019
* @CreatedBy    : Shashi Yadav
* @Description  : to submitt or reject the expense.
*/
@RestResource(urlMapping='/expenseForApproval/*')
global with sharing class Expense_Approval {
  	
  	/*
	* @MethodName    : doPost
	* @Description  : submitting or rejecting the records based on current user
	*/
  	@HttpPost
    global static Boolean doPost(String recID, String aproveOrReject, String setComment, String successNewWorkitemId) {

    	//get logged in user Id for setting the email.
    	Id loggedInUserID = UserInfo.getUserId();
       

      Approval.ProcessWorkitemRequest apoveRes =  new Approval.ProcessWorkitemRequest();
  		apoveRes.setComments(setComment);
  		apoveRes.setAction(aproveOrReject);	
  		//apoveRes.setNextApproverIds(new Id[] {UserInfo.getUserId()});

  		// Use the ID from the newly created item to specify the item to be worked
  		apoveRes.setWorkitemId(successNewWorkitemId);

  		// Submit the request for approval
  		Approval.ProcessResult result =  Approval.process(apoveRes);
      return result.isSuccess();

        //get the submitted userId

        //To store the emails of Manager and Finance Manager for Alert
        /*String managerMailEmail ='';
        String financeManagerEmail ='';*/
       /* Id submittedUserID = [SELECT TargetObjectId, SubmittedById FROM ProcessInstance WHERE TargetObjectId = :recID].SubmittedById;
		    User userDetail = [SELECT Id, ManagerId, Email, DA_Expenso_App__User_Type__c FROM User WHERE ID =: submittedUserID];
         system.debug('userDetail>>'+userDetail);
        if((userDetail.DA_Expenso_App__User_Type__c == 'Expenso sales User') && (userDetail.ManagerId!=null)){
        	User mangerUserDetails = [SELECT Id, ManagerId, Email, DA_Expenso_App__User_Type__c FROM User WHERE ID =: userDetail.ManagerId];
        	managerMailEmail = MangerUserDetails.Email;
        	if((mangerUserDetails.DA_Expenso_App__User_Type__c == 'Expenso Manager')&&(mangerUserDetails.ManagerId!=null)){
        		User financeManagerDetail = [SELECT Id, ManagerId, Email, DA_Expenso_App__User_Type__c FROM User WHERE ID =: mangerUserDetails.ManagerId];
        		financeManagerEmail = financeManagerDetail.Email;
        	}
        }else{
        	financeManagerEmail = userDetail.Email;
        }
       
       	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
       	  
       	if(String.isNotBlank(financeManagerEmail)){
       		  system.debug('financeManagerEmail:::57>>'+financeManagerEmail);
        	  message.toAddresses = new String[] {FinanceManagerEmail};
       	} 
       	if(String.isNotBlank(ManagerMailEmail)){
       		system.debug('ManagerMailEmail:::61>>'+ManagerMailEmail);
       		message.setCcAddresses(new String[] {ManagerMailEmail});
       	}
       	if(aproveOrReject == 'Approve'){
       		EmailTemplate approvedTemplet = [Select Id from EmailTemplate where Name=:'ApprovalState'];
       		message.setTemplateId(approvedTemplet.Id); 
       	}
       	if(aproveOrReject == 'Reject'){
       		EmailTemplate rejectedTemplet = [Select Id from EmailTemplate where Name=:'RejectionState'];
       		message.setTemplateId(rejectedTemplet.Id); 
       	}
		

        //message.setTemplateId(etForFM.Id); 
		message.setTargetObjectId(loggedInUserID); 
		message.setSenderDisplayName('Expense Management'); 
		message.setUseSignature(false); 
		message.setBccSender(false); 
		message.setSaveAsActivity(false);
		Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
		System.debug('>>>>>>>>success email>>>>'+results[0].isSuccess());

		System.debug('>>>>>>>'+results);*/
    	
				
    }

}