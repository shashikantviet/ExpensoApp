@IsTest
public class Test_SetExpenseManagerAndFinanceManager {
    
    
    public static testMethod void InsertExpenseData(){       
        
        Profile sPro = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User newUsers = new User (Alias = 'standt1', Email='standarduser@testorg.com',
                                  EmailEncodingKey='UTF-8', LastName='Testing1', 
                                  LanguageLocaleKey='en_US',
                                  LocaleSidKey='en_US', ProfileId = sPro.Id,
                                  TimeZoneSidKey='America/Los_Angeles', 
                                  UserName='testpermissionsetuser1@testorg.com', 
                                  DA_Expenso_App__User_Type__c = 'Expenso Sales User',
                                  DA_Expenso_App__Expense_Budget__c =5000);
        Database.insert(newUsers);
        
        //Create Account Record
        Account objAcc = new Account(Name='Test_Method_Rec');
        INSERT objAcc;
        System.assertEquals('Test_Method_Rec', objAcc.Name);
        
        //Create Opportunity record
        Opportunity objOpp=new Opportunity();
        objOpp.Name='test Opp';
        objOpp.Closedate=Date.Today();
        objOpp.Stagename='Prospecting';
        insert objOpp;
        System.assertEquals('test Opp', objOpp.Name); 
        
        //Create Expense record
        DA_Expenso_App__Expense__c expenserecord = new DA_Expenso_App__Expense__c();
        
        expenserecord.DA_Expenso_App__Amount__c=1234;
        expenserecord.DA_Expenso_App__AP_Invoice_Number__c='Invoice';
        expenserecord.DA_Expenso_App__Chargeback_to_Customer__c=false;
        expenserecord.DA_Expenso_App__Client__c=objAcc.Id;
        expenserecord.DA_Expenso_App__Department__c='Dept';
        expenserecord.DA_Expenso_App__Description__c='desc';
        expenserecord.DA_Expenso_App__Expense_Type__c='Hotel';
        expenserecord.DA_Expenso_App__isDeleted__c= false;  
        expenserecord.DA_Expenso_App__IsSubmitted__c=false;
        expenserecord.DA_Expenso_App__Location__c='Delhi';
        expenserecord.DA_Expenso_App__Manager_For_Approval__c=userinfo.getuserid();
        expenserecord.DA_Expenso_App__Related_Opportunity__c=objOpp.Id;
        expenserecord.DA_Expenso_App__SalesTax__c= 34567;
        expenserecord.DA_Expenso_App__Status__c='Pending';
        expenserecord.DA_Expenso_App__Vendor__c='Bond';
        expenserecord.DA_Expenso_App__Date__c=date.Today();
        
        upsert expenserecord;
        sendEmail(expenserecord.Name, expenserecord.Id, newUsers.Id);
        //update expenserecord;
       // sendEmail(expenserecord.Name, expenserecord.Id, newUsers.Id);
        
        
        // Update expense records */
        
        
    }
    public static void sendEmail(String expName , ID expId, ID userId) {
        //New instance of a single email message
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{userId};
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
        mail.setPlainTextBody('HI, The expense Name :'+expName+ 'LIMIT has crossed');
        mail.setSenderDisplayName('Current User');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    } 
    
}