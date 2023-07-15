public with sharing class Exceptions {
  public virtual class MyRetailStoreException extends Exception {
  }

  public class RetailException extends MyRetailStoreException {
  }

  /**
   * @description - Method to create a Retail Store
   * @param storeName Name of the Retail Store to create
   * @param throwException Boolean specifying whether or not to throw an Exception
   **/
  public static void createRetailStore(
    String storeName,
    Boolean throwException
  ) {
    Retail_Store__c store = new Retail_Store__c(
      Name = storeName,
      City__c = 'Rourkela',
      Buzz_Id__c = '1247T'
    );
    try {
      if (throwException) {
        throw new RetailException('A jubilant retail error message');
      }
      insert store;
    } catch (DMLException de) {
      System.debug(
        'I caught a DML exception with message:- ' +
          de.getMessage() +
          ' caused by ' +
          de.getStackTraceString()
      );
    } catch (MyRetailStoreException e) {
      System.debug(
        'I caught another Exception:- ' +
          e.getTypeName() +
          ' with message ' +
          e.getMessage()
      );
    }
  }
}
