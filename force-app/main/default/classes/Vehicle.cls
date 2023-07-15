public with sharing class Vehicle {
  public virtual class VehicleException extends Exception {
  }
  public class AgeException extends VehicleException {
  }

  public static void checkDriver(Integer age) {
    try {
      if (age < 18) {
        throw new AgeException('Underage Driving');
      }
    } catch (VehicleException vExp) {
      System.debug(vExp.getMessage());
    }
  }
}