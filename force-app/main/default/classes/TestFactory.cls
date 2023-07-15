/**
 * @description - Test Factory to create commonly used data for testers
 */
@isTest
public with sharing class TestFactory {
  /**
   * @description - Create Retail Test Stores
   * @param  storeToCreate - The number of test stores to create
   * @param performDML - Determines whether or not DML should fire or not
   * @return - List of stores for Testing
   */
  public static List<Retail_Store__c> createRetailStores(
    Integer storeToCreate,
    Boolean performDML
  ) {
    List<Retail_Store__c> newRetailStores = new List<Retail_Store__c>();
    for (Integer i = 0; i < storeToCreate; i++) {
      Retail_Store__c storeRec = new Retail_Store__c();
      storeRec.Name = 'Pune Hub ' + (i + 1);
      storeRec.Customer_Feedback__c = 'Good';
      storeRec.City__c = 'Pune';
      storeRec.Country__c = 'India';
      storeRec.Buzz_Id__c = 'TESTBUZZ' + (i + 1);
      newRetailStores.add(storeRec);
    }
    if (performDML) {
      Database.insert(newRetailStores, false);
    }
    return newRetailStores;
  }

  /**
   * @description - Create a test user
   * @param profileName - The number of the profile the test user should have
   * @return New User for Testing
   */
  public static User createUser(String profileName) {
    Profile userProfile = [SELECT Id FROM Profile WHERE Name = :profileName];
    User testUser = new User(
      FirstName = 'Super',
      LastName = 'Tester',
      profileId = userProfile.Id,
      Email = 'stester@terrified.com',
      Username = 'stester@terrified.com',
      CompanyName = 'Rathindra and Co.',
      Title = 'Awesome Tester',
      Alias = 'stester',
      TimeZoneSidKey='Asia/Kolkata',
      LocaleSidKey='en_IN',
      EmailEncodingKey='UTF-8',
      LanguageLocaleKey='en_US'
    );
    return testUser;
  }
}