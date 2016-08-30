/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_2
 *
 * Custom class to encapsulate a Date property - used in the
 * "Updating Attributes in Component Controllers" recipe.
 *
 *******************************************************************/
public class DateContainer 
{
	// the date encapsulated
	public Date value {get; set;}
	
	// Constructor - takes the date to encapsulate
	public DateContainer(Date inVal)
	{
		value=inVal;
	}
}