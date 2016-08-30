/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_2
 *
 * Custom controller for the "Managing a List of Records" recipe.
 * Manages a list of contact records, holding insert/delete 
 * information in memory until the user chooses to save the changes.
 *******************************************************************/
public with sharing class ContactListEditController 
{
	// wrapper classes for the contacts being managed
	public List<ContactKeyWrapper> wrappers {get; set;}
	
	// when a user chooses to add items, the number of
	// items to add will be present in this property
	public Integer addItemCount {get; set;}
	
	// when a user deletes a record, the record key will
	// be present in this property
	public Integer keyToDelete {get; set;}
	
	// the unique record key master value
	public Integer mainKey {get; set;}
	
	// the records to delete when the user saves their work
	private List<Contact> toDelete=new List<Contact>();
	
	// constructor
	public ContactListEditController()
	{
		mainKey=1;
		addItemCount=3;
		wrappers=new List<ContactKeyWrapper>();
		
		// get the first five contacts from the database to ensure there is some data present on the page
		List<Contact> contacts=[select id, FirstName, LastName from Contact order by CreatedDate limit 5];
		for (Contact cont : contacts)
		{
			wrappers.add(new ContactKeyWrapper(mainKey++, cont));
		}
	}
	
	// add a number of items to the list
	public PageReference addItems()
	{
		if ( (addItemCount>0) && (addItemCount<=10) )
		{
			for (Integer idx=0; idx<addItemCount; idx++)
			{
				wrappers.add(new ContactKeyWrapper(mainKey++, new Contact()));
			}
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a value between 1 and 10'));
		}
		
		return null;
	}
	
	// remove (delete) an item from the list
	public PageReference removeItem()
	{
		Integer idx=0;
		Boolean found=false;
		for (ContactKeyWrapper wrap : wrappers)
		{
			if (wrap.key==keyToDelete)
			{
				found=true;
				if (null!=wrap.cont.id)
				{
					toDelete.add(wrap.cont);
				}
				break;
			}
			else
			{
				idx++;
			}
		}
		
		if (found)
		{
			wrappers.remove(idx);
		}
		
		return null;
	}
	
	// save the users work
	public PageReference save()
	{
		PageReference result=null;
		Boolean error=false;
		List<Contact> toUpsert=new List<Contact>();
		
		// make sure that if any data has been entered, the
		// last name is present as this is required
		for (ContactKeyWrapper wrapper : wrappers)
		{
			if ( (!String.IsBlank(wrapper.cont.FirstName)) || 
			     (!String.IsBlank(wrapper.cont.LastName)) )
			{
				if (String.IsBlank(wrapper.cont.LastName))
				{
					wrapper.cont.LastName.addError('Required');
					error=true;
				}
				else
				{
					toUpsert.add(wrapper.cont);
				}
			}
		}
		
		if (!error)
		{
			delete toDelete;
			upsert toUpsert;
		
			// return the user to the contacts tab
			result=new PageReference('/003/o');
		}
		
		return result;
	} 
}