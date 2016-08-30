/*******************************************************************
 * Visualforce Development Cookbook Recipe 6_7
 *
 * Controller extension for the "Embedding a Chart in a Record View 
 * Page" recipe. 
 * Manages a list of wrapper classes used to back a chart that 
 * contain the total number of tasks and activities for a month 
 * over the last year.  
 *******************************************************************/
public with sharing class ContactActivitiesChartExt 
{
	// list of month names
	private static List<String> months=new List<String>
	       {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
	       	'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
	       	  
	// the contact being managed by the standard controller
	private Contact cont;
	
	// constructor
	public ContactActivitiesChartExt(ApexPages.StandardController std)
	{
		cont=(Contact) std.getRecord();
	}
	
	// Getter to set up the data to be used to draw the chart
    public List<Data> getChartData() {
        Map<Integer, Data> dataByMonth = new Map<Integer, Data>();
        List<Data> chartData=new List<Data>();
        
        DateTime startDT=DateTime.newInstance(Date.today().addYears(-1).addMonths(1).toStartOfMonth(), Time.newInstance(0, 0, 0, 0));
        DateTime endDT=DateTime.newInstance(Date.today(), Time.newInstance(23, 59, 59, 999));
        
        Integer startMonth=startDT.date().month()-1;
        for (Integer idx=0; idx<12; idx++)
        {
        	Integer monthNo=Math.mod(startMonth+idx, 12);
        	Data theData=new Data(months.get(monthNo));
        	dataByMonth.put(monthNo, theData);
        	chartData.add(theData);
        }
        
        for (Event ev : [select id , EndDateTime
        				 from Event 
        				 where WhoId=:cont.id
        				 and EndDateTime>=:startDT
        				 and EndDateTime<=:endDT])
        {
			Data cand=dataByMonth.get(ev.EndDateTime.date().month()-1);
			cand.events++;
        }
        					
        for (Task ts : [select id, ActivityDate
        				from Task 
        				where WhoId=:cont.id
        				and ActivityDate>=:startDT.date()
        				and ActivityDate<=:endDT.date()])
        {
			Data cand=dataByMonth.get(ts.ActivityDate.month()-1);
			cand.tasks++;
        }
        					
		// Demonstration purposes only - create some random data for empty months
		// between 0 and 20        					
        for (Integer idx=0; idx<12; idx++)
        {
        	Data cand=dataByMonth.get(idx);
        	if (0==cand.events)
        	{
        		cand.events=(Math.random()*20).intValue();
        	}
        	if (0==cand.tasks)
        	{
        		cand.tasks=(Math.random()*20).intValue();
        	}
        }

        return chartData;
	}
	
    // Wrapper class
    public class Data 
    {
        public String name { get; set; }
        public Integer events { get; set; }
        public Integer tasks { get; set; }
        
        public Data(String name) 
        {
            this.name = name;
            this.events = 0;
            this.tasks = 0;
		} 
	}
}