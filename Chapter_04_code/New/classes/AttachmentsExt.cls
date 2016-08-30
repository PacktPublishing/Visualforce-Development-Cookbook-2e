/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_4
 *
 * Extension controller for the "Managing Attachments" recipe.
 * Allows attachments to be added to the record managed
 * by the parent standard controller. Deletes attachments based on
 * user selections from the associated Visualforce page
 *******************************************************************/
public with sharing class AttachmentsExt 
{
	// the managed attachment
	public Attachment att {get; set;}
	
	// the id of the attachment selected by the user
	// to delete
	public String selectedAttachmentId {get; set;}
	
	// the id of the record that parents the attachments
	private Id recordId;

	// constructor - extracts the id of the parent record from
	// the standard controller
	public AttachmentsExt(ApexPages.StandardController std)
	{
		recordId=std.getId();
		att=new Attachment();
	}
   
	// action method to upload an attachment
	public PageReference upload() 
	{
		if (String.IsBlank(att.name))
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a file to attach'));
			return null;
		}

		att.ParentId = recordId;
		insert att;
		
		// instantiate a new attachment to allow the user to attach another
		att=new Attachment();

		PageReference result=ApexPages.CurrentPage();
		result.setRedirect(true);
		return result;
	}
   
	// action method to delete an attachment based on the user's selection
	public PageReference deleteAttachment()
	{
		// if the user hasn't chosen an attachment, do nothing
		if (!String.IsBlank(selectedAttachmentId))
		{
			List<Attachment> attachments=[select id, name, parentId 
   	                                              from Attachment
   	                                              where Id = :selectedAttachmentId];
   	                                              
			if (attachments.size()==1)
			{
				delete attachments[0];
			}	
		}
		
		PageReference result=ApexPages.CurrentPage();
		result.setRedirect(true);
		return result;
   }
}