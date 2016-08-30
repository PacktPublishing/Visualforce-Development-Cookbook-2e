public with sharing class SF1SignHereController {
	@RemoteAction
	public static String SaveLead(String firstName, String lastName, String company, 
	       						  String email, String pictureBody) 
	{
		try
		{
			System.debug(pictureBody);
			Lead ld = new Lead(FirstName=firstName, 
							   LastName=lastName,
							   Company=company,
							   Email=email);
    	
			insert ld;
			
			if (null!=pictureBody)
			{
				Attachment a = new Attachment();
				a.ParentId = ld.id;
				a.ContentType = 'image/png';
				a.Name = 'LeadSignature.png';
				a.Body = EncodingUtil.base64Decode(pictureBody);
				insert a;
			}

			return 'SUCCESS';
		}
		catch(Exception e)
		{
			System.debug('### Exception ' + e.getMessage() + ' at ' + e.getStackTraceString());
			return 'Exception occurred' + e.getMessage();
		}
	}
}