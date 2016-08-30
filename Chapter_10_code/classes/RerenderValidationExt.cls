/*******************************************************************
 * Visualforce Development Cookbook Recipe 10_2
 * 
 * Extension controller for the "Errors - Harmful if Swallowed" 
 * recipe. Associates the chosen account with the opportunity when
 * the user populates a lookup.  
 *******************************************************************/
public with sharing class RerenderValidationExt 
{
	// the parent standard controller
	private ApexPages.StandardController stdCtrl;
  
	// constructor
	public RerenderValidationExt(ApexPages.StandardController std)
	{
 		stdCtrl=std;
	}
  
	// action method invoked when the account is selected. Queries back the
	// selected account and attaches it to the opportunity, or clears the
	// account relationship if the account field has been cleared.
	public void AccountSelected()
	{
		Opportunity opp=(Opportunity) stdCtrl.getRecord();
		
		System.debug('### Opp = ' + opp);
		
		// handle the situation where the account field has been cleared
		if (!String.isBlank(opp.AccountId))
		{
			opp.Account=[select Website, Phone from Account where id=:opp.AccountId];
		}
		else
		{
			opp.Account=null;
		}
	}
}