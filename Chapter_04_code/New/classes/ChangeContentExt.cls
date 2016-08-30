/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_9
 *
 * Extension controller for the "Changing Page Layout Based on User
 * input" recipe.
 * Indicates to the associated page if the customer section of the 
 * page should be rendered, based on the type of the account 
 * being managed by the standard controller.
 *******************************************************************/
public with sharing class ChangeContentExt 
{
	// the standard controller being extended
	private ApexPages.StandardController stdCtrl;
	
	// flag to indicate if the customer section should be rendered
	public Boolean showCustomerSection {get; set;}
	
	// constructor
	public ChangeContentExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
		showCustomerSection=false;
	}
	
	// action method to determine if the customer section should be
	// rendered when the user changes the account type
	public PageReference typeChanged()
	{
		Account acc=(Account) stdCtrl.getRecord();
		if (acc.Type.toLowerCase().contains('customer'))
		{
			showCustomerSection=true;
		}
		else
		{
			showCustomerSection=false;
		}
		
		return null;
	}
}