/*******************************************************************
 * Visualforce Development Cookbook Recipe 9_3
 *
 * Custom controller for the "Capturing the User's Location" recipe.
 * Provides a remote method to save a lead, including geolocation.
 *******************************************************************/
public with sharing class SF1CaptureLocationController 
{
    @RemoteAction
    public static String CreateLead(String fName, String lName, 
                                    String inCompany, String inEmail, 
                                    Double latitude, Double longitude)
    {
        Lead newLead=new Lead(FirstName=fName,
                              LastName=lName,
                              Company=inCompany,
                              Email=inEmail);
                                       
        // geolocation may have failed, so only set these fields if they are defined
        if (null!=latitude)
        {
            newLead.Location__Latitude__s=latitude;
            newLead.Location__Longitude__s=longitude;
        }

        insert newLead;
        
        return 'SUCCESS';
    }
    
}