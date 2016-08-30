/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_2
 *
 * Custom controller for the "Styling Table Columns as Required" 
 * recipe.
 * Manages an editable list of contacts.
 *******************************************************************/
public with sharing class RequiredColumnController 
{
	// the editable list of contacts
	public List<Contact> contacts {get; set;}
	
	// constructor - populates the list with new contact instances
	public RequiredColumnController()
	{
		Contacts=new List<Contact>();
		for (Integer idx=0; idx<10; idx++)
		{
			contacts.add(new Contact());
		}
	}
	
	// determines which contacts to save based on populated fields.  validates that
	// the last name has been provided if another field is present.
	public PageReference save()
	{
		Boolean error=false;
		List<Contact> toSave=new List<Contact>();
		for (Contact cont : contacts)
		{
			if ( (!String.IsBlank(cont.FirstName)) || 
			     (!String.IsBlank(cont.LastName)) )
			{
				// a field is defined - check for last name
				if (String.IsBlank(cont.LastName))
				{
					error=true;
					cont.LastName.addError('Please enter a value');
				}
				else
				{
					toSave.add(cont);
				}
			}
		}
		
		PageReference result=null;
		if (!error)
		{
			insert toSave;
			result=new PageReference('/003/o');
		}
		
		return result;
	}
}