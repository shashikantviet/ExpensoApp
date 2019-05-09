/*
* @ClassName    : Test_ValidateUsers
* @CreatedOn    : 27/12/2018
* @CreatedBy    : Shashi Yadav
* @Description  : 
*/
@isTest
public class Test_ValidateUsers {
    
    public static testmethod void usersTest(){
        List<User> newUsers = new List<User>();
        List<Id> lstOfInsrtdUsr =  new List<Id>();
        Profile sPro = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        newUsers.add(new user(Alias = 'standt1', Email='standarduser@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='Testing1', 
                              LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = sPro.Id,
                              TimeZoneSidKey='America/Los_Angeles', 
                              UserName='testpermissionsetuser1@testorg.com', 
                              DA_Expenso_App__User_Type__c = 'Expenso Sales User'));
        newUsers.add(new user(Alias = 'standt2', Email='standarduser@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='Testing2', 
                              LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = sPro.Id,
                              TimeZoneSidKey='America/Los_Angeles', 
                              UserName='testpermissionsetuser2@testorg.com', 
                              DA_Expenso_App__User_Type__c = 'Expenso Manager'));
        newUsers.add(new user(Alias = 'standt3', Email='standarduser3@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='Testing3', 
                              LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = sPro.Id,
                              TimeZoneSidKey='America/Los_Angeles', 
                              UserName='testpermissionsetuser3@testorg.com', 
                              DA_Expenso_App__User_Type__c = 'Expenso Finance Manager'));
        Database.insert(newUsers);
        
        
        
        for(User u: newUsers){
            lstOfInsrtdUsr.add(u.Id);
        }
        System.assertEquals(3,	[SELECT Count() 
                                 FROM PermissionSetAssignment 
                                 WHERE PermissionSet.Name = 'Expenso_User' and AssigneeId =: lstOfInsrtdUsr]);
        
    
        Integer i=1;
        for(User u : newUsers){
            Boolean isMake = false;
            if(i == 1){
                isMake = true;
            }else if(i == 2){
                isMake = false;
            }else{
                isMake = true;
            }
            i = i+1;
            u.Expenso_Finance_Manager__c = isMake;
            u.Expenso_Manager__c= false;
            u.Expenso_User__c = false;
        }
        Database.update(newUsers, false);
        System.assertEquals(3,	[SELECT Count() 
                                 FROM PermissionSetAssignment 
                                 WHERE PermissionSet.Name = 'Expenso_User' and AssigneeId =: lstOfInsrtdUsr]);
        
        
    }
    
}