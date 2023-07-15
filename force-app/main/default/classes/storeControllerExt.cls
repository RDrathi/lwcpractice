public with sharing class storeControllerExt {
  private final Retail_Store__c store;

  public storeControllerExt(ApexPages.StandardController stdController) {
    this.store = (Retail_Store__c) stdController.getRecord();
  }

  public List<Case> getOpenCases() {
    return getOpenCasesWithId(this.store.Id);
  }

  @AuraEnabled(cacheable=true) //This methos will be used in LWC
  public static List<Case> getOpenCasesWithId(Id storeId) {
    try {
      return [
        SELECT Subject, Status, Priority, CreatedDate
        FROM Case
        WHERE IsClosed = FALSE AND Retail_Store__c = :storeId
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}