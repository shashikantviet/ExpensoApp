@IsTest
public class Test_Expense_Submit {
	@TestSetup
	static void makeData(){
		
	}
	 static testMethod void test_SubmitForApproval() {
        List<String> setOfIds = new List<String>();
		Account objAcc = new Account(Name='Test_Method_Rec');
    	INSERT objAcc;
     
    	List<Expense__c> lstExp =  new List<Expense__c>{
    		new Expense__c(Date__c = date.today(), Location__c = 'locv1', Vendor__c ='ven1', SalesTax__c = 9 ,Amount__c = 9000, Department__c = 'Dept', Expense_Type__c = 'Hotel', Description__c='desc', Client__c = objAcc.ID),
    		new Expense__c(Date__c = date.today(), Location__c = 'locv2', Vendor__c ='ven2', SalesTax__c = 9 ,Amount__c = 9000, Department__c = 'Dept1', Expense_Type__c = 'Hotel1', Description__c='desc1', Client__c = objAcc.ID)
    	};
    	Insert lstExp;
    	for(Expense__c exp : lstExp){ 
    		setOfIds.add(exp.ID); 
    	}
    	 String ApprovalName = [select Id, Name from ProcessDefinition Where Name = 'ExpenseApproval'].Name;
         system.assertEquals(ApprovalName, 'ExpenseApproval');
         Test.startTest();  
         Expense_Submit.doPost(setOfIds, ApprovalName);
         Expense_Submit.sendEmailToSelectedUser();
         Test.stopTest(); 
     }
}