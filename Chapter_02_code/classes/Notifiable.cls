/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_8
 *
 * Interface for a notifiable class. Used in the "Notify Containing 
 * Page Controller" recipe.
 *******************************************************************/
public interface Notifiable 
{
	// Method to notify the implementing class of a noteworthy event
	// taking place.
	void notify(String detail);
}