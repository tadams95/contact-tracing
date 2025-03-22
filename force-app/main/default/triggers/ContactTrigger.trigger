/**
 * @description Trigger for Contact object that handles counting active contacts
 * for related Account records
 */
trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ContactTriggerHandler.afterInsertHandler(Trigger.new);
        } else if (Trigger.isUpdate) {
            ContactTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            ContactTriggerHandler.afterDeleteHandler(Trigger.old);
        } else if (Trigger.isUndelete) {
            ContactTriggerHandler.afterUndeleteHandler(Trigger.new);
        }
    }
}