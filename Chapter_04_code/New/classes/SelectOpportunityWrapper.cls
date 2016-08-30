/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_7
 *
 * Wrapper class to encapsulate an opportunity and whether the user
 * has selected it.  Used in the "Wrapper Classes" recipe.
 *******************************************************************/
public with sharing class SelectOpportunityWrapper 
{
	// the opportunity
	public Opportunity opp {get; set;}
	
	// flag to indicate if the user has selected the opportunity
	public Boolean selected {get; set;}
	
	// constructor
	public SelectOpportunityWrapper()
	{
		selected=false;
	}
	
	// constructor
	public SelectOpportunityWrapper(Opportunity inOpp)
	{
		this();
		opp=inOpp;
	}
}