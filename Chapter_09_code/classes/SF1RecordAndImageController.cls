public with sharing class SF1RecordAndImageController {
	
	// extension constructor is required for publisher actions
	public SF1RecordAndImageController(ApexPages.StandardController stdCtrl)
	{
	}
	
	@RemoteAction
	public static String SaveCase(String accountId, String subject, String description, String pictureBody) 
	{
		System.debug('### In saveCase');
		
		System.debug(pictureBody);
		Case cs = new Case(AccountId=accountId,
						   Subject=subject, 
						   Description=description,
						   Status='New',
						   Origin='Web');
    	
		insert cs;
			
		if (null!=pictureBody)
		{
			Attachment a = new Attachment();
			a.ParentId = cs.id;
			a.ContentType = 'image/png';
			a.Name = 'CaseImage.png';
			a.Body = EncodingUtil.base64Decode(pictureBody);
			insert a;
		}

		return cs.id;
	}
    
}