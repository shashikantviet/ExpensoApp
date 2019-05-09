/*
* @ClassName    : User_triggerHandler
* @CreatedOn    : 26/12/2018
* @CreatedBy    : Shashi Yadav
* @Description  : Trigger Handler to validate user i.e to assign Users to permission-set if any fileds within(Expenso_Finance_Manager__c,Expenso_Manager__c,Expenso_User__c) of users is checked.
*/
public class User_triggerHandler {
    
    /*
* @MethodName    : afterInsert
* @Description  : This method will call after insert of users record.
*/
    public static void afterInsert(list<User> lstUser){
        addUserTOPermissionSet(lstUser);
    }
    /*
* @MethodName    : afterUpdate
* @Description  : This method will call after update if users record.
*/
    public static void afterUpdate(map<Id, User> newMap, map<Id,User> oldMap){
        addOrRemoveUserFromPermissionSet(newMap, oldMap);
    }
    
    /*
* @MethodName    : addUserTOPermissionSet
* @Description  : Assign the Users to permission-set(Expenso_User) if the users have check any of the fileds within(Expenso_Finance_Manager__c,Expenso_Manager__c,Expenso_User__c).
*/
    public static void addUserTOPermissionSet(list<User> lstUser){
        System.debug(Label.Expense_User_Permission_set);
        Id PermissionSetId = [SELECT id FROM PermissionSet WHERE Name =: Label.Expense_User_Permission_set limit 1].Id;
        list<PermissionSetAssignment> lstPerAssmnt = new list<PermissionSetAssignment>();
        
        for( User userObj : lstUser){
            if(userObj.DA_Expenso_App__User_Type__c == Label.Expenso_Sales_User || userObj.DA_Expenso_App__User_Type__c == Label.Expenso_Manager || userObj.DA_Expenso_App__User_Type__c == Label.Expenso_Finance_Manager) {
                PermissionSetAssignment  psa = new PermissionSetAssignment(
                    PermissionSetId = PermissionSetId,
                    AssigneeId = userObj.Id); 
                lstPerAssmnt.add(psa);
            }
        }
        INSERT lstPerAssmnt;
        System.debug('lstPerAssmnt-->'+lstPerAssmnt);
    }
    
    /*
* @MethodName    : addOrRemoveUserFromPermissionSet
* @Description  : This method adds or removes the users form permission-set based on users checked filed for (Expenso_Finance_Manager__c,Expenso_Manager__c,Expenso_User__c)
*/
    public static void addOrRemoveUserFromPermissionSet(map<Id, User> newMap, map<Id,User> oldMap){
        list<User> lstToAddPermissionset = new list<User>();
        map<Id,User> lstToremoveFromPermissionset = new map<Id,User>();
        
        map<Id,PermissionSetAssignment> mapUserInPermissionSet = new map<Id,PermissionSetAssignment>();
        
        for(PermissionSetAssignment obj : [SELECT AssigneeId 
                                           FROM PermissionSetAssignment 
                                           WHERE PermissionSet.Name =: Label.Expense_User_Permission_set and AssigneeId =: newMap.keySet()])
        {
            mapUserInPermissionSet.put(obj.AssigneeId, obj); 
        }
        
        for(Id UId : newMap.keySet()){
            User UpdateUser = newMap.get(UId);
            
            if(UpdateUser.DA_Expenso_App__User_Type__c == Label.Expenso_Sales_User ||
               UpdateUser.DA_Expenso_App__User_Type__c == Label.Expenso_Manager ||
               UpdateUser.DA_Expenso_App__User_Type__c == Label.Expenso_Finance_Manager)
                
                
            {
                if( ! mapUserInPermissionSet.containsKey(UId)){
                    lstToAddPermissionset.add(UpdateUser);
                }
            }else{
                
                if( mapUserInPermissionSet.containsKey(UId)){
                    lstToremoveFromPermissionset.put(UId,UpdateUser);
                }                
            }
        }
        addUserTOPermissionSet(lstToAddPermissionset);
        removeUSerFromPermissionSet(lstToremoveFromPermissionset);
    }
    
    /*
* @MethodName    : removeUSerFromPermissionSet
* @Description  : To remove the user from Permission-set on update, if fields criteria is not matched.
*/
    private static void removeUSerFromPermissionSet(map<Id,User> mapUser){
        Id PermissionSetId = [SELECT id FROM PermissionSet WHERE Name =: Label.Expense_User_Permission_set limit 1].Id;
        list<PermissionSetAssignment> lstPerAssmnt =  [SELECT id,AssigneeId 
                                                       FROM PermissionSetAssignment 
                                                       WHERE PermissionSet.Name =: Label.Expense_User_Permission_set and  AssigneeId =: mapUser.keySet()];
        Database.delete(lstPerAssmnt, false);
        
    }
}