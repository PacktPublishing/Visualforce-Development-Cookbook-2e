/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_6
 *
 * Custom controller for the "Visualforce Report" recipe.
 * Retrieves the data to back the report based on user selections.
 *******************************************************************/
public with sharing class CaseReportController 
{
	// list of cases and the running totals for status and origin
	// at the point in time the case was processed
	public List<CaseAndTotals> casesAndTotals {get; set;}
	
	// timeframe the user has selected for the report
    public String timeframe {get; set;}
    
    // carrier for the start date of the timeframe
    public Task carrier1 {get; set;}
    
    // carrier for the end date of the timeframe
    public Task carrier2 {get; set;}
    
    // indicator that the report has been run
    public Boolean run {get; set;}
    
    // the status criteria for the records
    public String statusCriteria {get; set;}
    
    // the number of records in a particular status
    public Map<String, Integer> statusTotals {get; set;}
    
    // the number of records from a particular origin
    public Map<String, Integer> originTotals {get; set;}
    
    // constructor
	public CaseReportController()
	{
        carrier1=new Task();
        carrier2=new Task();
        casesAndTotals=new List<CaseAndTotals>();
    	statusTotals=new Map<String, Integer>();
    	originTotals=new Map<String, Integer>();
    	run=false;
	}
	
	// action method to execute the report for a particular time literal
    public PageReference runTimeframeQuery()
    {
    	run=true;
    	String queryStr='select id, CaseNumber, CreatedDate, Status, Origin from Case where CreatedDate=' + timeFrame + 
    				' order by CreatedDate asc';
    	
    	processCases(Database.query(queryStr));
        return null;
    }
    
	// action method to execute the report given a start/end date
    public PageReference runCustomQuery()
    {
    	run=true;
    	Date startDate=carrier1.ActivityDate;
    	Date endDate=carrier2.ActivityDate;
    	String queryStr='select id, CaseNumber, CreatedDate, Status, Origin from Case where CreatedDate>=:startDate ' +
    							' and CreatedDate<=:endDate ';
    	if (statusCriteria!='All')
    	{
    		if ('Open'==statusCriteria)
    		{
    			queryStr+='and Status!=\'Closed\'';
    		}
    		else if ('Closed'==StatusCriteria)
    		{
    			queryStr+='and Status=\'Closed\'';
    		}
    	}
    	
    	queryStr+=' order by CreatedDate asc';
    	
    	processCases(Database.query(queryStr));
    	
        return null;
    }
    
    // processes the cases and calculates the totals
    private void processCases(List<Case> cases)
    {
    	casesAndTotals.clear();
    	statusTotals.clear();
    	originTotals.clear();
    	for (Case cs : cases)
    	{
    		casesAndTotals.add(new CaseAndTotals(cs, getStatusTotal(cs), getOriginTotal(cs)));
    	}
    }
    
    // gets the number of cases with the same status as the supplied case
    // and updates the total
    private Integer getStatusTotal(Case cs)
    {
    	String status=cs.Status;
    	Integer statusTotal=statusTotals.get(status);
    	if (null==statusTotal)
    	{
    		statusTotal=0;
    	}
    	
    	statusTotals.put(status, ++statusTotal);
    	
    	return statusTotal;
    }
    
    // gets the number of cases with the same origin as the supplied case
    // and updates the total
    private Integer getOriginTotal(Case cs)
    {
    	String origin=cs.Origin;
    	Integer originTotal=originTotals.get(origin);
    	if (null==originTotal)
    	{
    		originTotal=0;
    	}
    	
    	originTotals.put(origin, ++originTotal);
    	
    	return originTotal;
    }
    
    // method to generate the timeframe literal options
    public List<SelectOption> getTimeframeOptions()
    {
        List<SelectOption> options=new List<SelectOption>();
        
        options.add(new SelectOption('THIS_MONTH', 'Opened This Month'));
        options.add(new SelectOption('LAST_MONTH', 'Opened Last Month'));
        options.add(new SelectOption('THIS_YEAR', 'Opened This Year'));
        
        return options;
    }
        
    // method to generate the status options
    public List<SelectOption> getStatusOptions()
    {
        List<SelectOption> options=new List<SelectOption>();
        
        options.add(new SelectOption('All', 'All'));
        options.add(new SelectOption('Open', 'Open'));
        options.add(new SelectOption('Closed', 'Closed'));
        
        return options;
    }    
    
}