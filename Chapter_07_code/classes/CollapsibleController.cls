/*******************************************************************
 * Visualforce Development Cookbook Recipe 7_6
 *
 * Custom controller for the "Collapsible List Elements" recipe.
 *******************************************************************/
public with sharing class CollapsibleController 
{
	// getter to extract the 5 oldest accounts and their contacts
	public List<Account> getAccounts()
	{
		return [select id, name, Type, (select id, Name, Email from Contacts) from Account order by CreatedDate limit 5];
	}
}