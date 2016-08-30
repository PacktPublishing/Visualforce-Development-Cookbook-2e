/*******************************************************************
 * Visualforce Development Cookbook Recipe 1_11
 *
 * Test class for the "Testing a Controller Extension" recipe.
 * Tests the AccountContactsExt class.
 *
 *******************************************************************/
@isTest
private class AccountContactsExtTest 
{
	// test that the contacts are correctly retrieved when the extension
	// controller is constructed
    static testMethod void TestExtensionController() 
    {
    	Account acc=new Account(Name='Unit Test');
    	insert acc;
    	
    	List<Contact> contacts=new List<Contact>();
    	contacts.add(new Contact(FirstName='Unit', LastName='Test', Email='Unit.Test@Unit.Test', AccountId=acc.id));
    	contacts.add(new Contact(FirstName='Unit', LastName='Test 2', Email='Unit.Test2@Unit.Test', AccountId=acc.id));
    	insert contacts;
    	
    	ApexPages.StandardController std=new ApexPages.StandardController(acc);
    	AccountContactsExt controller=new AccountContactsExt(std);
    	
    	System.assertEquals(2, controller.contacts.size());
    }
}