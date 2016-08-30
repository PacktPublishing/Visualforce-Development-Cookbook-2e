/*******************************************************************
 * Visualforce Development Cookbook Recipe 8_3
 *
 * Custom controller for the "Retrieving Salesforce Data" recipe.
 * Extracts the three most recent SiteItem records.
 *******************************************************************/
public with sharing class SiteItemController 
{
	// the records
	public List<SiteItem__c> items {get; set;}
	
	// constructor
	public SiteItemController()
	{
		items=[select Name, Detail__c from SiteItem__c order by LastModifiedDate desc limit 3];
	}
}