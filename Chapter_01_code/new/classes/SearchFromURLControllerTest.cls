/*******************************************************************
 * Visualforce Development Cookbook Recipe 1_10
 *
 * Test class for the "Testing a Custom Controller" recipe.
 * Tests the SearchFromURLController class
 *
 *******************************************************************/
@isTest
private class SearchFromURLControllerTest 
{
	// test searching when the search term appears on the URL
    static testMethod void SearchFromURLTest() 
    {
    	// insert the test data
    	List<Account> accs=new List<Account>();
    	accs.add(new Account(Name='Unit Test'));
    	accs.add(new Account(Name='Unit Test 2'));
    	accs.add(new Account(Name='The Test Account'));
    	insert accs;
    	
    	PageReference pr=Page.SearchFromURL;
    	pr.getParameters().put('name', 'Unit');
    	
    	Test.setCurrentPage(pr);
    	
    	SearchFromURLController controller=new SearchFromURLController();
    	System.assertEquals(true, controller.searched);
    	System.assertEquals(2, controller.accounts.size());   
    }

	// test searching when the user enters a value
    static testMethod void SearchSubmitted() 
    {
    	List<Account> accs=new List<Account>();
    	accs.add(new Account(Name='Unit Test'));
    	accs.add(new Account(Name='Unit Test 2'));
    	accs.add(new Account(Name='The Test Account'));
    	insert accs;
    	
    	SearchFromURLController controller=new SearchFromURLController();
    	System.assertEquals(false, controller.searched);
    	controller.name='Unit';
    	System.assertEquals(null, controller.executeSearch());
    	System.assertEquals(2, controller.accounts.size());   
    }
}