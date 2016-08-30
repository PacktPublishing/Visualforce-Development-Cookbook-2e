/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_6
 *
 * Extension controller for the "Refresh Record Detail from Embedded
 * Visualforce" recipe.
 * Captures additional case comments and notifies the associated
 * page to refresh.
 *******************************************************************/
public with sharing class RefreshEmbeddedExt 
{
	// the standard controller being extended
	public ApexPages.StandardController stdCtrl {get; set;}
	
	// flag to indicate the associated page should refresh itself
	public Boolean refreshPage {get; set;}
	
	// the case comment being added
	public CaseComment cc {get; set;}
	
	// the page that should be refreshed
	public String pageRef {get; set;}

	// constructor
	public RefreshEmbeddedExt(ApexPages.standardController std)
	{
		stdCtrl=std;
		refreshPage=false;
		cc=new CaseComment();
	}
  
	// action method to save the case comment and tell the associated
	// page to refresh itself
	public PageReference save()
	{
		cc.parentId=stdCtrl.getId();
		insert cc;
		
		refreshPage=true;
		pageRef=stdCtrl.view().getUrl();
   
		return null;
	}
}