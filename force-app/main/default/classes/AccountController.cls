public with sharing class AccountController {
  @AuraEnabled(cacheable=true)
  public static List<Account> getAllAccounts() {
    try {
      List<Account> allAccounts = [
        SELECT Name, Industry, Rating, BillingCity
        FROM Account
      ];
      return allAccounts;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static List<Account> getSearchedAccount(String searchName) {
    List<Account> searchedAccList = new List<Account>();
    if (String.isBlank(searchName)) {
      return null;
    }
    String safeSearchName = String.escapeSingleQuotes(searchName);
    System.debug('Safe search term is ' + safeSearchName);
    String accountQuery =
      'SELECT Id, Name, AnnualRevenue, CustomerPriority__c FROM Account WHERE Name LIKE ' +
      '\'' +
      safeSearchName +
      '%\'';
    System.debug('Search query is ' + accountQuery);
    try {
      searchedAccList = (List<Account>) Database.query(accountQuery);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return searchedAccList;
  }
}