public with sharing class CTLocationTracingController {
    /**
     * Get location traces by location id
     * @param locationId Id of the location
     * @return List<Location_Tracing__c> List of location traces
     */
    public static List<Location_Tracing__c> getVisitors(String locationId) {
        return [
            SELECT Id, Person__c, Location__c, Visit_Date__c,
                   Person__r.Name, Person__r.Health_Status__c, Person__r.Mobile__c, Person__r.Token__c
            FROM Location_Tracing__c
            WHERE Location__c = :locationId
            ORDER BY Visit_Date__c DESC
        ];
    }
    
    /**
     * Get location traces by person id
     * @param personId Id of the person
     * @return List<Location_Tracing__c> List of location traces
     */
    public static List<Location_Tracing__c> getLocationsByPersonId(String personId) {
        return [
            SELECT Id, Person__c, Location__c, Visit_Date__c,
                   Location__r.Name, Location__r.Address__c, Location__r.Pincode__c, Location__r.Status__c
            FROM Location_Tracing__c
            WHERE Person__c = :personId
            ORDER BY Visit_Date__c DESC
        ];
    }
    
    /**
     * Create a new location trace record
     * @param personId Id of the person who visited the location
     * @param locationId Id of the visited location
     * @param visitDate Date of the visit
     * @return String Id of the newly created trace or error message
     */
    public static String createLocationTrace(String personId, String locationId, Date visitDate) {
        try {
            // Check if trace already exists
            List<Location_Tracing__c> existingTraces = [
                SELECT Id FROM Location_Tracing__c
                WHERE Person__c = :personId AND Location__c = :locationId AND Visit_Date__c = :visitDate
                LIMIT 1
            ];
            
            if (!existingTraces.isEmpty()) {
                return 'Trace already exists for this person and location on the given date.';
            }
            
            // Create new trace
            Location_Tracing__c trace = new Location_Tracing__c(
                Person__c = personId,
                Location__c = locationId,
                Visit_Date__c = visitDate
            );
            
            insert trace;
            return trace.Id;
            
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}
