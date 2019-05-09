/*
* @ClassName    : ExpenseManagementHandler
* @CreatedOn    : 15/04/2019
* @CreatedBy    : Shashi Yadav
* @Description  : To update the Expense Manager, Finance Manager and set the sharing record users for current users.
*/

public class ExpenseManagementHandler {
    
    Id userId = userinfo.getuserid();
    Decimal expenseBudget;
    Decimal totalBudgetOfCurrentUser;
    User currentUserDetails;
    String emailIdOfUser;
    Id userManagerId;
    String emailIdOfManager;    
    Id financeMangerId;
    String urlPrefix;
    
    public ExpenseManagementHandler(){
        userId = userinfo.getuserid();
        expenseBudget = 0;
        totalBudgetOfCurrentUser = 0;
        currentUserDetails = [SELECT ID, Name,  Manager.Id,  Email FROM User WHERE ID =: userId];
        emailIdOfUser = currentUserDetails.Email;
        if(currentUserDetails.Manager.Id != null){
            userManagerId = currentUserDetails.Manager.Id;        
            emailIdOfManager = [SELECT ID, Manager.Id, Email FROM User WHERE ID =: userManagerId].Email;
        }else{
            emailIdOfManager ='';
        }
        urlPrefix =String.valueOf(System.URL.getOrgDomainUrl().toExternalForm());
        
        financeMangerId = [SELECT ID, Name , DA_Expenso_App__User_Type__c FROM User WHERE DA_Expenso_App__User_Type__c=:Label.Expenso_Finance_Manager].Id;
        System.debug('>>>>>>>>>>>>'+financeMangerId);

    }

        /*
    * @MethodName    : sendLimitBudgetAlertToUserAndManagerWhileInsert
    * @Description  : 
    */
    
    public void setReportingManagers(List<DA_Expenso_App__Expense__c> lstOfExpense){

        for(DA_Expenso_App__Expense__c objExpenso : lstOfExpense){
            
            objExpenso.DA_Expenso_App__Manager_For_Approval__c  = userManagerId != null? userManagerId : financeMangerId;
            objExpenso.DA_Expenso_App__FinanceManager__c = financeMangerId;
        }
    }
    

    public void sendLimitBudgetAlertToUserAndManagerWhileInsert(List<DA_Expenso_App__Expense__c> lstOfExpense){
        checkExpenditure();

        for(DA_Expenso_App__Expense__c expenseObj : lstOfExpense){
            if(((expenseBudget != null)|| (!String.isBlank(String.Valueof(expenseBudget)))) &&((totalBudgetOfCurrentUser != null)|| (!String.isBlank(String.Valueof(totalBudgetOfCurrentUser))))){
                
                totalBudgetOfCurrentUser = totalBudgetOfCurrentUser - expenseObj.DA_Expenso_App__Amount__c;
                if(expenseBudget <= totalBudgetOfCurrentUser){
                    sendNotificationToUserAndItsManager(expenseObj.Name, expenseObj.Id);
                   // objExpenso.addError('You are crosing the limit of expense budget your total budget is :'+ totalBudgetOfCurrentUser +' and Limit is: '+expenseBudget);
                }
            }

        }

    }

      /*
    * @MethodName    : sendLimitBudgetAlertToUserAndManagerWhileUpdate
    * @Description  : 
    */
    public void sendLimitBudgetAlertToUserAndManagerWhileUpdate(List<DA_Expenso_App__Expense__c> lstOfExpense){
        checkExpenditure();

        for(DA_Expenso_App__Expense__c expenseObj : lstOfExpense){
            if(((expenseBudget != null)|| (!String.isBlank(String.Valueof(expenseBudget)))) &&((totalBudgetOfCurrentUser != null)|| (!String.isBlank(String.Valueof(totalBudgetOfCurrentUser))))){
                
                totalBudgetOfCurrentUser = totalBudgetOfCurrentUser + expenseObj.DA_Expenso_App__Amount__c;
                if(expenseBudget <= totalBudgetOfCurrentUser){
                    sendNotificationToUserAndItsManager(expenseObj.Name, expenseObj.Id);
                   // objExpenso.addError('You are crosing the limit of expense budget your total budget is :'+ totalBudgetOfCurrentUser +' and Limit is: '+expenseBudget);
                }
            }

        }
    }


