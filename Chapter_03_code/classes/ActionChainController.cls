/*******************************************************************
 * Visualforce Development Cookbook Recipe 3_11
 * 
 * Custom controller for the "Action Chaining" recipe.  Moves an
 * opportunity through stages based on requests from the page.
 *******************************************************************/
public with sharing class ActionChainController 
{
	// the opportunity being managed
	public Opportunity opp {get; set;}
	
	// the current opportunity stage
	public String oppStage {get; set;}
	
	// constructor
    public ActionChainController()
    {
    	opp=new Opportunity();
    }
    
	// method to set the opportunity to the qualification stage
	public PageReference qualification()
	{
		opp.StageName='Qualification';
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Updated stagename to Qualification'));
		update opp;
		oppStage='Qualification';
		
		return null;
	}
	
	// method to set the opportunity to the needs analysis stage
	public void needsAnalysis()
	{
		opp.StageName='Needs Analysis';
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Updated stagename to Needs Analysis'));
		update opp;
	}
	
	// method to set the opportunity to the value proposition stage
	public void proposition()
	{
		opp.StageName='Value Proposition';
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Updated stagename to Value Proposition'));
		update opp;
	}
	
	// method to save the opportunity
	public void save()
	{
		upsert opp;
	}

}