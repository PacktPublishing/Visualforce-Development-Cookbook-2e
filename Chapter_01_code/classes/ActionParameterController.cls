/*******************************************************************
 * Visualforce Development Cookbook Recipe 1_5
 * 
 * Custom controller for the "Passing Parameters to Action Methods" 
 * recipe.
 * Updates a selected opportunity to closed won based on a parameter
 * passed to the action method.
 *
 *******************************************************************/
public with sharing class ActionParameterController 
{
	// the id of the opportunity to close - this is sent from the page
	// as a parameter to the winOpp action method
    public Id oppIdToWin {get; set;}
    
    // constructor - retrieves the first 50 opportunities
    public List<Opportunity> getOpps()
    {
       return [select id, Name, StageName, CloseDate, Amount from Opportunity limit 50];
    }
    
    // action method that updates the selected opportunity to closed won
    public PageReference winOpp()
    {
       Opportunity opp=new Opportunity(Id=oppIdToWin,
                                       StageName='Closed Won');
                                       
       update opp;
       
       return null;
    }
}