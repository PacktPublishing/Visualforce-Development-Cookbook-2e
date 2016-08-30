/*******************************************************************
 * Visualforce Development Cookbook Recipe 10_7
 *
 * Custom controller for the "Loging messages in a Visualforce 
 * page" recipe.  Captures log message to a property surfaced on the
 * page if the URL parameter 'debug' is set to true
 *******************************************************************/
public with sharing class DebugInPageController 
{
    public transient List<Opportunity> top10Opps;
    public transient List<String> msgs;
    public Boolean debug {get; set;}
    
    public DebugInPageController()
    {
    	String debugStr=ApexPages.currentPage().getParameters().get('debug');
    	if (!String.isEmpty(debugStr))
    	{
    		debug=Boolean.valueOf(debugStr);
    	}
    	else
    	{
    		debug=false;
    	}
    	
    	if (debug)
    	{
    		msgs=new List<String>();
    		logMessage('In constructor');
    	}
    }
    
    private void logMessage(String msg)
    {
    	if (debug)
    	{
    		msgs.add(System.now() + ' : ' + msg);
    	}
    }
    
    public List<String> getMsgs()
    {
    	return msgs;
    }
    
    public List<Opportunity> getTop10Opps()
    {
    	logMessage('In getTop10Opps');
    	if (null==top10Opps)
    	{
    		logMessage('Opportunities have not yet been cached - querying from database');
    		top10Opps=[select id, Name, Amount, StageName from Opportunity order by Amount desc limit 10];
    		logMessage('Retrieved ' + top10Opps.size() + ' opportunities');
    	}
    	else
    	{
    		logMessage('Opportunities are already cached');
    	}
    	
    	logMessage('SOQL queries after getTop10Opps - used ' + Limits.getQueries() + ' out of ' + Limits.getLimitQueries());
    	
    	return top10Opps;
    }
}