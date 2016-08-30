/*******************************************************************
 * Visualforce Development Cookbook Recipe 2_2
 *
 * Custom controller for the "Updating Attributes in Component 
 * Controllers" recipe.  Allows a user to edit the day/month/year
 * components of a date and updates the contained date after an 
 * edit takes place.
 *******************************************************************/
public with sharing class DateEditController 
{
	// the underlying date
	public DateContainer dateContainer;
	
	// the year component of the date
	public Integer year {get; 
 						 set {
						 	    year=value;
						 	    updateContainer();
						     }
					    }

	// the month component of the date
	public Integer month {get; 
 						 set {
							   month=value;
							   updateContainer();
						    }
					     }

	// the day component of the date
	public Integer day {get; 
						set {
							   day=value;
							   updateContainer();
						    }
					   }
	
	// the options for the days select list
	public List<SelectOption> days {get; set;}
									
	// the options for the months select list
	public List<SelectOption> months {get; set;} 

	// the options for the years select list
	public List<SelectOption> years {get; set; }

	// constructor - sets up the select list options
	public DateEditController()
	{
		days=new List<SelectOption>();
		for (Integer idx=1; idx<=31; idx++)
		{
			days.add(new SelectOption(String.valueOf(idx), String.valueOf(idx)));
		}
		
		months=new List<SelectOption>();
		for (Integer idx=1; idx<=12; idx++)
		{
			months.add(new SelectOption(String.valueOf(idx), String.valueOf(idx)));
		}
		
		// the year picklist starts at the current year and goes back 100 years
		years=new List<SelectOption>();
		Integer endYear=System.today().year();
		for (Integer idx=endYear-100; idx<=endYear; idx++)
		{
			years.add(new SelectOption(String.valueOf(idx), String.valueOf(idx)));
		}
	}	
	
	// Getter for the date container property
	public DateContainer getDateContainer()
	{
		return dateContainer;
	}
	
	// Setter for the date container property. Initialises the select lists.
	// If the encapsulated date is null, uses the current date.
	 
	public void setDateContainer(DateContainer dc)
	{
		dateContainer=dc;
		Date cand=dc.value;
		if (null==cand)
		{
			cand=System.today();
		}
		
		day=cand.day();
		month=cand.month();
		year=cand.year();
	}
		
	// the user has changed one of the day/month/year picklist values, so update
	// the date encapsulated by the dateContainer property
	private void updateContainer()
	{
		if ( (null!=year) && (null!=month) && (null!=day) )
		{
			Date theDate=Date.newInstance(year, month, day);
			dateContainer.value=theDate;
		}
	}
}