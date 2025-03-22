public with sharing class CTLocationTriggerHandler {
    public static void beforeInsert(List<Location__c> newLocations) {
        for(Location__c location : newLocations) {
            if(location.Status__c == null) {
                location.Status__c = 'Green';
            }
        }
    }

    public static void beforeUpdate(List<Location__c> newLocations, Map<Id, Location__c> oldMap) {
        for(Location__c location : newLocations) {
            // Get the old version of the record
            Location__c oldLocation = oldMap.get(location.Id);
            
            // Check if status has changed
            if(location.Status__c != oldLocation.Status__c) {
                location.Status_Update_Date__c = Date.today();
            }
        }
    }
}