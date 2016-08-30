/*******************************************************************
 * Visualforce Development Cookbook Recipe 1_7
 *
 * Custom controller for the "Passing Parameters between Visualforce
 * Pages" recipe.
 * Allows searching for accounts matching submitted text and sending
 * the ids to the edit page.
 *
 *******************************************************************/
public with sharing class SearchAndEditController 
{
	// the search text
	public String name {get; set;}
	
	// the matching accounts
	public List<Account> accounts {get; set;}
	
	// indicator that a search has taken place
	public Boolean searched {get; set;}
	
	// constructor - extracts the search parameter from the URL and, if
	// present, executes a search to find matching accounts
	public SearchAndEditController()
	{
		searched=false;
	
		// extract the name parameter from the URL
		String nameStr=ApexPages.currentPage().getParameters().get('name');
		
		// if it is present, execute the search
		if (null!=nameStr)
		{
			name=nameStr;
			executeSearch();
		}
	}
	
	// action method to search for accounts whose name contains the entered
	// text
	public PageReference executeSearch()
	{
		searched=true;
		String searchStr='%' + name + '%';
		accounts=[select id, Name, Industry, Type from Account where name LIKE :searchStr];
		
		return null;
	}
	
	// action method to allow editing of the matching accounts - redirects the user to the
	// EditFromSearch page and passes the account ids as parameters on the URL
	public PageReference edit()
	{
		PageReference pr=Page.EditFromSearch;
		
		// iterate the accounts and add a parameter containing the ID to the target URL
		Integer idx=1;
		for (Account acc : accounts)
		{
			pr.getParameters().put('account' + idx, acc.id);
			idx++;
		}
		
		return pr;
	}
}