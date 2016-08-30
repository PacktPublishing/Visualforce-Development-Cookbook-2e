/*******************************************************************
 * Visualforce Development Cookbook Recipe 6_6
 *
 * Custom controller for the "Adding a Third Axis" recipe. 
 * Manages a list of wrapper classes used to back a chart that 
 * contain the total number of opportunities, and the won and lost 
 * value for a month over the last year.  
 *******************************************************************/
public with sharing class MultiAxisChartController 
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
        
        for (Opportunity opp : [select id, CloseDate, Amount, IsWon 
        						from Opportunity 
		        				where IsClosed = true
        						and CloseDate>=:startDT.date()
        						and CloseDate<=:endDT.date()])
        {
			Data cand=dataByMonth.get(opp.CloseDate.month()-1);
			if (opp.IsWon)
			{
				cand.wonAmount+=opp.Amount;
			}
			else
			{
				cand.lostAmount+=opp.Amount;
			}
			
			cand.recordCount++;
        }
        					
		// Demonstration purposes only - create some random data for empty months
        for (Integer idx=0; idx<12; idx++)
        {
        	Data cand=dataByMonth.get(idx);
        	if (0.0==cand.wonAmount)
        	{
        		cand.wonAmount=(Math.random()*750000).intValue();
        	}
        	
        	if (0.0==cand.lostAmount)
        	{
        		cand.lostAmount=(Math.random()*750000).intValue();
        	}
        	
        	if (0.0==cand.recordCount)
        	{
        		cand.recordCount=(Math.random()*20).intValue();
        	}
        }

        return chartData;
	}
	
    // Wrapper class
    public class Data 
    {
        public String name { get; set; }
        public Decimal lostAmount { get; set; }
        public Decimal wonAmount { get; set; }
        public Integer recordCount { get; set; }
        
        public Data(String name) 
        {
            this.name = name;
            this.recordCount = 0;
            this.wonAmount = 0;
            this.lostAmount = 0;
		} 
	}
}