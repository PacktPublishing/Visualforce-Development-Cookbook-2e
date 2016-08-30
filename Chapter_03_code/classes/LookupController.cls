/*******************************************************************
 * Visualforce Development Cookbook Recipe 1_9
 *
 * Custom controller for the "Custom Lookup" recipe. Executes a 
 * search based on a query string entered by a user. 
 *******************************************************************/
public with sharing class LookupController 
{
	// the query string entered by the user
    public String query {get; set;}
    
    // the matching accounts
    public List<Account> accounts {get; set;}
    
    // has a search been executed?
    public Boolean doneLookup {get; set;}
    
    // constructor
    public LookupController()
    {
    	doneLookup=false;
    }
    
    // executes the search
    public PageReference runQuery()
    {
        List<List<Account>> searchResults=
            [FIND :query IN ALL FIELDS RETURNING 
                Account (id, name, billingstreet, billingcity, billingpostalcode)];
        accounts=searchResults[0];
        doneLookup=true;
        return null;
    }
}