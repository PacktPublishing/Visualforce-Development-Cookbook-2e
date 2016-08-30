/*******************************************************************
 * Visualforce Development Cookbook Recipe 4_3
 *
 * Extension controller for the "Attach an Image to a Record" recipe.
 * Manages an attachment and saves against the record managed
 * by the parent standard controller.
 *******************************************************************/
public with sharing class AddImageExt 
{
	// the attachment being managed by this controller
	public Attachment att {get; set;}
	
	// the id of the record that will parent the attachment
	private Id parentId {get; set;}
	
	// constructor - extracts the record id from the standard controller
	public AddImageExt(ApexPages.StandardController std)
	{
		att=new Attachment();
		parentId=std.getId();
	}
	
	// action method to save the attachment
	public void uploadImage()
	{
		att.parentId = parentId;
		att.Name='image';
		insert att;
		
		att=new Attachment();
	}
	
	// get the id of the latest attachment with the name of 'image'
	public Id getImageId()
	{
		Id result=null;
		List<Attachment> images=[select id from Attachment where Name='image' and parentId=:parentId order by CreatedDate DESC];
		if (images.size()>0)
		{
			result=images[0].id;
		}
		
		return result;
	}
}