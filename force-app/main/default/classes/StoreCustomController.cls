public without sharing class StoreCustomController {
  public final Retail_Store__c currentRetailStore { get; set; }
  public String name { get; set; }
  public String buzzId { get; set; }
  public String city { get; set; }
  public String country { get; set; }

  /**
   * @description - constructor for VF Controller
   * Specifies the store record being used by the page based on the id parameter.
   */
  public StoreCustomController() {
    Id idFormUrl = ApexPages.currentPage().getParameters().get('id');
    if (idFormUrl != null) {
      currentRetailStore = [
        SELECT Id, Name, Buzz_Id__c, City__c, Country__c
        FROM Retail_Store__c
        WHERE Id = :idFormUrl
      ];
      this.name = this.currentRetailStore.Name;
      this.buzzId = this.currentRetailStore.Buzz_Id__c;
      this.city = this.currentRetailStore.City__c;
      this.country = this.currentRetailStore.Country__c;
    } else {
      this.currentRetailStore = new Retail_Store__c();
    }
  }

  /**
   * @description - Custom save action to check a user's access before saving
   * @return - A reference to the store record detail page to be redirected to
   */
  public PageReference save() {
    //Check if the user has access to create and Update stores
    if (
      Schema.SObjectType.Retail_Store__c.isCreateable() &&
      Schema.SObjectType.Retail_Store__c.isUpdateable()
    ) {
      this.currentRetailStore.Name = this.name;
      this.currentRetailStore.Buzz_Id__c = this.buzzId;
      this.currentRetailStore.City__c = this.city;
      this.currentRetailStore.Country__c = this.country;

      Database.upsert(this.currentRetailStore);
      return new PageReference('/' + this.currentRetailStore.Id);
    }

    ApexPages.Message failureMessage = new ApexPages.Message(
      ApexPages.Severity.ERROR,
      'User does not have access to create or edit a Retail Store'
    );
    ApexPages.addMessage(failureMessage);
    return null;
  }
  /**
   * @description - Custom Cancel action
   * @return - A reference to the Retail store tab to be redirected to
   */

  public PageReference cancel() {
    return new PageReference('/lightning/o/Retail_Store__c/home');
  }
}