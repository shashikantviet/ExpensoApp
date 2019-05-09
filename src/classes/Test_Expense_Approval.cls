@IsTest
public class Test_Expense_Approval {
	 static testMethod void test_RemoveOldContentFromExpforDelete(){
	 	Account objAcc = new Account(Name='Test_Method_Rec');
        INSERT objAcc;
	 	Expense__c record = new Expense__c();
        record.Date__c=Date.today(); 
        record.Location__c='locv';
        record.Vendor__c='ven';
        record.SalesTax__c=9;
        record.Amount__c=9000;
        record.Department__c='Dept'; 
        record.Expense_Type__c='Hotel';
        record.Client__c = objAcc.ID; //required
        
        INSERT record;
        
        Id loggedInUserID = UserInfo.getUserId();
        String ApprovalName = [select Id, Name from ProcessDefinition Where Name = 'ExpenseApproval' ].Name;
        Approval.ProcessSubmitRequest aprovReq =  	new Approval.ProcessSubmitRequest();
		aprovReq.setComments('Submitting request for approval.');
		aprovReq.setObjectId(record.Id);

		// Submit on behalf of a specific submitter
		aprovReq.setSubmitterId(loggedInUserID); 

		// Submit the record to specific process and skip the criteria evaluation
		aprovReq.setProcessDefinitionNameOrId(ApprovalName);
		aprovReq.setSkipEntryCriteria(true);

		// Submit the approval request for the account
		Approval.ProcessResult result = Approval.process(aprovReq);
		Expense_Approval.doPost('Approve','this record is approved', result.getNewWorkitemIds()[0]);

	 }

}