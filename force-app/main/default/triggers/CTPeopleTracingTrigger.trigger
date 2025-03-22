trigger CTPeopleTracingTrigger on People_Tracing__c (before insert, before update, after update) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      CTPeopleTracingTriggerHandler.beforeInsert(Trigger.new);
    }
    when BEFORE_UPDATE {
      CTPeopleTracingTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    when AFTER_UPDATE {
      CTPeopleTracingTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
  }
}