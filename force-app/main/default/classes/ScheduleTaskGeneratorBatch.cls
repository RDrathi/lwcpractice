/**
 * @author - Rathindra Dakua
 * @description - Schedulable job for calling the TaskGeneratorBatch class
 * Use the below CronExpression to run the job daily at 12:30 PM
 * String sch = '0 30 12 * * ?';
 * Values represent '[seconds] [minutes] [hours] [day_of_month] [month] [day_of_week]'
 */
public with sharing class ScheduleTaskGeneratorBatch implements Schedulable {
  public final Integer openCaseThreshold;

  /**
   * @description - constructor to specify a threshold for the batch class
   * @param threshold - The number of days in the past to check for open cases
   */
  public ScheduleTaskGeneratorBatch(Integer threshold) {
    System.debug('In Scheduler Constructor');
    openCaseThreshold = threshold;
  }

  /**
   * @description - method to execute the batch class
   * @param sc - Schedulable context that's part of the interface implementation
   */
  public void execute(SchedulableContext sc) {
    System.debug(
      'Executing Schedulable job with threshold of ' +
        openCaseThreshold +
        ' days.'
    );
    TaskGeneratorBatch tcb = new TaskGeneratorBatch(openCaseThreshold, false);
    Database.executeBatch(tcb, 5);
  }
}