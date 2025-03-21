public with sharing class LeadTriggerHandler {
    public static void beforeInsertHandler(List<Lead> newRecords) {
        for (Lead leadRecord : newRecords) {
            if(String.isBlank(leadRecord.LeadSource)){
                leadRecord.LeadSource = 'Web';
            }
            if(String.isBlank(leadRecord.Industry)) {
                leadRecord.addError('The industry cannot be blank');
            }
        }
    }
    public static void afterInsertHandler() {

    }
    public static void beforeUpdateHandler() {

    }
}