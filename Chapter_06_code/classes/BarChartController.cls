/*******************************************************************
 * Visualforce Development Cookbook Recipe 6_1
 *
 * Custom controller for the "Creating a Bar Chart" recipe. 
 * Manages a list of wrapper classes used to back a chart that 
 * contain the total won opportunity value for a month over the
 * last year.  
 *******************************************************************/
public with sharing class BarChartController 
{
	// List of month names
	private static List<String> months=new List<String>
	       {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
	       	'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
	       	  
	// Getter to retrieve the list to draw the chart. 
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
        
        for (Opportunity opp : [select id, CloseDate, Amount 
        						from Opportunity 
		        				where IsClosed = true
		        				and IsWon = true
        						and CloseDate>=:startDT.date()
        						and CloseDate<=:endDT.date()])
        {
			Data cand=dataByMonth.get(opp.CloseDate.month()-1);
			cand.oppTotal+=opp.Amount;
        }

		// Demonstration purposes only - create some random data for empty months
		// between 0 and 750,000        					
        for (Integer idx=0; idx<12; idx++)
        {
        	Data cand=dataByMonth.get(idx);
        	if (0.0==cand.oppTotal)
        	{
        		cand.oppTotal=Math.random()*750000;
        	}
        }
        
        return chartData;
	}
	
    // Wrapper class
    public class Data 
    {
        public String name { get; set; }
        public Decimal oppTotal { get; set; }
        
        public Data(String name) 
        {
            this.name = name;
            this.oppTotal = 0.0;
		} 
	}
}