trigger SetExpenseManagerAndFinanceManager on DA_Expenso_App__Expense__c (after insert, after update, before insert, before update) {

	ExpenseManagementHandler emp = new ExpenseManagementHandler();
	if(Trigger.isBefore && Trigger.isInsert){
		emp.setReportingManagers(Trigger.new);
	}
	if(Trigger.isBefore && Trigger.isUpdate){
		emp.setReportingManagers(Trigger.new);
	}
	if(Trigger.isAfter && Trigger.isInsert){
		ExpenseManagementHandler.setUsersAccess(Trigger.new);
		emp.sendLimitBudgetAlertToUserAndManagerWhileInsert(Trigger.new);
	}
	if(Trigger.isAfter && Trigger.isUpdate){
		ExpenseManagementHandler.setUsersAccess(Trigger.new);
		emp.sendLimitBudgetAlertToUserAndManagerWhileUpdate(Trigger.new);
	}

}