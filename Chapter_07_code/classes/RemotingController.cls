/*******************************************************************
 * Visualforce Development Cookbook Recipe 7_7
 *
 * Custom controller for the "JavaScript Remoting" recipe.
 * Provides a remote method to create a Lead.
 *
 *******************************************************************/
public with sharing class RemotingController 
{
	@RemoteAction 
	public static Lead CreateLead(String salutation, String firstName, String lastName, String company)
	{
		Lead ld=new Lead(Salutation=salutation,
						 FirstName=firstName,
						 LastName=lastName,
						 Company=company);
						 
		// insert the lead - any missing required fields etc will generate a DML exception
		// which will be handlded client side
		insert ld;
		
		return ld;
	}
}