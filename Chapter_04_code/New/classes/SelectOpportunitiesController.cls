/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_7
 *
 * Custom controller for the "Wrapper Classes" recipe.
 * Manages a list of wrapper classes encapsulating an opportunity
 * and selected status.
 *******************************************************************/
public with sharing class SelectOpportunitiesController 
{
	// the managed list of wrapper classes 
	public List<SelectOpportunityWrapper> opps {get; set;}
	
	// constructor
	public SelectOpportunitiesController()
	{
		initialise();
	}
	
	// method to initialise the list of wrapper classes, based on the oldest 10 opportunities
	// in the system
	private void initialise()
	{
		opps=new List<SelectOpportunityWrapper>();
		for (Opportunity opp : [select id, Name, StageName from Opportunity order by CreatedDate limit 10])
		{
			opps.add(new SelectOpportunityWrapper(opp));
		}
	}
	
	// action method to remove the opportunities selected by the user from the list
	public PageReference removeSelected()
	{
		List<SelectOpportunityWrapper> keep=new List<SelectOpportunityWrapper>();
		for (SelectOpportunityWrapper wrap : opps)
		{
			if (!wrap.selected)
			{
				keep.add(wrap);
			}
		}
		
		opps=keep;
		
		return null;
	}
	
	// reset the list to its initial state
	public PageReference reset()
	{
		initialise();
		
		return null;
	}
}