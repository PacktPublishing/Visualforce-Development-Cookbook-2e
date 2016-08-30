/*******************************************************************
 * Visualforce Development Cookbook Recipe 10_1
 * 
 * Extension controller for the "Avoid Validation Errors with Action
 * Regions" recipe.  Queries additional fields from the chosen 
 * account record fro an opportunity.  
 *******************************************************************/
public with sharing class ActionRegionAvoidValidationExt 
{
	// the parent standard controller
	private ApexPages.StandardController stdCtrl;
  
    // constructor
	public ActionRegionAvoidValidationExt(ApexPages.StandardController std)
	{
 		stdCtrl=std;
	}
  
	// action method invoked when the account is selected. Queries back the
	// selected account and attaches it to the opportunity, or clears the
	// account relationship if the account field has been cleared.
	public void AccountSelected()
	{
		Opportunity opp=(Opportunity) stdCtrl.getRecord();
		
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