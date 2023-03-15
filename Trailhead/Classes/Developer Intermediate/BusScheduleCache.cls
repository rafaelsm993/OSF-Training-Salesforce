public with sharing class BusScheduleCache {
    private Cache.OrgPartition part;
    public BusScheduleCache() {
        part = new Cache.OrgPartition('local.BusSchedule'); 
    }
    public void putSchedule(String busLine, Time[] schedule){
        part.put(busLine, schedule);
    }
    public Time[] getSchedule(String busLine){
        // Retrieve cache value from the partition
        List<Time> cachedValue = (List<Time>)part.get(busLine);
        
        // Check the cache value that the get() call returned.
        if (cachedValue == null) {
            List<Time> defaultSchedule = new List<Time>();
            defaultSchedule.add(Time.newInstance(8, 0, 0, 0));
            defaultSchedule.add(Time.newInstance(17, 0, 0, 0));
            
            return defaultSchedule;
        }
        
        else{
            return cachedValue;
        }
    }
}