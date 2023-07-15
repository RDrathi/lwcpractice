public with sharing class simpleServerController {
  @AuraEnabled
  public static string serverEcho(String firstName) {
    try {
      return 'Hello from the Server, ' + firstName + '!';
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}