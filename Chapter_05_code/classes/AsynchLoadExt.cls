/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_8
 *
 * Extension controller for the "Loading Records Asynchronously" 
 * recipe. 
 * Retrives the opportunities associated with an account on demand
 *******************************************************************/
public with sharing class AsynchLoadExt 
{
	// the standard account controller being extended
	private ApexPages.StandardController stdCtrl;
	
	// the opportunities associated with the account
	public List<Opportunity> opps {get; set;}
	
	// have the opportunities been loaded yet?
	public Boolean oppsNeeded {get; set;}
	
	// were any opportunites found to load?
	public Boolean oppsFound {get; set;}
	
	// constructor
	public AsynchLoadExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
		oppsNeeded=true;
		oppsFound=false;
	}
	
	// Action method to retrieve the opportunities associated with the 
	// account and update the loaded/found flags 
	public PageReference loadOpps()
	{
		opps=[select id, Name, Amount, CloseDate from Opportunity where AccountId=:stdCtrl.getId()];
		oppsNeeded=false;
		oppsFound=(opps.size()>0);
		
		return null;
	}
}