    private void sendNotificationToUserAndItsManager(String expenseName, Id expenseId){        

        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses;
        // Strings to hold the email addresses to which you are sending the email.
        if(String.isNotBlank(emailIdOfManager)){
            toAddresses = new String[] {emailIdOfUser, emailIdOfManager};
        }else{
            toAddresses = new String[] {emailIdOfUser};
        }
        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        // Specify the address used when the recipients reply to the email. 
        //mail.setReplyTo('emailIdOfUser');

        // Specify the name used as the display name.
        mail.setSenderDisplayName(currentUserDetails.Name);

        // Specify the subject line for your email address.
        mail.setSubject('Budget Limit Of Expense' + expenseName);

        mail.setHtmlBody('Your Limit for Expense: ' + expenseName +' has been crossed. <br/> To check your expense detail <a href='+urlPrefix +'/'+ expenseId+' >click here.</a>');

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
        /*
    * @MethodName    : checkExpenditure
    * @Description   : set the values in totalBudgetOfCurrentUser and expenseBudget
    */
    
    
    private void checkExpenditure(){
        expenseBudget =[SELECT ID, DA_Expenso_App__Expense_Budget__c FROM User WHERE ID =: userId].DA_Expenso_App__Expense_Budget__c;
        
        for(DA_Expenso_App__Expense__c objExp : [SELECT ID, DA_Expenso_App__Amount__c,CreatedBy.ID 
                                                 FROM DA_Expenso_App__Expense__c 
                                                 WHERE CreatedBy.ID =: userId]){
             
             if((objExp.DA_Expenso_App__Amount__c != null) || (!String.isBlank(String.Valueof(objExp.DA_Expenso_App__Amount__c)))){
                 
                 totalBudgetOfCurrentUser = totalBudgetOfCurrentUser + objExp.DA_Expenso_App__Amount__c;
             }
         }
         System.debug('>>>>>totalBudgetOfCurrentUser>>>>>'+totalBudgetOfCurrentUser);
         System.debug('>>>>expenseBudget>>>>>>'+expenseBudget);
    }
    
        /*
    * @MethodName    : setUsersAccess
    * @Description   : set User's for record access as Manager and its finance manager.
    */
    
    public static void setUsersAccess(List<DA_Expenso_App__Expense__c> lstOfExpense){
        
        // Create a new list of sharing objects for Job
        List<DA_Expenso_App__Expense__Share> jobShrs  = new List<DA_Expenso_App__Expense__Share>();
        
        // Declare variables for recruiting and hiring manager sharing
        DA_Expenso_App__Expense__Share managerShr;
        DA_Expenso_App__Expense__Share financeManagerShr;
        
        for(DA_Expenso_App__Expense__c job : lstOfExpense){
            
            // Instantiate the sharing objects
            managerShr = new DA_Expenso_App__Expense__Share();
            financeManagerShr = new DA_Expenso_App__Expense__Share();
            
            // Set the ID of record being shared
            managerShr.ParentId = job.Id;
            financeManagerShr.ParentId = job.Id;
            
            // Set the ID of user or group being granted access
            managerShr.UserOrGroupId = job.DA_Expenso_App__Manager_For_Approval__c;
            financeManagerShr.UserOrGroupId = job.DA_Expenso_App__FinanceManager__c;
            
            // Set the access level
            managerShr.AccessLevel = 'edit';
            financeManagerShr.AccessLevel = 'edit';
            
            // Add objects to list for insert
            jobShrs.add(managerShr);
            jobShrs.add(financeManagerShr);
        }
        
        // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(jobShrs,false);
        
    }
    
}