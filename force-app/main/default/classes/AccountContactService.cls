/**
 * @description Service class for handling Account-Contact relationship operations
 * Contains utility methods for updating account metrics based on related contacts
 */
public with sharing class AccountContactService {
    /**
     * @description Updates the Active_Contacts__c field on Accounts based on their related active contacts
     * @param accountIds Set of Account IDs that need to be updated
     */
    public static void updateActiveContacts(Set<Id> accountIds) {
        // Return early if no account IDs are provided
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        
        try {
            // Query for the count of active contacts for each account
            List<AggregateResult> results = [
                SELECT AccountId, COUNT(Id) totalContacts
                FROM Contact
                WHERE Active__c = TRUE AND AccountId IN :accountIds
                GROUP BY AccountId
            ];
            
            // Build list of accounts to update with new active contact counts
            List<Account> accountsToUpdate = new List<Account>();
            for (AggregateResult result : results) {
                // Extract account ID and total contacts count from query results
                String accId = String.valueOf(result.get('AccountId'));
                Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
                
                // Create account object with ID and updated contact count
                Account acc = new Account(Id = accId, Active_Contacts__c = totalContacts);
                accountsToUpdate.add(acc);
            }
            
            // Update accounts if there are any to update
            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
            
            // Handle accounts with no active contacts (they would not appear in the SOQL results)
            Set<Id> processedAccountIds = new Set<Id>();
            for (AggregateResult result : results) {
                processedAccountIds.add((Id)result.get('AccountId'));
            }
            
            // Find accounts that have no active contacts
            Set<Id> accountsWithNoActiveContacts = new Set<Id>(accountIds);
            accountsWithNoActiveContacts.removeAll(processedAccountIds);
            
            // If there are accounts with no active contacts, set their counts to zero
            if (!accountsWithNoActiveContacts.isEmpty()) {
                List<Account> accountsToZero = new List<Account>();
                for (Id accountId : accountsWithNoActiveContacts) {
                    accountsToZero.add(new Account(Id = accountId, Active_Contacts__c = 0));
                }
                update accountsToZero;
            }
        } catch (Exception e) {
            // Log exception or implement custom error handling
            System.debug(LoggingLevel.ERROR, 'Error updating active contacts: ' + e.getMessage());
            throw e; // Re-throw to allow caller to handle or implement custom error handling
        }
    }
}
