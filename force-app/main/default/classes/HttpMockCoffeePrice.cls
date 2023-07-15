/**
 * @author - Rathindra Dakua
 * @description - Mock class that will be fired when external callouts are made in a test context
 */
@isTest
global with sharing class HttpMockCoffeePrice implements HttpCalloutMock {
  Integer statusCode;
  /**
   * @description - Constructor to create a new instance of the mock class with a status code
   * @param statusCode - The status code of the mock external callout
   */
  public HttpMockCoffeePrice(Integer statusCodeReceived) {
    statusCode = statusCodeReceived;
  }

  /**
   * @description - Creates a mock response for a callout in a test context
   * @param request An HTTPRequest called from the code
   * @return HttpResponse that mocks what would be actually returned from an external system
   */
  global HttpResponse respond(HTTPRequest request) {
    System.debug('Mock Class has been fired');
    HttpResponse response = new HttpResponse();
    response.setStatusCode(statusCode);
    if (response.getStatusCode() == 200) {
      response.setStatus('OK');
      response.setBody(MockCoffeePriceResponse.coffeeApiResponse);
    }
    return response;
  }
}