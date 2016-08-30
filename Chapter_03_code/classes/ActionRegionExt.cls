/*******************************************************************
 * Visualforce Development Cookbook Recipe 3_8
 *
 * Extension controller for the "Action Regions" recipe. Generates
 * the subject for a case based on a user entered base subject and
 * the name of the selected account.  
 *******************************************************************/
public with sharing class ActionRegionExt 
{
	// the parent standard controller
	private ApexPages.StandardController stdCtrl;
	
	// the base subject entered by the user
	public String baseSubject {get; set;}
  
    // constructor
	public ActionRegionExt(ApexPages.StandardController std)
	{
 		stdCtrl=std;
	}

	// action method invoked when the account lookup is changed - prepends the
	// account name to the user entered subject if the account has been 
	// populated, otherwise uses just the base name.
    public PageReference setupSubject()
    {
    	String subject='';
		Case cs=(Case) stdCtrl.getRecord();
		
		// handle the situation where the account field has been cleared
		if (!String.isBlank(cs.AccountId))
		{
			Account acc=[select Name from Account where id=:cs.AccountId];
    		subject+=acc.Name + ' - ';
		}
		
    	if (null!=baseSubject)
    	{
    		subject+=baseSubject;
    	}
    	
		cs.Subject=subject;
		
		return null;
    }
}