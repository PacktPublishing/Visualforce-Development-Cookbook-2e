/*******************************************************************
 * Visualforce Development Cookbook Recipe 10_6
 *
 * Extension controller for the "Debugging Visualforce" recipe.  
 *******************************************************************/
public with sharing class DebuggingController 
{
    public transient List<Account> oldestAccounts;
    
    public DebuggingController()
    {
		System.debug('In constructor');
    }
    
    public List<Account> getOldestAccounts()
    {
    	System.debug('In getOldestAccounts');
    	if (null==oldestAccounts)
    	{
    		System.debug('Accounts have not yet been cached - querying from database');
    		oldestAccounts=[select id, Name, Industry, CreatedDate from Account order by CreatedDate asc limit 10];
    		System.debug('Retrieved ' + oldestAccounts.size() + ' accounts');
    	}
    	else
    	{
    		System.debug('Accounts are already cached');
    	}
    	
    	System.debug('SOQL queries after getOldestAccounts - used ' + Limits.getQueries() + ' out of ' + Limits.getLimitQueries());
    	
    	return oldestAccounts;
    }
}