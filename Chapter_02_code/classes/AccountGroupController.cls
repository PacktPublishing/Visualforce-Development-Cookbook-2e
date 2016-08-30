/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_7
 *
 * Custom controller for the "Multi-Select Related Controller" 
 * recipe. 
 * Manages the demonstration Visualforce page. 
 *******************************************************************/
public with sharing class AccountGroupController
{
	// the account group being managed
	public Account_Group__c accountGroup {get; set;}
	
	// all accounts
	public List<SelectOption> accountOptions {get; set;}
	
	// semi-colon seperated list of chosen account ids
	public StringContainer chosenAccounts {get; set;}

	// constructor	
	public AccountGroupController()
	{
		chosenAccounts=new StringContainer('');
		
		accountOptions=new List<SelectOption>();
		for (Account acc : [select id, Name from Account])
		{
			accountOptions.add(new SelectOption(acc.id, acc.name));
		}
		
		accountGroup=new Account_Group__c();
	}
	
	// action method called when the user clicks the save button - inserts
	// the account group and creates a junction object for each selected
	// account
	public PageReference save()
	{
		insert accountGroup;
		List<Account_Group_JO__c> agJOs=new List<Account_Group_JO__c>();
		for (String accId : chosenAccounts.value.split(';'))
		{
			Account_Group_JO__c agJO=new Account_Group_JO__c(Account_Group__c=accountGroup.id, Account__c=accId);
			agJOs.add(agJO);
		}
		
		insert agJOs;
		
		return new PageReference('/' + accountGroup.id);
	}
}