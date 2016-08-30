/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_8
 *
 * Custom controller for the "Notify Containing Page Controller" 
 * recipe. 
 * Manages the demonstration Visualforce page. 
 *******************************************************************/
public with sharing class NotifiableAccountGroupController implements Notifiable
{
	// the account group being managed
	public Account_Group__c accountGroup {get; set;}
	// all accounts
	public List<SelectOption> accountOptions {get; set;}
	
	// semi-colon seperated list of chosen account ids
	public StringContainer chosenAccounts {get; set;}

	// constructor	
	public NotifiableAccountGroupController()
	{
		chosenAccounts=new StringContainer('');
		
		accountOptions=new List<SelectOption>();
		for (Account acc : [select id, Name from Account])
		{
			accountOptions.add(new SelectOption(acc.id, acc.name));
		}
		
		accountGroup=new Account_Group__c();
	}
	
	// returns this class as an instance of the Notifiable interface
	public Notifiable getNotifiable()
	{
		return this;
	}
	
	// receive notice from the component controller that a change has been made
	public void notify(String detail)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Notified - ' + detail));
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