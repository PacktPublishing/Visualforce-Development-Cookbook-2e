/*******************************************************************
 * Visualforce Development Cookbook Recipe 10_4
 *
 * Custom controller for the "Reducing the view state size" recipe.
 * Caches the account options which consumes the view state 
 * unnecessarily
 *******************************************************************/
public with sharing class ViewStateLargeController 
{
	public List<SelectOption> accountOptions {get; set;}
	
	public ViewStateLargeController()
	{
		accountOptions=new List<SelectOption>();
		for (Account acc : [select id, Name from Account])
		{
			accountOptions.add(new SelectOption(acc.Id, acc.Name));
		}
	}    
}