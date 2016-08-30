/*******************************************************************
 * Visualforce Development Cookbook Recipe 8_4
 *
 * Controller extension for the "Web to Lead Form" recipe.
 * Validates the user input and creates a lead in Salesforce 
 *******************************************************************/
public with sharing class WebToLeadExt 
{
	// the Lead standard controller being extended 
	private ApexPages.StandardController stdCtrl {get; set;}
	
	// indicator that an error occurred
	public Boolean error {get; set;}
	
	// the error message
	public String errorMsg {get; set;}
	
	// contstructor
	public WebToLeadExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
		error=false;
	}
	
	// action method to validate the input and save the lead
	public PageReference save()
	{ 
		PageReference pr=null;
		
		errorMsg='';
		error=false;
		Lead ld=(Lead) stdCtrl.getRecord();
		if ( (String.isEmpty(ld.Company)) || (String.isEmpty(ld.FirstName)) )
		{
			errorMsg='Please enter all required fields';
			error=true;
		}
		else
		{
			try
			{
				insert ld;
				pr=Page.WebToLeadThanks;
				pr.getParameters().put('id', ld.id);
				pr.setRedirect(true);
			}
			catch (Exception e)
			{
				errorMsg='An error has occurred: ' + e.getMessage();
				error=true;
			}
		}
		return pr;
	}
}