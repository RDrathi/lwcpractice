public with sharing class RetailStoreTriggerHandler {
  @testVisible
  private static Boolean platformEventsFailed = false;

  public static void handleAfterInsertUpdate(
    List<Retail_Store__c> newStores,
    Map<Id, Retail_Store__c> oldStoreMap
  ) {
    List<Case> casesToInsert = new List<Case>();
    List<Feedback_Rating_Event__e> ticketUpdateEvents = new List<Feedback_Rating_Event__e>();
    for (Retail_Store__c store : newStores) {
      /* Get the previous values of the store,
       will be null for newly created stores using safe navigation operator */
      Retail_Store__c oldStore = oldStoreMap?.get(store.Id); //Evaluates to oldStore = Null? Null : oldStoreMap.get(store.Id);
      if (isStoreWithBadSatisfaction(store, oldStore)) {
        Case newCase = new Case();
        newCase.Subject = 'Poor Customer Satisfaction';
        newCase.Status = 'New';
        newCase.Priority = 'High';
        newCase.Description =
          'The store\'s customer feedback rating dropped to ' +
          store.Customer_Feedback__c;
        newCase.Retail_Store__c = store.Id;
        newCase.OwnerId = store.OwnerId;
        casesToInsert.add(newCase);
        ticketUpdateEvents.add(
          new Feedback_Rating_Event__e(Store_Id__c = store.Id)
        );
      }
    }
    // Insert all new cases
    Database.insert(casesToInsert, false);
    //Code to publish Feedback Rating Event
    List<Database.SaveResult> results = EventBus.publish(ticketUpdateEvents); //Publishing for LWC to listen so that it can be used to show toast message
    for (Database.SaveResult result : results) {
      if (!result.isSuccess()) {
        platformEventsFailed = true;
      }
    }
  }

  private static Boolean isStoreWithBadSatisfaction(
    Retail_Store__c newStore,
    Retail_Store__c oldStore
  ) {
    if (oldStore != null) {
      return ((newStore.Customer_Feedback__c == 'Poor' ||
      newStore.Customer_Feedback__c == 'Moderate') &&
      (oldStore.Customer_Feedback__c == 'Good' ||
      oldStore.Customer_Feedback__c == 'Excellent'));
    } else {
      return (newStore.Customer_Feedback__c == 'Poor' ||
      newStore.Customer_Feedback__c == 'Moderate');
    }
  }

  /**
   * @description - Gets coffee prices for types of Coffee sold at given store
   * @param coffee Types of Coffee to get prices for
   * @return Custom Structure containing prices for coffee to display on the Flow
   */
  @InvocableMethod(
    label='Update Coffee Prices'
    description='Gets the coffee prices for Coffee sold at the stores'
    category='Retail Store'
  )
  public static List<CoffeePrice> updateCoffeeprices(List<String> coffeeTypes) {
    String formattedPrices = '';

    //Make the external Mock callout to get the coffee prices
    HttpRequest request = constructHttpRequest(coffeeTypes[0]);
    HttpResponse response = getResponseFromApi(request);

    //Parse the external response
    coffeeApiResponse coffeeApiResult = (coffeeApiResponse) JSON.deserialize(
      response.getBody(),
      coffeeApiResponse.class
    );

    //Construct the prices in a readable format
    for (Rate rate : coffeeApiResult.rates) {
      formattedPrices +=
        rate.coffeeName +
        ' price: $' +
        rate.price +
        ' ' +
        coffeeApiResult.unit +
        '\n';
    }
    System.debug('Formatted Prices is ' + formattedPrices);

    //Construct Object to Send back to Flow
    CoffeePrice coffeePrice = new CoffeePrice();
    coffeePrice.prices = formattedPrices;
    return new List<CoffeePrice>{ coffeePrice };
  }

  public class CoffeePrice {
    @InvocableVariable(
      label='Prices for Flow'
      description='Prices received from API'
      required=true
    )
    public String prices;  //This is for output on the Flow
  }

  private static HttpRequest constructHttpRequest(String typesToSearch) {
    HttpRequest reqToReturn = new HttpRequest();
    //Made up End point
    System.debug('Searching for Types: ' + typesToSearch);
    reqToReturn.setEndpoint(
      'http://www.currentcoffeeprices.com/wiredBrainCoffee/types?' +
      typesToSearch
    );
    reqToReturn.setMethod('GET');

    //Specify the required username, Password and Header information
    String username = 'rathindraAndCo';
    String password = 'Rathi&85$Yo';

    //Encrypted Authorization Encryption
    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
    reqToReturn.setHeader('Authorization', authHeader);

    return reqToReturn;
  }

  private static HttpResponse getResponseFromApi(HttpRequest requestParam) {
    Http httpObj = new Http();
    //Call a mock response here instead of an actual one
    //HttpResponse responseBody = httpObj.send(requestParam);
    HttpResponse responseToReturn = new HttpResponse();
    responseToReturn.setBody(MockCoffeePriceResponse.coffeeApiResponse);
    responseToReturn.setStatus('OK');
    responseToReturn.setStatusCode(200);

    return responseToReturn;
  }

  public class coffeeApiResponse {
    public String base;
    public Date currentDate;
    public List<Rate> rates;
    public String unit;
  }

  public class Rate {
    public String coffeeName;
    public Decimal price;
  }
}
