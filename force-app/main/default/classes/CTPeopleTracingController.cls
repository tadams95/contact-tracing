public with sharing class CTPeopleTracingController {
    /**
     * Get contact traces by person id
     * @param personId Id of the person
     * @return List<People_Tracing__c> List of contact traces
     */
    public static List<People_Tracing__c> getTracesByPersonId(String personId) {
        return [
            SELECT Id, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c,
                   Person_1__r.Name, Person_1__r.Health_Status__c, Person_1__r.Mobile__c,
                   Person_2__r.Name, Person_2__r.Health_Status__c, Person_2__r.Mobile__c
            FROM People_Tracing__c
            WHERE Person_1__c = :personId OR Person_2__c = :personId
            ORDER BY Contact_Date__c DESC
        ];
    }
    
    /**
     * Create a new contact trace between two people
     * @param person1Id Id of first person
     * @param person2Id Id of second person
     * @param contactType Type of contact (Direct, Indirect, etc.)
     * @param contactDate Date when contact occurred
     * @return String Id of the newly created trace or error message
     */
    public static String createPeopleTrace(String person1Id, String person2Id, String contactType, Date contactDate) {
        try {
            // Check if trace already exists
            List<People_Tracing__c> existingTraces = [
                SELECT Id FROM People_Tracing__c
                WHERE (Person_1__c = :person1Id AND Person_2__c = :person2Id) OR
                      (Person_1__c = :person2Id AND Person_2__c = :person1Id)
                LIMIT 1
            ];
            
            if (!existingTraces.isEmpty()) {
                return 'Trace already exists between these people.';
            }
            
            // Create new trace
            People_Tracing__c trace = new People_Tracing__c(
                Person_1__c = person1Id,
                Person_2__c = person2Id,
                Contact_Type__c = contactType,
                Contact_Date__c = contactDate
            );
            
            insert trace;
            return trace.Id;
            
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}
