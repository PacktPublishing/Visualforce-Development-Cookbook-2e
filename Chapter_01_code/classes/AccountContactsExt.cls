/*******************************************************************
 * Visualforce Development Cookbook Recipe 1_11
 *
 * Extension controller for the "Testing a Controller Extension" recipe.
 * Retrieves the contacts associated with the account managed by the
 * standard controller and stores these in public property.
 *
 *******************************************************************/
public with sharing class AccountContactsExt 
{
	// the contacts associated with the account
	public List<Contact> contacts {get; set;}
	
	// constructor - retrieves the contacts associated with the 
	// account managed by the standard controller
	public AccountContactsExt(ApexPages.StandardController std)
	{
		Id accId=std.getId();
		contacts=[select id, FirstName, LastName, Email from Contact where AccountId=:accId];
	}
}