public with sharing class OpportunityController {
  @AuraEnabled(cacheable=true)
  public static List<Opportunity> getRecords(Id accountId) {
    try {
      List<Opportunity> oppList = [
        SELECT Name, Amount
        FROM Opportunity
        WHERE AccountId = :accountId
      ];
      return oppList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}