/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_4
 *
 * Wrapper class for the "Managing a Hierarchy of Records" recipe.
 * Encapsulates a CaseComment record and a unique key for that record.
 * Note that the record id cannot be used, as the record may not 
 * have been inserted into the database.
 *******************************************************************/
public with sharing class CaseCommentKeyWrapper 
{
	public Integer key {get; set;}
	public CaseComment comment {get; set;}
		
	public CaseCommentKeyWrapper(Integer inKey, CaseComment inComment)
	{
		key=inKey;
		comment=inComment;
	}
}