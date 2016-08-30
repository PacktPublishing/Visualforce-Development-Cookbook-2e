/*******************************************************************
 * Visualforce Development Cookbook Recipe 7_1
 *
 * Custom controller for the "Using Action Functions" recipe. 
 *******************************************************************/
public with sharing class ActionFunctionController 
{
	// constructor
	public List<Case> getCases()
	{
		return [select id, CaseNumber, Status, Account.Name from Case order by CreatedDate limit 10];
	}
	
	// action method to navigate to the cases standard tab
	public PageReference goCasesTab()
	{
		PageReference result=new PageReference('/500/o');
		return result;
	}
}