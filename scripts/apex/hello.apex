ScheduleTaskGeneratorBatch stgb = new ScheduleTaskGeneratorBatch(30);
//CronExpression format - [seconds] [minutes] [hours] [day_of_month] [month] [day_of_week]
String sch = '0 50 23 * * ?';
String jobId = System.schedule('Task creation for Open Cases', sch, stgb);
System.debug('Job id of the Schedule is :-' + jobId);
