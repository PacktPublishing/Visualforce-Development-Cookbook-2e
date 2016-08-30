/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_10
 * 
 * Custom controller for the "Form Based Searching" recipe.
 * Executes a search via SOQL based on the fields the user has 
 * entered on the associated Visualforce page.
 *******************************************************************/
public with sharing class SearchAccountsController 
{
	// the search results
	public List<Account> results { get; set;}
	
	// the account instance to capture the search criteria
	public Account searchAcc {get; set;}
	
	// the industry picklist options to allow selection of more than one
	public List<SelectOption> industryOptions=new List<SelectOption>();
	
	// the chosen industries
    public String[] industries {get; set;}
	
	// constructor
	public SearchAccountsController()
	{
		industries=new List<String>();
		searchAcc=new Account();
	}
	
	// determine the industry options by interrogating the schema
    public List<SelectOption> getIndustryOptions()
    {
       if (industryOptions.isEmpty())
       {
           Schema.DescribeFieldResult fieldDesc = Account.Industry.getDescribe();
           List<Schema.PicklistEntry> plEntries = fieldDesc.getPicklistValues();
           
           for (Schema.PickListEntry plEntry : plEntries)
           {
           	  SelectOption option=new SelectOption(plEntry.getValue(), plEntry.getLabel());
           	  industryOptions.add(option); 
           }
       }	
       
       return industryOptions;
    }
    
    // action method to search for accounts matching the criteria
	public PageReference executeSearch()
	{
		if (null!=results)
		{
			results.clear();
		}
		String whereStr='';
		
		// only add a name clause if the user has entered some text
		if (!String.IsEmpty(searchAcc.Name))
		{
			String wcName='%' + searchAcc.Name + '%';
			whereStr+=' OR Name LIKE \'' + wcName + '\'';
		}
		
		// only add a website clause if the user has entered some text
		if (!String.IsEmpty(searchAcc.Website))
		{
			String wcWebsite='%' + searchAcc.Website + '%';
			whereStr+=' OR Website LIKE \'' + wcWebsite + '\'';
		}
		
		// only add an industries clause if the user has selected one or more
		if  ( (null!=industries) && (industries.size()>0) )
		{
			for (Integer idx=0; idx<industries.size(); idx++)
			{
				whereStr+=' OR Industry = \'' + industries[idx] + '\'';
			}
		}
		
		// only execute a search if the user entered some criteria
		if (''!=whereStr)
		{
			String queryStr='select Id, Name, Website, Industry from Account where ' + whereStr.substring(4);
			results=Database.query(queryStr);
		}
		
		return null;
	}
}