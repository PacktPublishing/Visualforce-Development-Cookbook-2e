/*******************************************************************
 * Visualforce Development Cookbook Recipe 3_2
 *
 * Extension controller for the "Adding Errors to Input Fields" 
 * recipe. 
 * Adds validation errors to sobject fields that can be displayed
 * against the field. 
 *******************************************************************/
public with sharing class InputFieldErrorExt 
{
	// the parent standard controller
	private ApexPages.StandardController stdCtrl;
	
	// Constructor
	public InputFieldErrorExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
	}
	
	// validates the inputs and adds error messages or delegates to
	// the standard controller save method
	public PageReference save()
	{
		PageReference result=null;
		Contact cont=(Contact) stdCtrl.getRecord();
		
		if ( (String.IsBlank(cont.Email)) && (String.IsBlank(cont.Phone)) )
		{
			cont.email.addError('Please enter an email address or phone number');
			cont.phone.addError('Please enter a phone number or email address');
		}
		else
		{
			result=stdCtrl.save();
		} 
		
		return result;
	}
}