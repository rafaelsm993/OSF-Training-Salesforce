global with sharing class scheduleScript implements Schedulable{
    global void execute(SchedulableContext ctx){
        // Daily job
        String dailyJobName = 'Daily Job';
        String dailyCron = '0 0 10 * * ? *';
        exercise03BatchClass dailyBatch = new exercise03BatchClass();
        System.schedule(dailyJobName, dailyCron, dailyBatch);

        // Weekly job
        String weeklyJobName = 'Weekly Job';
        String weeklyCron = '0 0 13 ? * FRI *';
        exercise03BatchClass weeklyBatch = new exercise03BatchClass();
        System.schedule(weeklyJobName, weeklyCron, weeklyBatch);

        // Monthly job
        String monthlyJobName = 'Monthly Job';
        String monthlyCron = '0 0 18 ? * 6L';
        exercise03BatchClass monthlyBatch = new exercise03BatchClass();
        System.schedule(monthlyJobName, monthlyCron, monthlyBatch);
    }
}
