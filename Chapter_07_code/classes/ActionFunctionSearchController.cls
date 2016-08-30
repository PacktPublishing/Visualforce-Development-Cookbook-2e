/*******************************************************************
 * Visualforce Development Cookbook Recipe 7_2
 *
 * Custom controller for the "Avoiding Race Conditions" recipe.
 * Executes a search for accounts matching user-entered text 
 *******************************************************************/
public with sharing class ActionFunctionSearchController 
{
	// the search results
	public List<Account> results {get; set;}
	
	// the search text entered by the user
	public String searchStr {get; set;}
	
	// constructor
	public ActionFunctionSearchController()
	{
		results=new List<Account>();
	}
	
	// executes the search
	public PageReference doSearch()
	{
		String wcStr='%'+searchStr+'%';
		results=[select id, Name, Type, Industry from Account where Name like :wcStr];
		
		return null;
	}
	
	// action method to clear down the list of results
	public PageReference clearResults()
	{
		results.clear();
		
		return null;
	}
	
	// getter to indicate if there are results available
	public Boolean getResultsAvailable()
	{
		return (results.size()>0);
	}
}