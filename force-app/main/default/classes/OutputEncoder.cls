public with sharing class OutputEncoder {
  public final String encodedOutput { get; set; }
  public OutputEncoder() {
    String urlParam = ApexPages.currentPage().getParameters().get('input');
    if (String.isNotBlank(urlParam)) {
      encodedOutput = urlParam.escapeHtml4();
    }
  }
}