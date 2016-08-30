/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_5
 *
 * Extension controller for the "Custom Iterator Component" recipe. 
 * Manages the lists of contacts and accounts associated with the 
 * account managed by the standard controller.
 *******************************************************************/
public with sharing class AllOrNothingListsExt 
{
	// the account's contacts
	public List<Contact> contacts {get; set;}
	
	// the account's opportunities
	public List<Opportunity> opportunities {get; set;}
	
	// constructor - retrieves the contacts and opportunities for the account
	// managed by the standard controller
	public AllOrNothingListsExt(ApexPages.StandardController stdCtrl)
	{
		Id accId=stdCtrl.getId();
		contacts=[select id, Salutation, FirstName, LastName, Title, Email from Contact where AccountId=:accId];
		opportunities=[select id, Name, CloseDate, Amount, StageName, Probability from Opportunity where AccountId=:accId];
	}
}