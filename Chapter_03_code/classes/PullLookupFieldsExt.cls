/*******************************************************************
 * Visualforce Development Cookbook Recipe 3_7
 *
 * Extension controller for the "Retrieving Fields when a Lookup is
 * Populated" recipe.  
 *******************************************************************/
public with sharing class PullLookupFieldsExt 
{
	// parent standard controller
	private ApexPages.StandardController stdCtrl;
  
    // constructor
	public PullLookupFieldsExt(ApexPages.StandardController std)
	{
 		stdCtrl=std;
	}
  
  	// Action method invoked when the lookup is changed - this retrieves
  	// the fields if the lookup contains a value, or clears them if the
  	// lookup has been cleared.
	public void AccountSelected()
	{
		Case cs=(Case) stdCtrl.getRecord();
		
		// handle the situation where the account field has been cleared
		if (!String.isBlank(cs.AccountId))
		{
			cs.Account=[select Website, Phone from Account where id=:cs.AccountId];
		}
		else
		{
			cs.Account=null;
		}
	}
}