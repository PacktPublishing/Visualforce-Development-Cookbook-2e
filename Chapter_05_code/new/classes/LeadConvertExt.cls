/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_3
 *
 * Controller extension for the "Lead Conversion Page" recipe.
 * Converts a lead to an account, contact and opportunity via Apex.
 * Sets additional information into the opportunity based on 
 * user selections from the associated Visualforce page.
 *******************************************************************/
public with sharing class LeadConvertExt 
{
	// Carrier object for the account and contact informatin
	public Case carrier {get; set;}
	
	// Carrier object for the opportunity fields
	public Opportunity opp {get; set;}
	
	// The status to set on the lead once it is converted
	public String convertedStatus {get; set;}
	
	// Should a new account be created?
	public Boolean newAccount {get; set;}
	
	// Should a new contact be created?
	public Boolean newContact {get; set;}
	
	// The standard controller being extended
	private ApexPages.StandardController stdCtrl;
	
	// Constructor
	public LeadConvertExt(ApexPages.StandardController std)
	{
		carrier=new Case();
		opp=new Opportunity();
		stdCtrl=std;
	}
	
	// Get the lead status options available for converted leads
	public List<SelectOption> getConvertedOptions()
	{
		List<SelectOption> result=new List<SelectOption>();
		List<LeadStatus> states=[select id, MasterLabel from LeadStatus where IsConverted=true];
           
		for (LeadStatus state : states)
		{
			if (null==convertedStatus)
			{
				convertedStatus=state.MasterLabel;
			}
         
			SelectOption option=new SelectOption(state.MasterLabel, state.MasterLabel);
			result.add(option); 
		}
		
		return result;
	}
	
	// Action method to convert the lead
	public PageReference convertLead()
	{
		PageReference result=null;
		
		Database.LeadConvert leadConvert=new Database.LeadConvert();
		String errorMsg='';
      
        // set the account to merge with, if defined
		if (null!=carrier.AccountId)
		{
			leadConvert.setAccountId(carrier.AccountId);
		}
         
        // set the contact to merge with, if defined
		if (null!=carrier.ContactId)
		{
			leadConvert.setAccountId(carrier.AccountId);
		}
      
		leadConvert.setConvertedStatus(convertedStatus);
		
		// create an opportunity if the user has provided a name for it
		if (String.IsBlank(opp.Name))
		{
			leadConvert.setDoNotCreateOpportunity(true);
		}
		else
		{
			leadConvert.setOpportunityName(opp.Name);
		}
		
		leadConvert.setLeadId(stdCtrl.getId());
      
		try
		{
			Database.LeadConvertResult convertResult=Database.convertLead(leadConvert);
			if (!convertResult.isSuccess())
			{
				// if there were errors, add these to the page
				for (Database.Error error : convertResult.getErrors())
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error.getMessage()));
				}
			}
			else
			{
				if (!String.IsBlank(opp.Name))
				{
   					// update the opportunity and send the user to that
					Opportunity newOpp=[select id from Opportunity where id=:convertResult.getOpportunityId()];
					if (!String.IsBlank(opp.StageName))
					{
						newOpp.StageName=opp.StageName;
					}
					if (null!=opp.Amount)
					{
						newOpp.Amount=opp.Amount;
					}
					
					update newOpp;
					result=new PageReference('/' + convertResult.getOpportunityId());
				}
				else
				{
					// send the user to the account
					result=new PageReference('/' + convertResult.getAccountId());
				}
			}
		}
		catch (DMLException exc)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, exc.getMessage()));
		}
		
		return result;
	}
}