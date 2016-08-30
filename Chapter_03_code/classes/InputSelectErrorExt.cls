/*******************************************************************
 * Visualforce Development Cookbook Recipe 3_3
 *
 * Extension controller for the "Adding Errors to Non-Input Fields" 
 * recipe. Validates that a regular HTML input contains valid data
 * and if it doesn't, associates an error with the input value. 
 *******************************************************************/
public with sharing class InputSelectErrorExt 
{
	// parent standard controller
	private ApexPages.StandardController stdCtrl {get; set;}
	
	// object to encapsulate the entered value and any error
	// message associated with it
	public ValueAndError accountIdVal {get; set;}
		
	// constructor
	public InputSelectErrorExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
		accountIdVal=new ValueAndError();
	}
	
	// Creates select list options for all accounts in the system
	public List<SelectOption> getAccountOptions()
	{
		List<SelectOption> result=new List<SelectOption>();
		result.add(new SelectOption('', '-- Choose --'));
		for (Account acc : [select id, Name from Account])
		{
			result.add(new SelectOption(acc.Id, acc.Name));
		}
		
		return result;
	}
	
	// validates the input and generates an error message or
	// delegates to the standard controller save method
	public PageReference save()
	{
		PageReference result=null;
		
		// clear down the previous errors
		accountIdVal.error='';
		
		if (String.IsBlank(accountIdVal.value))
		{
			accountIdVal.error='Please choose an account';
		}
		else
		{
			result=stdCtrl.save();
		}
		
		return result;
	}
	
	// custom class to encapsulate a value and error message
	public class ValueAndError
	{
		public String value {get; set;}
		public String error {get; set;} 
		
		public Boolean getHasError()
		{
			return (!String.IsBlank(error));
		}
	}
}