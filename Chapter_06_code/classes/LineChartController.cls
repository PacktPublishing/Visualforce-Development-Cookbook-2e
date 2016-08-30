/*******************************************************************
 * Visualforce Development Cookbook Recipe 6_2
 *
 * Custom controller for the "Creating a Line Chart" recipe. 
 * Manages a list of wrapper classes used to back a chart that 
 * contain the total number of closed cases per month over the
 * last year.  
 *******************************************************************/
public with sharing class LineChartController 
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
        
        for (Case cs : [select id, ClosedDate 
        						from Case 
		        				where IsClosed = true
        						and ClosedDate>=:startDT
        						and ClosedDate<=:endDT])
        {
			Data cand=dataByMonth.get(cs.ClosedDate.date().month()-1);
			cand.recordCount++;
        }
        					
		// Demonstration purposes only - create some random data for empty months
		// between 0 and 20        					
        for (Integer idx=0; idx<12; idx++)
        {
        	Data cand=dataByMonth.get(idx);
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
        public Decimal recordCount { get; set; }
        
        public Data(String name) 
        {
            this.name = name;
            this.recordCount = 0;
		} 
	}
}