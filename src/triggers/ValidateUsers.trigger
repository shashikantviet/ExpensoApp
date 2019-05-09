/*
* @TriggerName    : ValidateUsers
* @CreatedOn    : 26/12/2018
* @CreatedBy    : Shashi Yadav
* @Description  : Trigger to validate users.
*/
trigger ValidateUsers on User (after insert, after update) {
    if(Trigger.isafter && Trigger.isInsert){
        User_triggerHandler.afterInsert(Trigger.New);
    }
    if(Trigger.isafter && Trigger.isUpdate){
        User_triggerHandler.afterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}