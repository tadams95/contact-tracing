public with sharing class CTLocationController {
    /**
     * Get recent visitors of a location
     * @param locationId Id of the location
     * @return List<Person__c> List of people who visited the location
     */
    public static List<Person__c> getRecentVisitors(String locationId) {
        List<Location_Tracing__c> locationTraces = [
            SELECT Id, Person__c, Visit_Date__c 
            FROM Location_Tracing__c 
            WHERE Location__c = :locationId
            ORDER BY Visit_Date__c DESC
        ];
        
        Set<Id> personIds = new Set<Id>();
        for(Location_Tracing__c lt : locationTraces) {
            personIds.add(lt.Person__c);
        }
        
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Token__c 
                FROM Person__c 
                WHERE Id IN :personIds
                ORDER BY Name];
    }
    
    /**
     * Get all locations with visitor count in the last 10 days
     * @return List<Location__c> List of locations with visitor count
     */
    public static List<Location__c> getRecentLocations() {
        List<Location__c> locations = [
            SELECT Id, Name, Address__c, Pincode__c, Status__c,
                   (SELECT Id FROM Location_Tracing__r WHERE Visit_Date__c = LAST_N_DAYS:10)
            FROM Location__c
            ORDER BY Name
        ];
        
        return locations;
    }
    
    /**
     * Search locations by name, address or pincode
     * @param searchTerm Search term
     * @return List<Location__c> List of locations matching the search term
     */
    public static List<Location__c> searchLocations(String searchTerm) {
        searchTerm = '%' + searchTerm + '%';
        return [
            SELECT Id, Name, Address__c, Pincode__c, Status__c
            FROM Location__c 
            WHERE Name LIKE :searchTerm 
                OR Address__c LIKE :searchTerm 
                OR Pincode__c LIKE :searchTerm
            ORDER BY Name
        ];
    }
    
    /**
     * Get a location by id
     * @param locationId Id of the location
     * @return Location__c Location record
     */
    public static Location__c getLocationById(String locationId) {
        List<Location__c> locations = [
            SELECT Id, Name, Address__c, Pincode__c, Status__c, Status_Update_Date__c
            FROM Location__c 
            WHERE Id = :locationId
        ];
        if(locations != null && locations.size() > 0) {
            return locations[0];
        }
        return null;
    }
}
