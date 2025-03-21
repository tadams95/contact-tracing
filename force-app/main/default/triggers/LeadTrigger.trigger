trigger LeadTrigger on Lead (before insert, after insert, before update, after update) {
  switch on Trigger.operationType {
      when BEFORE_INSERT {
          LeadTriggerHandler.beforeInsertHandler(Trigger.new);
      }

      when AFTER_INSERT {
          LeadTriggerHandler.afterInsertHandler(Trigger.new);
      }

      when BEFORE_UPDATE {
          LeadTriggerHandler.beforeUpdateHandler(Trigger.new, Trigger.oldMap);
      }

      // Missing handler for AFTER_UPDATE operation which is in the trigger definition
      // Add this to handle the after update case
      when AFTER_UPDATE {
          // Currently no handler method exists for this operation
      }
  }
}
