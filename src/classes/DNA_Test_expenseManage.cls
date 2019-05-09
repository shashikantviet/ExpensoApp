@isTest
public with sharing class DNA_Test_expenseManage {
    
    @TestSetup
    static void makeData(){
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

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = 'test file.txt'; //'ionicLogo.png'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title ='text file' ; // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode('test file'); // converting your binary string to Blog
        INSERT conVer;
    }
    @IsTest
    static void test_method001(){
      Account oAcc = [SELECT ID FROM ACCOUNT LIMIT 1];

      test.startTest();
        //String strJson = 
        Expense__c record = new Expense__c();
        record.Date__c=Date.today(); 
		record.Location__c='locv';
		record.Vendor__c='ven';
		record.SalesTax__c=9;
		record.Amount__c=9000;
		record.Department__c='Dept'; 
		record.Expense_Type__c='Hotel';
        record.Client__c = oAcc.ID;

        list<DNA_wrapperCallout.wrapperFile> lstfile = new list<DNA_wrapperCallout.wrapperFile>();
        DNA_wrapperCallout reqObj = new DNA_wrapperCallout(record, lstfile);
        String strJson = JSON.serialize(reqObj);

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/expensemanage';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(strJson);       

        RestContext.request = request;
        Restcontext.response = res;
		DNA_getExpensoRecords.doPost(reqObj);

      test.stopTest();
    }
    @IsTest
    static void test_method002(){
        Account oAcc = [SELECT ID FROM ACCOUNT LIMIT 1];

        test.startTest();
        Expense__c record = new Expense__c();
        record.Date__c=Date.today(); 
		record.Location__c='locv';
		record.Vendor__c='ven';
		record.SalesTax__c=9;
		record.Amount__c=9000;
		record.Department__c='Dept'; 
		record.Expense_Type__c='Hotel';
        record.Client__c = oAcc.ID;

        list<DNA_wrapperCallout.wrapperFile> lstfile = new list<DNA_wrapperCallout.wrapperFile>();
        lstfile.add(new DNA_wrapperCallout.wrapperFile('', 'test file', 'test_data.txt', 'test base64'));
        DNA_wrapperCallout reqObj = new DNA_wrapperCallout(record, lstfile);
        String strJson = JSON.serialize(reqObj);

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/expensemanage';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(strJson);       

        RestContext.request = request;
        Restcontext.response = res;
		DNA_getExpensoRecords.doPost(reqObj);     
      
    }
    @IsTest
    static void test_method003(){
      
      Account oAcc = [SELECT ID FROM ACCOUNT LIMIT 1];

        test.startTest();
        Expense__c record = new Expense__c();
        record.Date__c=Date.today(); 
		record.Location__c='locv';
		record.Vendor__c='ven';
		record.SalesTax__c=9;
		record.Amount__c=9000;
		record.Department__c='Dept'; 
		record.Expense_Type__c='Hotel';
        //record.Client__c = oAcc.ID;
        

        list<DNA_wrapperCallout.wrapperFile> lstfile = new list<DNA_wrapperCallout.wrapperFile>();
        lstfile.add(new DNA_wrapperCallout.wrapperFile('', 'test file', 'test_data.txt', 'test base64'));
        DNA_wrapperCallout reqObj = new DNA_wrapperCallout(record, lstfile);
        String strJson = JSON.serialize(reqObj);

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/expensemanage';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(strJson);       

        RestContext.request = request;
        Restcontext.response = res;
		DNA_getExpensoRecords.doPost(reqObj); 
      
    }
    @IsTest
    static void test_method004(){
      
        Account oAcc = [SELECT ID FROM ACCOUNT LIMIT 1];
        Expense__c oExp = [SELECT ID FROM Expense__c LIMIT 1];

        test.startTest();
        Expense__c record = new Expense__c();
        record.Date__c=Date.today(); 
		record.Location__c='locv';
		record.Vendor__c='ven';
		record.SalesTax__c=9;
		record.Amount__c=9000;
		record.Department__c='Dept'; 
		record.Expense_Type__c='Hotel';
        record.Client__c = oAcc.ID;
        record.id =  oExp.id;       

        list<DNA_wrapperCallout.wrapperFile> lstfile = new list<DNA_wrapperCallout.wrapperFile>();
        lstfile.add(new DNA_wrapperCallout.wrapperFile('', 'test file', 'test_data.txt', 'test base64'));
        DNA_wrapperCallout reqObj = new DNA_wrapperCallout(record, lstfile);
        String strJson = JSON.serialize(reqObj);

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/expensemanage';
        request.httpMethod = 'PATCH';
		request.requestBody = Blob.valueof(strJson);       

        RestContext.request = request;
        Restcontext.response = res;
		DNA_getExpensoRecords.doPatch(reqObj); 
    }
     @IsTest
    static void test_method005(){
      
        Account oAcc = [SELECT ID FROM ACCOUNT LIMIT 1];
        Expense__c oExp = [SELECT ID FROM Expense__c LIMIT 1];
        ContentDocument oCd = [SELECT ID FROM ContentDocument LIMIT 1];

        test.startTest();
        Expense__c record = new Expense__c();
        record.Date__c=Date.today(); 
		record.Location__c='locv';
		record.Vendor__c='ven';
		record.SalesTax__c=9;
		record.Amount__c=9000;
		record.Department__c='Dept'; 
		record.Expense_Type__c='Hotel';
        record.Client__c = oAcc.ID;
        record.id =  oExp.id;       

        list<DNA_wrapperCallout.wrapperFile> lstfile = new list<DNA_wrapperCallout.wrapperFile>();
        lstfile.add(new DNA_wrapperCallout.wrapperFile(oCd.Id, 'test file', 'test_data.txt', 'test base64'));
        DNA_wrapperCallout reqObj = new DNA_wrapperCallout(record, lstfile);
        String strJson = JSON.serialize(reqObj);

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/expensemanage';
        request.httpMethod = 'PATCH';
		request.requestBody = Blob.valueof(strJson);       

        RestContext.request = request;
        Restcontext.response = res;
		DNA_getExpensoRecords.doPatch(reqObj); 
    }
    @IsTest
    static void test_method006(){
      
        Account oAcc = [SELECT ID FROM ACCOUNT LIMIT 1];
        Expense__c oExp = [SELECT ID FROM Expense__c LIMIT 1];
        ContentDocument oCd = [SELECT ID FROM ContentDocument LIMIT 1];

        test.startTest();
        Expense__c record = new Expense__c();
        record.Date__c=Date.today(); 
		record.Location__c='locv';
		record.Vendor__c='ven';
		record.SalesTax__c=9;
		record.Amount__c=9000;
		record.Department__c='Dept'; 
		record.Expense_Type__c='Hotel';
        record.Client__c = oAcc.ID;
        record.id =  oExp.id;       

        list<DNA_wrapperCallout.wrapperFile> lstfile = new list<DNA_wrapperCallout.wrapperFile>();
        lstfile.add(new DNA_wrapperCallout.wrapperFile('1234561472456', 'test file', 'test_data.txt', 'test base64'));
        DNA_wrapperCallout reqObj = new DNA_wrapperCallout(record, lstfile);
        String strJson = JSON.serialize(reqObj);

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/expensemanage';
        request.httpMethod = 'PATCH';
		request.requestBody = Blob.valueof(strJson);       

        RestContext.request = request;
        Restcontext.response = res;
		DNA_getExpensoRecords.doPatch(reqObj); 
    }
   
}