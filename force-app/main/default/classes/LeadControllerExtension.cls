public with sharing class LeadControllerExtension {
  public final Lead currentLead { get; set; }
  private final String pageType = 'Controller Extension';
  public Boolean greetingToggle { get; set; }
  public Integer sampleCount { get; set; }

  public LeadControllerExtension(ApexPages.StandardController leadController) {
    currentLead = (Lead) leadController.getRecord();
    greetingToggle = true;
    sampleCount = 0;
  }

  public String getPageType() {
    return pageType;
  }

  public List<Lead> getLeadRecs() {
    return [
      SELECT FirstName, LastName, Email, Company, LeadSource, Rating
      FROM Lead
      WHERE Status IN ('Open - Not Contacted', 'Working - Contacted')
      ORDER BY FirstName
    ];
  }

  public void validateLeadInfo() {
    Integer dupeContactsCount = [
      SELECT COUNT()
      FROM Contact
      WHERE
        FirstName = :this.currentLead.FirstName
        AND LastName = :this.currentLead.LastName
        AND Account.Name = :this.currentLead.Company
        AND Email = :this.currentLead.Email
    ];
    if (dupeContactsCount > 0) {
      // Send an error message to the page
      ApexPages.Message failureMessage = new ApexPages.Message(
        ApexPages.Severity.WARNING,
        'Duplicate contact found'
      );
      ApexPages.addMessage(failureMessage);
    }
  }

  public void toggleGreeting() {
    greetingToggle = !greetingToggle;
  }

  public PageReference incrementSampleCounter() {
    sampleCount++;
    return null;
  }
}
