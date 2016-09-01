/*******************************************************************
 * Visualforce Development Cookbook Recipe 1_9
 *
 * Custom controller for the "Launch Page" recipe.
 * Determines if a user has access to the ProtectedContent page.
 *
 *******************************************************************/
public with sharing class LaunchController
{
	// action method executed before the page is rendered - attempts
	// to retrieve the contents of the protected content page and if 
	// successful redirects the user to the protected content page
    public PageReference allowAccess()
    {
        PageReference pr=Page.ProtectedContent;
        try
        {
        	pr.getContent();
        }
        catch (Exception e)
        {
            pr=null;
        }
        
        return pr;
    }
}