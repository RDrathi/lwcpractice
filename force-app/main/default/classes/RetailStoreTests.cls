/**
 * @description - Test Class for RetailStoreTrigger, RetailStoreTriggerHandler,
 * storeControllerExt, StoreCustomController, MockCoffeePriceResponse
 */

@isTest
public with sharing class RetailStoreTests {
  @TestSetup
  static void createRecords() {
    TestFactory.createRetailStores(3, true);
  }

  @isTest
  //Test to confirm that RetailStoreTrigger and RetailStoreTriggerHandler work Correctly
  static void testCustomerFeedbackChange() {
    List<Retail_Store__c> retailStores = [
      SELECT Id, Customer_Feedback__c
      FROM Retail_Store__c
      WHERE Name LIKE 'Pune Hub%'
    ];
    Assert.isTrue(!retailStores.isEmpty());
    List<Id> retailStoreIds = new List<Id>();
    for (Retail_Store__c storeRec : retailStores) {
      retailStoreIds.add(storeRec.Id);
    }
    Integer caseCountBefore = [
      SELECT COUNT()
      FROM Case
      WHERE Retail_Store__c IN :retailStoreIds
    ];
    System.debug(
      'DML statements run before Test.startTest() - ' +
      Limits.getDmlStatements()
    );
    //Run the Code
    Test.startTest();
    System.debug(
      'DML statements run after Test.startTest() - ' + Limits.getDmlStatements()
    );
    for (Retail_Store__c storeRec : retailStores) {
      storeRec.Customer_Feedback__c = 'Poor';
    }
    Database.update(retailStores, true);
    Test.stopTest();
    List<Case> casesAfter = [
      SELECT Subject, Status, Priority, Retail_Store__c
      FROM Case
      WHERE Retail_Store__c IN :retailStoreIds
      ORDER BY LastModifiedDate DESC
    ];
    Assert.areEqual(
      caseCountBefore + retailStores.size(),
      casesAfter.size(),
      'One new Case per retail store should have been created'
    );
    Assert.areEqual(
      'Poor Customer Satisfaction',
      casesAfter[0].Subject,
      'Subject Should be \'Poor Customer Satisfaction\''
    );
    Assert.areEqual('New', casesAfter[0].Status, 'Status should be New');
    Assert.areEqual('High', casesAfter[0].Priority, 'Priority should be High');
    Assert.areEqual(
      false,
      RetailStoreTriggerHandler.platformEventsFailed,
      'All Platform Events Should succeed'
    ); /**Test context is able to retrieve the value of platformEventsFailed from RetailStoreTriggerHandler
    because platformEventsFailed is defined as @testVisible
    */
  }

  @isTest
  static void testStoreControllerExt() {
    //Get the initial store and any existing cases
    List<Retail_Store__c> retailStores = [
      SELECT Id, Customer_Feedback__c
      FROM Retail_Store__c
      WHERE Name LIKE 'Pune Hub%'
    ];
    Assert.isTrue(!retailStores.isEmpty());
    List<Id> retailStoreIds = new List<Id>();
    for (Retail_Store__c storeRec : retailStores) {
      retailStoreIds.add(storeRec.Id);
    }
    Integer caseCountBefore = [
      SELECT COUNT()
      FROM Case
      WHERE Retail_Store__c IN :retailStoreIds
    ];
    List<List<Case>> nestesdCaseList = new List<List<Case>>();

    //Run the Code
    Test.startTest();
    for (Retail_Store__c storeRec : retailStores) {
      storeRec.Customer_Feedback__c = 'Poor';
    }
    Database.update(retailStores, true);

    for (Retail_Store__c storeRec : retailStores) {
      //Initialize the controller extension
      ApexPages.StandardController stdCtrl = new ApexPages.StandardController(
        storeRec
      );
      storeControllerExt strExt = new storeControllerExt(stdCtrl);
      nestesdCaseList.add(strExt.getOpenCases());
    }
    Test.stopTest();
    Assert.areEqual(
      caseCountBefore + retailStores.size(),
      nestesdCaseList.size(),
      'One new Case per retail store should have been created'
    );
    Assert.areEqual(
      'Poor Customer Satisfaction',
      nestesdCaseList[0][0].Subject,
      'Subject Should be \'Poor Customer Satisfaction\''
    );

    Assert.areEqual(
      'New',
      nestesdCaseList[0][0].Status,
      'Status should be New'
    );

    Assert.areEqual(
      'High',
      nestesdCaseList[0][0].Priority,
      'Priority should be High'
    );
  }

  @isTest
  //Test for the StoreCustomController update a Store functionality without access
  static void testStoreCustomControllerUpdateNoAccess() {
    List<Retail_Store__c> retailStores = [
      SELECT Id, Name, Buzz_Id__c, City__c, Country__c
      FROM Retail_Store__c
      WHERE Name LIKE 'Pune Hub%'
    ];
    PageReference pageRef = Page.StoreCreateCustom;
    Test.setCurrentPage(pageRef);

    Test.startTest();
    User RetailTestUser = TestFactory.createUser('Retail Profile');
    //Retail users do not have access to create Retail Store. Irony, right?? 😁
    System.runAs(RetailTestUser) {
      for (Retail_Store__c currentStore : retailStores) {
        ApexPages.currentPage().getParameters().put('id', currentStore.Id);
        StoreCustomController controller = new StoreCustomController();
        controller.city = 'Mumbai';
        PageReference saveRedirect = controller.save();
        Assert.isNull(saveRedirect, 'Redirect should be Null');
      }
    }
    Test.stopTest();
    List<Retail_Store__c> UpdatedRetailStores = [
      SELECT Id, Name, Buzz_Id__c, City__c, Country__c
      FROM Retail_Store__c
      WHERE Name LIKE 'Pune Hub%'
    ];
    Assert.areEqual(
      UpdatedRetailStores[0].City__c,
      retailStores[0].City__c,
      'City shouldn\'t have been changed'
    );
    Assert.areEqual(
      1,
      ApexPages.getMessages().size(),
      'There should be 1 messages'
    );
    ApexPages.Message errorMessage = new ApexPages.Message(
      ApexPages.Severity.ERROR,
      'User does not have access to create or edit a Retail Store'
    );
    Assert.areEqual(
      errorMessage,
      ApexPages.getMessages()[0],
      'The error message should reflect the lack of access'
    );
  }

  @isTest
  //Test to confirm Invocable method in StoreTriggerHandler works correctly using mock framework
  static void testExternalCallout() {
    Test.startTest();
    /* Please uncomment out Line 132 and comment out Line 133-136 in RetailStoreTriggerHandler
     to properly invoke mock framework */
    Test.setMock(HttpCalloutMock.class, new HttpMockCoffeePrice(200));
    List<String> coffeeTypes = new List<String>{ 'Arabica;Robusta' };
    List<RetailStoreTriggerHandler.CoffeePrice> coffeePrices = RetailStoreTriggerHandler.updateCoffeeprices(
      coffeeTypes
    );
    String prices = coffeePrices[0].prices;
    System.debug(prices);
    Assert.isTrue(
      prices.contains('Arabica'),
      'Arabica should be part of the response'
    );
    Assert.isTrue(
      prices.contains('Robusta'),
      'Robusta should be part of the response'
    );
    Test.stopTest();
  }
}