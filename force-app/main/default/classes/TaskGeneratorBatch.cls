/**
 * @description - Batch class to create tasks for open cases that have been open for more than certain period of time
 */
public with sharing class TaskGeneratorBatch implements Database.Batchable<sObject>, Database.Stateful {
  public final String query;
  public final Integer threshold;
  public final Boolean throwNewException;
  public Integer totalTasksCreated = 0; //The total number of tasks created accross all batches. Possible because of Database.Stateful

  public class TaskBatchException extends Exception {
  }

  /**
   * @description - Constructor to specify a threshold and whether an exception should be thrown
   * @param thresholdDays - The number of Days in the past to check for open cases
   * @param throwException - Boolean specifying whether or not an exception should be thrown
   */
  public TaskGeneratorBatch(Integer thresholdDays, Boolean throwException) {
    threshold = thresholdDays;
    throwNewException = throwException; //Not a best practice to throw an error by choice/manually
    query =
      'SELECT Id, CaseNumber, Subject, CreatedDate, Priority, Status, OwnerId FROM Case WHERE IsClosed = false AND CreatedDate < LAST_N_DAYS:' +
      thresholdDays;
    System.debug('Inside Constructor. Here is the query' + query);
  }

  /**
   * @description - start() method to run the query
   * @param bc - Batachable context that's part of the interface
   */
  public Database.QueryLocator start(Database.BatchableContext bc) {
    System.debug('In the start method of the TaskGeneratorBatch class');
    return Database.getQueryLocator(query);
  }

  /**
   * @description - Execute method to create tasks
   * @param bc - Batachable context that's part of the interface
   * @param scopeRecs - List of open cases that were returned as result of the query from start() method
   */
  public void execute(Database.BatchableContext bc, List<sObject> scopeRecs) {
    try {
      if (throwNewException) {
        throw new TaskBatchException('This is task exception');
      }
      List<Case> openCases = (list<Case>) scopeRecs;
      List<Task> tasksToGenerate = new List<Task>();
      for (Case openCase : openCases) {
        System.debug('Open case is ' + openCase);
        Task newTask = createNewTask(openCase); //Method on line 70
        tasksToGenerate.add(newTask);
      }

      System.debug('Tasks to insert size' + tasksToGenerate.size());
      totalTasksCreated += tasksToGenerate.size();
      System.debug('totalTasksCreated updated to ' + totalTasksCreated);
      Database.insert(tasksToGenerate, false);
    } catch (Exception exp) {
      System.debug(exp.getMessage());
    }
  }
  /**
   * @description - finish() method to summarize all executions
   * @param bc - Batchable context that's part of the interface
   */
  public void finish(Database.BatchableContext bc) {
    System.debug(
      'In finish method having created ' + totalTasksCreated + ' tasks '
    );
  }

  /**
   * @description - Method to create a Task based on the open case
   * @param openCase - the open case which will be used to create a Task
   * @return - a task for that open case
   */
  private Task createNewTask(Case openCase) {
    System.debug(
      'Creating new Task for Case Number -' +
        openCase.CaseNumber +
        ' ; ' +
        openCase.Subject
    );
    Task newTask = new Task(
      OwnerId = openCase.OwnerId,
      WhatId = openCase.Id,
      Status = 'In Progress',
      Subject = 'Aged Ticket',
      Priority = 'High',
      description = 'This case has been open for more than ' +
        threshold +
        ' days. Please take necessary action to close it ASAP'
    );
    return newTask;
  }
}