/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_8
 *
 * Custom controller for the "Changing Options Based on User Input" 
 * recipe.
 * Manages a list of contacts and their selected status, a list of
 * tasks that may be assigned to the contacts and a list of the 
 * contacts available for assigning.
 *******************************************************************/
public with sharing class SelectContactsController 
{
	// the full list of contact wrappers
	public List<ContactWrapper> contacts {get; set;}
	
	// the tasks that may be assigned to the contacts
	public List<Task> tasks {get; set;}
	
	// the contacts available for selection
	public List<SelectOption> available {get; set;}
	
	// constructor - builds the full list of contact wrapper classes
	// based on the oldest 10 contacts in the system, sets up the assignee
	// options based on the initial contact wrapper list and instantiates
	// the list of tasks
	public SelectContactsController()
	{
		contacts=new List<ContactWrapper>();		
		for (Contact cont : [select id, FirstName, LastName from Contact order by CreatedDate limit 10])
		{
			contacts.add(new ContactWrapper(cont));
		}
		
		setupAssignees();
		setupTasks();
	}

	// helper method to set up the task list
	private void setupTasks()
	{				
		tasks=new List<Task>();
		for (Integer idx=0; idx<5; idx++)
		{
			tasks.add(new Task());
		}
	}	
		
	// helper method to set up the contact assignees based on 
	// their available status
	private void setupAssignees()
	{
		available=new List<SelectOption>();
		for (ContactWrapper cw : contacts)
		{
			if (cw.available)
			{
				available.add(new SelectOption(cw.cont.id, cw.cont.FirstName + ' ' + cw.cont.LastName));
			}
		}
	}
	
	// action method invoked when the availability of a contact to 
	// be used as an assignee changes
	public PageReference availableChanged()
	{
		setupAssignees();
		
		return null;
	}
	
	// action method to save the tasks
	public PageReference save()
	{
		insert tasks;
		
		ApexPages.StandardController std=new ApexPages.StandardController(new Task());
		return std.cancel();
	}
	
	// action method to cancel the edit
	public PageReference cancel()
	{
		ApexPages.StandardController std=new ApexPages.StandardController(new Task());
		return std.cancel();
	}
	
	// wrapper class to encapsulate a contact and its available status
	public class ContactWrapper
	{
		// the contact
		public Contact cont {get; set;}
		
		// the availability of the contact to be assigned
		// to a task
		public Boolean available {get; set;}
		
		// constructor
		public ContactWrapper(Contact inContact)
		{
			cont=inContact;
			available=true;
		}
	}
}