/*******************************************************************
 * Visualforce Development Cookbook Recipe 1_2
 *
 * Custom controller for the "Turning off an Action Poller" recipe.
 * Simulates the progression of a payment through various states.
 *
 *******************************************************************/
public with sharing class PollerController 
{
	// the payment states
    public List<String> states=new List<String>{
      'Connecting to Bank', 'Authorising', 
      'Authorised', 'Complete'};
    
    // the index of the current state
    private Integer stateIdx=0;
    
    // getter to retrieve the current state
    public String getPaymentState()
    {
       return states[stateIdx];
    }
        
    // action method invoked by the poller - increments the 
    // current state index
    public PageReference movePayment() 
    {
        stateIdx++;
        return null;
    }
}