/*******************************************************************
 * Visualforce Development Cookbook Recipe 6_5
 *
 * Custom controller for the "Creating a Stacked Bar Chart" recipe. 
 * Manages a list of wrapper classes used to back a chart that 
 * contain the total won and lost opportunity value for a month over
 * the last year.  
 *******************************************************************/
public with sharing class StackedBarChartController 
{
	// list of month names
	private static List<String> months=new List<String>
	       {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
	       	'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
	       	  
	// Getter to set up the data to be used to draw the chart
    public List<Data> getChartData() 
    {
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
        
        for (Opportunity opp : [select id, CloseDate, Amount, isWon 
        						from Opportunity 
		        				where IsClosed = true
        						and CloseDate>=:startDT.date()
        						and CloseDate<=:endDT.date()])
        {
			Data cand=dataByMonth.get(opp.CloseDate.month()-1);
			if (opp.isWon)
			{
				cand.wonTotal+=opp.Amount;
			}
			else
			{
				cand.lostTotal+=opp.Amount;
			}
        }
        					
		// Demonstration purposes only - create some random data for empty months
		// between 0 and 750,000        					
        for (Integer idx=0; idx<12; idx++)
        {
        	Data cand=dataByMonth.get(idx);
        	if (0.0==cand.wonTotal)
        	{
        		cand.wonTotal=(Math.random()*750000).intValue();
        	}
        	
        	if (0.0==cand.lostTotal)
        	{
        		cand.lostTotal=(Math.random()*750000).intValue();
        	}
        }

        return chartData;
	}
	
    // Wrapper class
    public class Data 
    {
        public String name { get; set; }
        public Decimal wonTotal { get; set; }
        public Decimal lostTotal { get; set; }
        
        public Data(String name) 
        {
            this.name = name;
            this.wonTotal = 0.0;
            this.lostTotal = 0.0;
		} 
	}
}