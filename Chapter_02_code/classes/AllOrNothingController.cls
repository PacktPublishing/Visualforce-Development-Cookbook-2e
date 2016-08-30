/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_5
 *
 * Custom controller for the "Custom Iterator Component" recipe. 
 * Determines if a list should be rendered.
 *******************************************************************/
public with sharing class AllOrNothingController
{
	// the list to decide upon rendering
	public List<Sobject> values {get; set;}
	
	// should the list be rendered?  Returns true if the list has 
	// any values, otherwise false
	public Boolean getRender()
	{
		return (null!=values && !values.isEmpty());
	}
}