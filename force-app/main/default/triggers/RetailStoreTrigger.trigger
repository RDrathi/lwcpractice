trigger RetailStoreTrigger on Retail_Store__c(after insert, after update) {
  if (Trigger.isAfter) {
    RetailStoreTriggerHandler.handleAfterInsertUpdate(
      Trigger.new,
      Trigger.oldMap
    );
  }
}
