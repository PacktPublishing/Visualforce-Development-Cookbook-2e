/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_1
 *
 * Extension controller for the "Edit a Record and its parent" recipe.
 * Retrieves the account associated with the contact record being
 * managed by the standard controller and provides a mechansim to 
 * save both records.
 *******************************************************************/
public with sharing class ContactAndAccountEditExt 
{
	// the standard controller
	private ApexPages.StandardController stdCtrl {get; set;}
	
	// the parent account
	public Account acc {get; set;}
	
	// the contact being managed by the standard controller
	private Contact cont;
	
	// constructor - extracts the parent account for the contact being
	// managed by the standard controller, if one exists
	public ContactAndAccountEditExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
		cont=(Contact) stdCtrl.getRecord();
		
		// get the parent if it exists
		if ( (null!=cont.Id) && (null!=cont.AccountId) )
		{
			acc=[select id, Name, Type, NumberOfEmployees, Industry from Account where id=:cont.AccountId];
		}
		else
		{
			// no parent exists - create one
			acc=new Account();
		}
	}
	
	// action method to save the account and contact
	public PageReference save()
	{
		upsert acc;
		
		// fix up the account reference on the contact
		// record if we inserted it
		if (null==cont.AccountId)
		{
			cont.AccountId=acc.id;
		}
		
		// delegate to the standard controller to save
		// the contact and provude the page reference 
		// to return to
		return stdCtrl.save();
	}
}