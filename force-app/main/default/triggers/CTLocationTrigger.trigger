trigger CTLocationTrigger on Location__c (before insert, before update) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      // Set default status to 'Green' for new locations
      CTLocationTriggerHandler.beforeInsert(Trigger.new);
    }
    when BEFORE_UPDATE {
      // If status changes, update Status_Update_Date__c
      CTLocationTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
  }
}