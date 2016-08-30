/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_1
 *
 * Extension controller for the "Styling Fields as Required" recipe.
 * Manages a contact and validates upon saving.
 *******************************************************************/
public with sharing class RequiredStylingExt 
{
	// the standard controller that is being extended
	private ApexPages.StandardController stdCtrl;
	
	// constructor
	public RequiredStylingExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
	}
	
	// Validates that the contact name and one of email/phone is provided before 
	// delegating to the standard controller save method
	public PageReference save()
	{
		Contact cont=(Contact) stdCtrl.getRecord();
		Boolean error=false;
		
		if (String.IsBlank(cont.name))
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the contact name'));
			error=true;
		}
		
		if ( (String.IsBlank(cont.Email)) && (String.IsBlank(cont.Phone)) )
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please supply the email address or phone number'));
			error=true;
		}
		
		PageReference result=null;
		if (!error)
		{
			result=stdCtrl.save();
		}
		
		return result;
	}

}