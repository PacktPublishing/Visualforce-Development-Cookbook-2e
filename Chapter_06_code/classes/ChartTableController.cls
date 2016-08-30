/*******************************************************************
 * Visualforce Development Cookbook Recipe 6_8
 *
 * Custom controller for the "Multiple Charts per Page" recipe. 
 * Manages a list of chart data, each of which encapsulates an account 
 * and a list of wrapper classes used to back a chart. Each wrapper 
 * class instance contains a month and the total won opportunity value
 * for that month over the past year.  
 *******************************************************************/
public with sharing class ChartTableController 
{
	// list of month names
	private static List<String> MONTH_NAMES=new List<String>
	       {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
	       	'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
	       
	// Getter to set up the data to back the table of charts
	public List<Row> getRows() 
	{
		Integer idx=0;
	
		List<Row> result=new List<Row>();
		Row row=null;
		for (Account acc : [select id, name from Account order by CreatedDate limit 9])
		{
			if (0==Math.mod(idx,3))
			{
				row=new Row();
				result.add(row);	
			}
			row.charts.add(getAccountChartData(idx++, acc));
		}
		
		return result;
	}
	
	// Getter to set up the data to be used to draw a chart for an account
    private ChartData getAccountChartData(Integer cdIdx, Account acc) 
    {
        Map<Integer, MonthData> dataByMonth = new Map<Integer, MonthData>();
        List<MonthData> monthList=new List<MonthData>();
        
        DateTime startDT=DateTime.newInstance(Date.today().addYears(-1).toStartOfMonth(), Time.newInstance(0, 0, 0, 0));
        DateTime endDT=DateTime.newInstance(Date.today(), Time.newInstance(23, 59, 59, 999));
        
        Integer startMonth=startDT.date().month()-1;
        for (Integer idx=0; idx<12; idx++)
        {
        	Integer monthNo=Math.mod(startMonth+idx, 12);
        	MonthData theData=new MonthData(MONTH_NAMES.get(monthNo));
        	dataByMonth.put(monthNo, theData);
        	monthList.add(theData);
        }
        
        for (Opportunity opp : [select id, CloseDate, Amount 
        						from Opportunity 
		        				where AccountId=:acc.Id 
		        				and IsClosed = true
		        				and IsWon = true
        						and CloseDate>=:startDT.date()
        						and CloseDate<=:endDT.date()])
        {
			MonthData cand=dataByMonth.get(opp.CloseDate.month()-1);
			cand.oppTotal+=opp.Amount;
        }
        					
		// Demonstration purposes only - create some random data for empty months
		// between 0 and 750,000        					
        for (Integer idx=0; idx<12; idx++)
        {
        	MonthData cand=dataByMonth.get(idx);
        	if (0.0==cand.oppTotal)
        	{
        		cand.oppTotal=(Math.random()*750000).intValue();
        	}
        }
        
        return new ChartData(cdIdx, acc.Name, monthList);
	}
	
    // Wrapper class for a month 
    public class MonthData 
    {
        public String name { get; set; }
        public Decimal oppTotal { get; set; }
        
        public MonthData(String name) 
        {
            this.name = name;
            this.oppTotal = 0.0;
		} 
	}
	
	// class containing the data for a chart
	public class ChartData
	{
		public Integer idx {get; set;}
		public String name {get; set;}
		public List<MonthData> months {get; set;}
		
		public ChartData(Integer inIdx, String inName, List<MonthData> inMonths)
		{
			idx=inIdx;
			name=inName;
			months=inMonths;
		}
	}
	
	// class for a row in the table
	public class Row
	{
		public List<ChartData> charts {get; set;}
		
		public Row()
		{
			charts=new List<ChartData>();
		}
	} 
}