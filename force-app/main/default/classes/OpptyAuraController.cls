public with sharing class OpptyAuraController {
  @AuraEnabled
  public static List<Opportunity> getOpps() {
    try {
      List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity];
      return oppList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}