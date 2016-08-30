/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_8
 *
 * Custom controller for the "Notify Containing Page Controller" 
 * recipe. 
 * Manages the available/selected options and notifies another
 * class when a change is made
 *******************************************************************/
public with sharing class NotifyingMultiSelectRelatedController 
{
	// all options
	private List<SelectOption> allOptions;
	
	// semi-colon seperated list of selected ids
	private StringContainer selected;
	
	// available items
	public List<SelectOption> availableItems {get; set;}
	
	// chosen items
	public List<SelectOption> chosenItems {get; set;}
	
	// property to back the available select list
	public String[] available {get; set;}
	
	// property to back the available select list
	public String[] chosen {get; set;}
	
	// section title
	public String title {get; set;}

	// class to notify of a change
	public Notifiable notifiable {get; set;}
	
	// getter for all options
	public List<SelectOption> getAllOptions()
	{
		return allOptions;
	}
	
	// setter for all options
	public void setAllOptions(List<SelectOption> inOptions)
	{
		if (null==allOptions)
		{
			allOptions=inOptions;
			setupLists();
		}
	}
	
	
	// getter for the selected ids
	public StringContainer getSelected()
	{
		return selected;
	}
	
	// setter for the selected ids
	public void setSelected(StringContainer inSel)
	{
		if (null==selected)
		{
			selected=inSel;
	
			setupLists();
		}
	}

	// rebuilds the lists
	private void resetLists()
	{	
		chosenItems.clear();
		availableItems.clear();
		setupLists();
	}
	
	// builds the selected/available lists based on the selected ids
	private void setupLists()
	{
		if ( (null==availableItems) || (availableItems.isEmpty()) )
		{
			if ( (null!=allOptions) && (null!=selected) )
			{
				availableItems=new List<SelectOption>();
				chosenItems=new List<SelectOption>();
				
				for (SelectOption sel : allOptions)
				{
					String selId=sel.getValue();
					if (selected.value.contains(selId+';'))
					{
						chosenItems.add(sel);
					}
					else
					{
						availableItems.add(sel);
					}
				}
			}
		}
	}
	
	// adds the chosen elements from the available list into the
	// chosen list
	public PageReference add()
	{
		for (String avItem : available)
		{
			String cand=avItem+';';
			selected.value+=cand;
		}
		
		resetLists();
		
		System.debug('#### In add - notifiable = ' + notifiable);
		if (null!=notifiable)
		{
			notifiable.notify('Values added - now ' + selected.value);
		}
		
		return null;
	}
	
	// helper method to figure out the position of a string in
	// a list
	private Integer getPosInList(String item, list<String> lst)
	{
		Integer pos=-1;
		for (Integer idx=0; idx<lst.size(); idx++)
		{
			if (lst[idx]==item)
			{
				pos=idx;
				break;
			}
		}
		
		return pos;
	}
	
	// moves the selected elements from the chosen list to the
	// available list
	public PageReference remove()
	{
		List<String> sels=selected.value.split(';');
		for (String chItem : chosen)
		{
			Integer pos=getPosInList(chItem, sels);
			if (-1!=pos)
			{
				sels.remove(pos);
			}
		}
		
		String newSelected='';
		for (String sel : sels)
		{
			String cand=sel+';';
			newSelected+=cand;
		}
		
		selected.value=newSelected;
		
		resetLists();
						
		System.debug('#### Notifiable = ' + notifiable);
		if (null!=notifiable)
		{
			notifiable.notify('Values deleted - now ' + selected.value);
		}
		
		return null;
	}
}