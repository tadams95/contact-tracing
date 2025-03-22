trigger CTPersonTrigger on Person__c (before insert, after insert, before update, after update, before delete, after undelete) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
     for (Person__c person : Trigger.new){
      person.Health_Status__c = 'Green';
      person.Token__c = CTPersonController.getToken(person.Mobile__c);
     } 
    }
   when BEFORE_UPDATE {
    CTPersonTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
   } 
  }
}