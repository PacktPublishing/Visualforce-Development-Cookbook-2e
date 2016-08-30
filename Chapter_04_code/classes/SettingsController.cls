/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_5
 *
 * Custom controller for the "Maintaining Custom Settings" recipe.
 * Manages a custom settings instance
 *******************************************************************/
public with sharing class SettingsController 
{
	// custom settings instance name
	public final static String VF_COOKBOOK_APP='VF Cookbook App';
	
	// the custom settings instance being managed
	public VF_Cookbook_Settings__c settings {get; set;}
	
	// constructor - queries the custom setting instance from the cache
	public SettingsController()
	{
		settings=VF_Cookbook_Settings__c.getInstance(VF_COOKBOOK_APP);
	}
	
	// action method to save the changes to the custom setting
	public PageReference save()
	{
		update settings;
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'All changes saved'));
		
		return null;
	}
}