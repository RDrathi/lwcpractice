public with sharing class StoreSupplyOrderTriggerHandler {
  @TestVisible
  private static Map<String, Object> flowVariableMap = new Map<String, Object>();
  /**
   * @description - Finds suppliers on new Orders and sends them an email
   * @param newOrders - List of newly created store supply order records
   */

  public static void handleAfterInsert(List<Store_Supply_Order__c> newOrders) {
    Set<Id> supplierIds = new Set<Id>();
    for (Store_Supply_Order__c storeOrder : newOrders) {
      supplierIds.add(storeOrder.Supplier__c);
    }

    //Get the suppliers of these Ordears
    List<Account> supplierList = [
      SELECT Name, Primary_Email_Contact__c
      FROM Account
      WHERE Id IN :supplierIds
    ];
    sendEmails(supplierList);
  }

  /**
   * @descrption - Calls a flow to email the suppliers
   * @param suppliers - List of Supplier accounts to email
   */
  private static void sendEmails(List<Account> suppliers) {
    flowVariableMap.put('supplierList', suppliers);
    Flow.Interview.New_Order_Email_to_Supplier sendEmailFlow = new Flow.Interview.New_Order_Email_to_Supplier(
      flowVariableMap
    );
    sendEmailFlow.start();
  }
}
