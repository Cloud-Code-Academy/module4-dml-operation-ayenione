/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Yinka Ayeni @ Cloud Code Academy
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance

        if(!Schema.SObjectType.Account.isCreateable()){
             return null;
        }

        Account acc = new Account();
        Integer accSuffix = (Integer) (Math.random() * 10);
        String suffixConvert = String.valueOf(accSuffix);


        // Set some fields on the Account

    
            acc.Name = 'Fidelity'+ suffixConvert;


            acc.NumberOfEmployees = 10;
       

            acc.BillingCity = 'Oswego';
            acc.BillingState = 'Missippi';

        // Insert the Account into the database
   
            try{

                insert acc;

            } catch (DmlException e) {

                  return null;
            }
         // Return the Id of the newly created Account
            return acc.Id;
        }
                          
       
    

   /** */ /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline

        Account newAcc = new Account (
            Name = name ,
            industry = industry
          
        );

        // Insert the Account
            insert newAcc ;
            
          }
        
    
     

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance

        Contact newCon = new Contact();

        // Set some fields on the Contact

        newCon.LastName = 'Fredricks';
        
        // Set the AccountId field to the given accountId
        if (accountId != null){

            newCon.AccountId = accountId; 
        }
        

        // Insert the Contact into the database

        insert newCon;

        // Return the Id of the newly created Contact
        return newCon.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact myContact = [SELECT Id, lastName FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name


        if (myContact != null){

            myContact.LastName = newLastName;
        }

        // Update the Contact in the database

        upsert myContact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity myOpportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId LIMIT 1];

        // Update the Opportunity's stage

        myOpportunity.StageName = newStage;
        // Update the Opportunity in the database

        upsert myOpportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {

        // Query the account
        
        Account myAccount = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry

        myAccount.Name = newName;

        myAccount.Industry = newIndustry;

        update myAccount;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {

        if (opportunities == null || opportunities.isEmpty()) {
            System.debug('No Opportunities provided for upsert.');
            return;
        }
        
        // Loop through each Opportunity in the list

        
        for ( Opportunity opp:opportunities) {

        // Set the Opportunity's Stage to Qualification

        opp.StageName = 'Qualification';
        // Set the Opportunity's Close Date to 3 months from today

        opp.CloseDate = Date.today().addMonths(3);
        // Set the Opportunity's Amount to 50000

        opp.Amount = 50000;


        }
         // Upsert the opportunities List so that records are either updated or created
        try{
            upsert opportunities;

        } catch (DmlException e){

           System.debug(LoggingLevel.ERROR, 'Failed to upsert Opportunities: ' + e.getMessage())  ;

             }

         }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {

        // check if an account with that account name already exists

        Account acc;

        List<Account> existingAccount = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];

        // if there is no account with that name, create a new one

        if(!existingAccount.isEmpty()) {

            acc = existingAccount[0];
            
        }

        else {

            acc = new Account(Name = accountName);

            try {
                insert acc;
            } catch (DmlException e){
                System.debug('Failed to insert a new accunt '+ e.getMessage());
            }
        }

        Map<String, Opportunity> oppMap= new Map<String, Opportunity>();

        for (Opportunity existingOpp : [SELECT Id, Name FROM Opportunity WHERE AccountId = :acc.Id]) {
            oppMap.put(existingOpp.Name, existingOpp);
        }
    

        for (String oppName : oppNames){

            if(!oppMap.containsKey(oppName)){

                Opportunity opp = new Opportunity(Name = oppName, AccountId = acc.Id, StageName = 'Qualification', CloseDate = Date.today().addMonths(2));

                oppMap.put(oppName, opp);
            }

        }

        try {
            upsert oppMap.values();

        } catch (DmlException e) {
            System.debug('Failed to upsert opportunities '  + e.getMessage());
        }

    }

  
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];

        Account acc;

		// if the Account exists, update the description

        if (!accounts.isEmpty()){

            acc = accounts[0];

            acc.Description = 'Updated Account';
            

            }

            else {
           // otherwise, create a new Account and set the description     
             acc  = new Account (Name = accountName, Description = 'New Account');
              
            }
        		
		// Upsert the Account
        upsert acc;

        
		return acc;
	}
    
    
    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact

        String accountName ;

        for (Contact contact : contactsToUpsert) {

        // Get the account name based on the contact's last name

        accountName = contact.LastName;

        // Query for an existing account with the same name or create one if it doesn't exist
        List<Account> accLastNameMatch = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
    
         // Extract the Account Name from Contact's LastName

        // Get the account based on the name or create one if it doesn't exist
       
        if (!accLastNameMatch.isEmpty()) {
            // Link the contact to the existing account
            contact.AccountId = accLastNameMatch[0].Id;
        } 
        
        else {
            // If no matching account exists, use upsertAccount to create one
            Account newAcc = upsertAccount(accountName);

           	// Link the Contact to its Account using the Account Id
           
            contact.AccountId = newAcc.Id;
        }
       
    }
         upsert contactsToUpsert;
}

 
    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
 public static void insertAndDeleteLeads(List<String> leadNames) {

        List<Lead>leadList  = new List<Lead>();
        // Loop through each Lead name

        for (String leadName : leadNames){

            
            Lead newLead = new Lead (LeadSource = 'Email', LastName = leadName, Company = leadName);

            leadList.add(newLead);

        }

       // Insert the Leads

        insert leadList;

        // Delete the Leads

        delete leadList;
        }

    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
public static void createAndDeleteCases(String accountId, Integer numOfCases) {


    Account accToInsert = new Account(Name = 'Test Account');

    List<Case>listOfCases = new List<Case>();

    accountId = accToInsert.Id;

    insert accToInsert;

    String caseNumber = 'Case Number ';
       
    for (Integer i = 0; i < numOfCases; i++ ) {

        caseNumber += String.valueOf(i+1);

        Case newCase = new Case(Description = caseNumber, Status ='New',  Origin = 'Phone');

        newCase.AccountId = accountId;

        listOfCases.add(newCase);

       
    }
 // Insert the cases

    insert listOfCases;
 
 // Delete the cases

    List<Case> casesToDelete = [SELECT Id FROM Case WHERE AccountId = :accountId];

    if (!casesToDelete.isEmpty()){

        delete casesToDelete;
    }
   }
}

