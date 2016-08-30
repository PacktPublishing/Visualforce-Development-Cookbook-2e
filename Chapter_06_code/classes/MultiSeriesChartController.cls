/*******************************************************************
 * Visualforce Development Cookbook Recipe 6_4
 *
 * Custom controller for the "Adding Multiple Series" recipe. 
 * Manages a list of wrapper classes used to back a chart that 
 * contain the total number of won and lost opportunities per month 
 * over the last year.  
 *******************************************************************/
public with sharing class MultiSeriesChartController
{
	// list of month names
	private static List<String> months=new List<String>
	       {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
	       	'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
	       	  
	// Getter to set up the data to be used to draw the chart
    public List<Data> getChartData() {
        Map<Integer, Data> dataByMonth = new Map<Integer, Data>();
        List<Data> chartData=new List<Data>();
        
        DateTime startDT=DateTime.newInstance(Date.today().addYears(-1).toStartOfMonth(), Time.newInstance(0, 0, 0, 0));
        DateTime endDT=DateTime.newInstance(Date.today(), Time.newInstance(23, 59, 59, 999));
        
        Integer startMonth=startDT.date().month()-1;
        for (Integer idx=0; idx<12; idx++)
        {
        	Integer monthNo=Math.mod(startMonth+idx, 12);
        	Data theData=new Data(months.get(monthNo));
        	dataByMonth.put(monthNo, theData);
        	chartData.add(theData);
        }
        
        for (Opportunity opp : [select id, CloseDate, IsWon 
        						from Opportunity 
		        				where IsClosed = true
        						and CloseDate>=:startDT.date()
        						and CloseDate<=:endDT.date()])
        {
			Data cand=dataByMonth.get(opp.CloseDate.month()-1);
			if (opp.IsWon)
			{
				cand.wonCount++;
			}
			else
			{
				cand.lostCount++;
			}
        }
        					
		// Demonstration purposes only - create some random data for empty months
		// between 0 and 50        					
        for (Integer idx=0; idx<12; idx++)
        {
        	Data cand=dataByMonth.get(idx);
        	if (0.0==cand.wonCount)
        	{
        		cand.wonCount=(Math.random()*50).intValue();
        	}
        	
        	if (0.0==cand.lostCount)
        	{
        		cand.lostCount=(Math.random()*50).intValue();
        	}
        }

        return chartData;
	}
	
    // Wrapper class
    public class Data 
    {
        public String name { get; set; }
        public Integer wonCount { get; set; }
        public Integer lostCount { get; set; }
        
        public Data(String name) 
        {
            this.name = name;
            this.wonCount = 0;
            this.lostCount = 0;
		} 
	}
}