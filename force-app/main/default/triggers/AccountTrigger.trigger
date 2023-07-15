trigger AccountTrigger on Account(before insert, after update) {
  if (Trigger.isBefore && Trigger.isInsert) {
    for (Account accRec : Trigger.new) {
      //Set Service Level Agreement based on Quality Rating
      if (accRec.Quality_Rating__c == 100) {
        accRec.Service_Level_Agreement__c = 'Platinum';
      } else if (accRec.Quality_Rating__c > 80) {
        accRec.Service_Level_Agreement__c = 'Gold';
      } else if (accRec.Quality_Rating__c > 50) {
        accRec.Service_Level_Agreement__c = 'Silver';
      } else if (accRec.Quality_Rating__c > 0) {
        accRec.Service_Level_Agreement__c = 'Bronze';
      } else if (accRec.Quality_Rating__c == 0) {
        accRec.Service_Level_Agreement__c = 'Blue';
      } else {
        accRec.Service_Level_Agreement__c = null;
      }
      System.debug('Set SLA to ' + accRec.Service_Level_Agreement__c);
    }
  } else if (Trigger.isAfter && Trigger.isUpdate) {
    //SOQL needed to get records since records can't be directly updated in an after save Trigger
    List<Account> newAccList = [
      SELECT Name, Quality_Rating__c, Service_Level_Agreement__c
      FROM Account
      WHERE Id IN :Trigger.new
    ];
    List<Account> accountsToUpdate = new List<Account>();
    for (Account accRec : newAccList) {
      if (
        accRec.Quality_Rating__c == 100 &&
        Trigger.oldMap.get(accRec.Id).Quality_Rating__c != 100
      ) {
        accRec.Service_Level_Agreement__c = 'Platinum';
        accountsToUpdate.add(accRec);
        System.debug('Setting Account SLA for ' + accRec.Name + ' to Platinum');
      }
    }
    Database.update(accountsToUpdate, false);
  }
}
