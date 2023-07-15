/*
//get All object info
System.debug('All Objects using Global Describe ' + Schema.getGlobalDescribe());

//Get info for Specific object
System.debug(
  'Retail Store Info ' +
  Schema.describeSObjects(new List<String>{ 'Retail_Store__c' })
);

//Get relationship for Specific Object
List<Schema.ChildRelationship> storeRelations = Retail_Store__c.SObjectType.getDescribe()
  .getChildRelationships();
for (Schema.ChildRelationship storeRelation : storeRelations) {
  System.debug('Relationship is with ' + storeRelation);
}
//Get fields for specific Object
System.debug(
  'Fields for Retail store is ' +
  Retail_Store__c.SObjectType.getDescribe().fields.getMap()
);

//Get Details for Specific Field
System.debug(
  'Retail Store Country Details ' + Retail_Store__c.Country__c.getDescribe()
);

//Get Labels and Values for Store Country
List<Schema.PicklistEntry> countryPickVals = Retail_Store__c.Country__c.getDescribe()
  .getPicklistValues();
for (Schema.PicklistEntry pickList : countryPickVals) {
  System.debug(
    'Label of the picklist is:- ' +
      pickList.getLabel() +
      ' and Value is ' +
      pickList.getValue()
  );
}

Integer pickedNumber = 7;
switch on pickedNumber {
  when 2, 4, 8, 6 {
    System.debug('You chose an even number');
  }
  when 1, 3, 5, 7, 9 {
    System.debug('You chose an odd number');
  }
  when else {
    System.debug('Please guess a valid number');
  }
}
*/

new Diploma();
