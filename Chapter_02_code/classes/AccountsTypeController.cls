/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_6
 *
 * Custom controller for the "Set Value into Controller Property" 
 * recipe. 
 * Retrieves a list of accounts of a particular type 
 *******************************************************************/
public with sharing class AccountsTypeController 
{
	// the type of account to retrieve
	public String accType {get; set;}
	
	// the maximum number of accounts to retrieve
	public Integer max {get; set;}
	
	// retrieve the accounts
	public List<Account> getAccounts()
	{
		return [select id, Name, Phone, BillingState, Type, Industry, AnnualRevenue 
		        from Account 
		        where Type=:accType 
		        limit :max];
	}
}