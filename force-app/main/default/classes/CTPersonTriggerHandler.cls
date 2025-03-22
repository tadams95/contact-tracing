public class CTPersonTriggerHandler {
    
    public static void handleBeforeInsertUpdate(List<Person__c> newRecords) {
        for (Person__c person : newRecords) {
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
           }  
    }
    
    public static void handleBeforeUpdate(List<Person__c> newRecords, Map<Id, Person__c> oldMap) {
        for (Person__c person : newRecords){
           
            if (person.Health_Status__c != oldMap.get(person.Id).Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
            }
        }
        
    }
}
