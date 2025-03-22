@isTest
public with sharing class ContactTriggerHandlerTest {
    
    @isTest
    public static void testAfterInsertHandler() {
        // Test data setup
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert testAccounts;
        
        // To make sure we're testing the trigger handler rather than AnnotationsDemo
        // let's verify ContactTriggerHandler exists before running the test
        System.assertNotEquals(null, Type.forName('ContactTriggerHandler'), 
            'ContactTriggerHandler class should exist');
        
        // Create test contacts - mix of active and inactive
        List<Contact> testContacts = new List<Contact>{
            new Contact(
                FirstName = 'Test1',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = true
            ),
            new Contact(
                FirstName = 'Test2',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = true
            ),
            new Contact(
                FirstName = 'Test3',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = false
            ),
            new Contact(
                FirstName = 'Test4',
                LastName = 'Contact',
                AccountId = testAccounts[1].Id,
                Active__c = true
            )
        };
        
        // Execute test
        Test.startTest();
        // Insert contacts should trigger the ContactTrigger, which calls the handler
        insert testContacts;
        Test.stopTest();
        
        // Verify results
        List<Account> updatedAccounts = [SELECT Id, Name, Active_Contacts__c FROM Account WHERE Id IN :testAccounts ORDER BY Name];
        
        // Verify that our test is running against the right class
        System.debug('Class being tested: ContactTriggerHandler');
        
        // Account 1 should have 2 active contacts
        System.assertEquals(2, updatedAccounts[0].Active_Contacts__c, 
                           'First account should have 2 active contacts');
        
        // Account 2 should have 1 active contact
        System.assertEquals(1, updatedAccounts[1].Active_Contacts__c, 
                           'Second account should have 1 active contact');
    }
    
    @isTest
    public static void testAfterUpdateHandler() {
        // Test data setup
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert testAccounts;
        
        // Create test contacts - mix of active and inactive
        List<Contact> testContacts = new List<Contact>{
            new Contact(
                FirstName = 'Test1',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = true
            ),
            new Contact(
                FirstName = 'Test2',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = false
            ),
            new Contact(
                FirstName = 'Test3',
                LastName = 'Contact',
                AccountId = testAccounts[1].Id,
                Active__c = false
            )
        };
        insert testContacts;
        
        // Verify initial state
        List<Account> initialAccounts = [SELECT Id, Name, Active_Contacts__c FROM Account WHERE Id IN :testAccounts ORDER BY Name];
        System.assertEquals(1, initialAccounts[0].Active_Contacts__c, 'First account should have 1 active contact initially');
        System.assertEquals(0, initialAccounts[1].Active_Contacts__c, 'Second account should have 0 active contacts initially');
        
        // Update contacts - Toggle active flag
        testContacts[0].Active__c = false; // Turn off an active contact
        testContacts[1].Active__c = true;  // Turn on an inactive contact
        testContacts[2].Active__c = true;  // Turn on an inactive contact
        
        // Execute test
        Test.startTest();
        update testContacts;
        Test.stopTest();
        
        // Verify results
        List<Account> updatedAccounts = [SELECT Id, Name, Active_Contacts__c FROM Account WHERE Id IN :testAccounts ORDER BY Name];
        System.assertEquals(1, updatedAccounts[0].Active_Contacts__c, 'First account should still have 1 active contact');
        System.assertEquals(1, updatedAccounts[1].Active_Contacts__c, 'Second account should now have 1 active contact');
        
        // Test changing Account relationship
        Contact movedContact = testContacts[2];
        movedContact.AccountId = testAccounts[0].Id;
        
        update movedContact;
        
        // Verify results after moving contact
        updatedAccounts = [SELECT Id, Name, Active_Contacts__c FROM Account WHERE Id IN :testAccounts ORDER BY Name];
        System.assertEquals(2, updatedAccounts[0].Active_Contacts__c, 'First account should now have 2 active contacts');
        System.assertEquals(0, updatedAccounts[1].Active_Contacts__c, 'Second account should now have 0 active contacts');
    }
    
    @isTest
    public static void testAfterDeleteHandler() {
        // Test data setup
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1')
        };
        insert testAccounts;
        
        // Create test contacts
        List<Contact> testContacts = new List<Contact>{
            new Contact(
                FirstName = 'Test1',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = true
            ),
            new Contact(
                FirstName = 'Test2',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = true
            )
        };
        insert testContacts;
        
        // Verify initial state
        List<Account> initialAccounts = [SELECT Id, Active_Contacts__c FROM Account WHERE Id IN :testAccounts];
        System.assertEquals(2, initialAccounts[0].Active_Contacts__c, 'Account should have 2 active contacts initially');
        
        // Execute test - delete one contact
        Test.startTest();
        delete testContacts[0];
        Test.stopTest();
        
        // Verify results
        List<Account> updatedAccounts = [SELECT Id, Active_Contacts__c FROM Account WHERE Id IN :testAccounts];
        System.assertEquals(1, updatedAccounts[0].Active_Contacts__c, 'Account should have 1 active contact after deletion');
    }
    
    @isTest
    public static void testAfterUndeleteHandler() {
        // Test data setup
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1')
        };
        insert testAccounts;
        
        // Create test contacts
        List<Contact> testContacts = new List<Contact>{
            new Contact(
                FirstName = 'Test1',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = true
            ),
            new Contact(
                FirstName = 'Test2',
                LastName = 'Contact',
                AccountId = testAccounts[0].Id,
                Active__c = true
            )
        };
        insert testContacts;
        
        // Delete contacts for later undelete
        delete testContacts;
        
        // Verify state after deletion
        List<Account> accountsAfterDelete = [SELECT Id, Active_Contacts__c FROM Account WHERE Id IN :testAccounts];
        System.assertEquals(0, accountsAfterDelete[0].Active_Contacts__c, 'Account should have 0 active contacts after deletion');
        
        // Execute test - undelete contacts
        Test.startTest();
        undelete testContacts;
        Test.stopTest();
        
        // Verify results
        List<Account> updatedAccounts = [SELECT Id, Active_Contacts__c FROM Account WHERE Id IN :testAccounts];
        System.assertEquals(2, updatedAccounts[0].Active_Contacts__c, 'Account should have 2 active contacts after undelete');
    }
}