/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_5
 *
 * Custom controller for the "Inline Edit a Record from a List" 
 * recipe.
 * Manages a list of contact records and allows a user to save 
 * changes made on the associated Visualforce page.
 *******************************************************************/
public with sharing class ContactDblClickEditController 
{
	// the contact chosen to edit.
	public Id chosenContactId {get; set;}
	
	// the available contacts
	public List<Contact> contacts {get; set;}
	
	// Constructor
	public ContactDblClickEditController()
	{
		contacts=[select FirstName, LastName, Email from Contact order by CreatedDate limit :10];
	}
	
	// Action method to save any changes made. This simply updates all contacts in the list
	public PageReference save()
	{
		update contacts;
		
		return cancel();
	} 
	
	// Cancel out of the list page - returns the user to the contacts tab
	public PageReference cancel()
	{
		return new PageReference('/003/o');
	} 
	
	// Action method invoked when a user indicates that they have finished 
	// editing a record.
	public PageReference done()
	{
		chosenContactId=null;
		
		return null;
	} 
}