public with sharing class LeadCustomController {
  public final Lead currentLead { get; set; }
  private final String pageType = 'Custom Controller';
  private List<Lead> leadRecs;

  public LeadCustomController() {
    Id idFromUrl = ApexPages.currentPage().getParameters().get('id');
    if (idFromUrl != null) {
      this.currentLead = [
        SELECT Id, FirstName, LastName, Email, Company, LeadSource, Rating
        FROM Lead
        WHERE Id = :idFromUrl
      ];
    } else {
      this.currentLead = new Lead();
    }
  }

  public List<Lead> getLeadRecs() {
    leadRecs = [
      SELECT Id, FirstName, LastName, Email, Company, LeadSource, Rating
      FROM Lead
      WHERE Status IN ('Open - Not Contacted', 'Working - Contacted')
      ORDER BY FirstName
    ];
    return leadRecs;
  }

  public String getPageType() {
    return this.pageType;
  }

  public PageReference saveAndNew() {
    if (validateInfo()) {
      upsert this.currentLead;
      return new PageReference('/' + this.currentLead.Id);
    }
    return null;
  }

  public PageReference cancel() {
    return new PageReference('/00Q/l');
  }

  private Boolean validateInfo() {
    Integer duplicateContactCount = [
      SELECT COUNT()
      FROM Contact
      WHERE
        FirstName = :this.currentLead.FirstName
        AND LastName = :this.currentLead.LastName
        AND Account.Name = :this.currentLead.Company
        AND Email = :this.currentLead.Email
    ];
    if (duplicateContactCount == 0) {
      return true;
    }
    ApexPages.Message failureMessage = new ApexPages.Message(
      ApexPages.Severity.ERROR,
      'Duplicate Contact has been Found'
    );
    ApexPages.addMessage(failureMessage);
    return false;
  }
}
