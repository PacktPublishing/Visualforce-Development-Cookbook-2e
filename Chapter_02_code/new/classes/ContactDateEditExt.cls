/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_2
 *
 * Extension controller for the "Updating Attributes in Component
 * Controllers" recipe.
 * Manages a date of birth that may be updated by a component in the
 * page.
 *******************************************************************/
public with sharing class ContactDateEditExt 
{
	// the date of birth
	public DateContainer dob {get; set;}
	
	// the contact being managed by the standard controller
	private Contact cont;
	
	// the standard controller
	private ApexPages.StandardController stdCtrl {get; set;}
	
	// constructor
	public ContactDateEditExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
		cont=(Contact) std.getRecord();
		dob=new DateContainer(cont.BirthDate);
	}	

	// action method invoked when the user clicks the save button - updates the
	// contacts date of birth
	public PageReference save()
	{
		cont.BirthDate=dob.value;
		
		System.debug('#### Set contact birthdate to ' + cont.BirthDate);
		
		return stdCtrl.save();
	}
}