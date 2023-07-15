//Custom Controller to be used for a store supply order records
public with sharing class StoreSupplyOrderController {
  @AuraEnabled(cacheable=true)
  public static List<Store_Supply_Order__c> getStoreSupplyOrders(Id storeId) {
    try {
      return [
        SELECT
          Id,
          Name,
          Order_Amount__c,
          Order_Status__c,
          Product__c,
          Quantity__c
        FROM Store_Supply_Order__c
        WHERE Retail_Store__c = :storeId
      ];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
