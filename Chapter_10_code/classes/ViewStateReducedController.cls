/*******************************************************************
 * Visualforce Development Cookbook Recipe 10_4
 *
 * Custom controller for the "Reducing the view state size" recipe.
 * Stores the account options in a transient controller to reduce
 * the view state impact.
 *******************************************************************/
public with sharing class ViewStateReducedController
{
	public transient List<SelectOption> accountOptions;
	
	public List<SelectOption> getAccountOptions()
	{
		if (null==accountOptions)
		{
			accountOptions=new List<SelectOption>();
			for (Account acc : [select id, Name from Account])
			{
				accountOptions.add(new SelectOption(acc.Id, acc.Name));
			}
		}
		
		return accountOptions;
	}
}    