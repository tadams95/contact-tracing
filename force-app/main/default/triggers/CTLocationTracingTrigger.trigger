trigger CTLocationTracingTrigger on Location_Tracing__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore) {
        CTLocationTracingTriggerHandler.beforeInsert(Trigger.new);
    }
}
