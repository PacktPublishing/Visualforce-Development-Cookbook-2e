/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_7
 *
 * Custom controller for the "Displaying report data in Visualforce" 
 * recipe. 
 * Executes the report and processes the output 
 *******************************************************************/
public with sharing class AccountsAndContactsReportController 
{
	private static final String REPORT_NAME='VF_Cookbook_Accounts_Contacts';
	private static final String CONTACT_FIRST_NAME='First Name';
	private static final String CONTACT_LAST_NAME='Last Name';
	
	Map<String, List<String>> contactNamesByAccountName {get; set;}
	
	public Map<String, List<String>> getReportDataMap()
	{
		if (null==contactNamesByAccountName)
		{
			// find the report id based on the name
			List <Report> reports = [select Id, DeveloperName 
									 from Report 
									 where DeveloperName = :REPORT_NAME];

			if (!reports.isEmpty())
			{
				Id reportId=reports[0].Id;
				contactNamesByAccountName=runAndProcessReport(reportId);
			}
		}
		
		return contactNamesByAccountName;
	}
	
	// execute the report and process the results into the report data map
	private Map<String, List<String>> runAndProcessReport(Id repId)
	{
		Map<String, List<String>> result=new Map<String, List<String>>();
		
		// run the report synchronously
		Reports.reportResults results = Reports.ReportManager.runReport(repId, true);

		// figure out which detail cells contain the items we are interested in
		Integer fnameIdx=-1;
		Integer lnameIdx=-1;
		
		Reports.ReportMetadata md=results.getReportMetadata();
		List<String> colAPINames=md.getDetailColumns();
		
		for (Integer idx=0; idx<colAPINames.size(); idx++)
		{
			String candName=colAPINames[idx];
			System.debug('API name = ' + candName);
			if ('FIRST_NAME'==candName)
			{
				fnameIdx=idx;
			}
			else if ('LAST_NAME'==candName)
			{
				lnameIdx=idx;
			}
		}
		
		Reports.Dimension dim = results.getGroupingsDown();
		
		// iterate the down-groupings - these will be the accounts that the contacts are grouped
		List<Reports.GroupingValue> groupVals=dim.getGroupings();
		for (Reports.GroupingValue groupVal : groupVals)
		{
			String accountName=groupVal.getLabel();
			
			System.debug('Key: ' + groupVal.getKey());
			System.debug('Label: ' + groupVal.getLabel());
			System.debug('Value: ' + groupVal.getValue());

			String fmKey = groupVal.getKey() + '!T';

			// Get the fact map from the report results
			Reports.ReportFactWithDetails factDetails =
    			(Reports.ReportFactWithDetails) results.getFactMap().get(fmKey);

			// get the total number of contacts (the first summary amount) from the fact map
			Reports.SummaryValue sumVal = factDetails.getAggregates()[0];
			System.debug('Summary Value: ' + sumVal.getLabel());

			List<String> contactNames=new List<String>();
			// iterate the rows, extracting the first name and last name
			for (Reports.ReportDetailRow detailRow : factDetails.getRows())
			{
				String contactName='';
				List<Reports.ReportDataCell> cells=detailRow.getDataCells();
				contactName=cells[fnameIdx].getLabel() + ' ' + cells[lnameIdx].getLabel();
				contactNames.add(contactName);
			}
			
			result.put(accountName, contactNames);
		}
		
		return result;
	}
	
	// Returns the keys from the report data - used by the page to extract the associated contact names list
	public Set<String> getAccountNames()
	{
		return getReportDataMap().keySet();
	}
}