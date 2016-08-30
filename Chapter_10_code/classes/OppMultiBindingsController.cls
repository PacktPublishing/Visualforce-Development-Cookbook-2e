/*******************************************************************
 * Visualforce Development Cookbook Recipe 10_3
 *
 * Custom controller for the "Multiple bindings to the same record" 
 * recipe.
 *
 *******************************************************************/
public with sharing class OppMultiBindingsController 
{
	// list of wrappers to be iterated in the page
	public List<OppWrap> oppWraps {get; set;}
    
    // constructor
    public OppMultiBindingsController()
    {
    	oppWraps=new List<OppWrap>();
    	
    	for (Opportunity opp : [select id, Name, StageName, Amount 
    							from Opportunity
    							limit 10])
		{
			oppWraps.add(new OppWrap(opp));
		}
    }
    
    // saves the changes to the records
    public PageReference save()
    {
    	List<Opportunity> toUpdate=new List<Opportunity>();
    	
    	for (OppWrap oppWrap : oppWraps) 
    	{
    		oppWrap.opp.StageName=oppWrap.carrier.StageName;
    		toUpdate.add(oppWrap.opp);
    	}
    	
    	update toUpdate;
    	
    	return null;
    }   
    
    // opportunity and carrier wrapper class
    public class OppWrap
    {
    	// wrapper opportunity
    	public Opportunity opp {get; set;}
    	
    	// carrier opportunity to allow updates to be captured
    	public Opportunity carrier {get; set;}
    	
    	// constructor
    	public OppWrap(Opportunity inOpp)
    	{
    		opp=inOpp;
    		carrier=new Opportunity();
    	}
    } 
}