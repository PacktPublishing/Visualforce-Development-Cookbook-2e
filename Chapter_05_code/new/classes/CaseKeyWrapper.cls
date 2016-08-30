/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_4
 *
 * Wrapper class for the "Managing a Hierarchy of Records" recipe.
 * Encapsulates a Case record, a unique key for that record, the 
 * associated case comments as wrapper classes and the master value
 * for case comment wrapper class key.
 * Note that record ids cannot be used, as the records may not 
 * have been inserted into the database.
 *******************************************************************/
public with sharing class CaseKeyWrapper 
{
	public Integer key {get; set;}
	public Case cs {get; set;}
	public List<CaseCommentKeyWrapper> comments {get; set;}
	private Integer commentKey=1;
		
	public CaseKeyWrapper(Integer inKey, Case inCs, List<CaseComment> inComments)
	{
		cs=inCs;
		key=inKey;
		
		comments=new List<CaseCommentKeyWrapper>();
		
		if (null!=inComments)
		{
			for (CaseComment cc : inComments)
			{
				comments.add(new CaseCommentKeyWrapper(commentKey++, cc));
			}
		}
	}
	
	public void addComment()
	{
		comments.add(new CaseCommentKeyWrapper(commentKey++, new CaseComment(ParentId=cs.id)));
	}
}