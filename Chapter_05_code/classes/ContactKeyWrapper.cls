/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_2
 *
 * Wrapper class for the "Managing a List of Records" recipe.
 * Encapsulates a Contact record and a unique key for that record. 
 * Note that the record id cannot be used, as the record may not 
 * have been inserted into the database.
 *******************************************************************/
public with sharing class ContactKeyWrapper 
{
	public Integer key {get; set;}
	public Contact cont {get; set;}
		
	public ContactKeyWrapper(Integer inKey, Contact inCont)
	{
		key=inKey;
		cont=inCont;
	}
}