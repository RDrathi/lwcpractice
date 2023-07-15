public class Diploma implements Document {
  public String title = 'New Document Test';
  public Diploma() {
    if (String.isBlank(title)) {
      System.debug('No Title');
    } else {
      System.debug(title);
    }
  }

  public String getTitle(String newPrefix) {
    return newPrefix + ' ' + title;
  }

  public void setDate() {
    System.debug('Do Something here');
  }
}
