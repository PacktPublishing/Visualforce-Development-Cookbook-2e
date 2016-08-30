/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_7
 *
 * Custom class to encapsulate a String property - used in the
 * "Multi-Select Related Controller" recipe.
 *******************************************************************/
public with sharing class StringContainer 
{
	// the string encapsulated
	public String value {get; set;}
	
	// Constructor - takes the string to encapsulate
	public StringContainer(String inVal)
	{
		value=inVal;
	}
}