/*******************************************************************
 * Visualforce Development Cookbook Recipe 8_2
 * 
 * Custom controller for the "Record and Field Access" recipe.
 * Executes a search for contacts matching a user input email.
 *******************************************************************/
public with sharing class RetrieveContactController 
{
	// The user input email
	public String emailStr {get; set;}
	
	// Indicator that a search has been run and a contact found
	public Boolean contactFound {get; set;}
	
	// The matching contact
	public Contact cont {get; set;}
	
	// Constructor
	public RetrieveContactController()
	{
		contactFound=false;
	}
	
	// Action method to execute the search
	public void lookup()
	{
		List<Contact> conts=[select FirstName, LastName, Email from Contact where email=:emailStr];
		if (conts.size()>0)
		{
			contactFound=true;
			cont=conts[0];
		}
		else
		{
			contactFound=false;
		}
	}
}