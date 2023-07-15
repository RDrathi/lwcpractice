public with sharing class ContactController {
  @AuraEnabled
  public static List<Contact> getContacts() {
    try {
      List<Contact> conList = [
        SELECT Id, Name, Phone
        FROM Contact
        WITH USER_MODE
        LIMIT 50
      ];
      return conList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static List<Contact> getContactsByName(String searchKey) {
    try {
      String conName = '%' + searchKey + '%';
      List<Contact> conListbyKey = [
        SELECT Id, Name, Phone
        FROM Contact
        WHERE Name LIKE :conName
        LIMIT 50
      ];
      return conListbyKey;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static Contact getContactsById(String contactId) {
    try {
      Contact conListById = [
        SELECT id, Name, Phone, Title, MobilePhone, Account.Name
        FROM Contact
        WHERE Id = :contactId
      ];
      return conListById;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}