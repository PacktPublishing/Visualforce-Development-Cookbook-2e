/*******************************************************************
 * Visualforce Development Cookbook Recipe 5_4
 *
 * Controller extension for the "Managing a Hierarchy of Records" 
 * recipe.
 * Manages an account, its cases and the comments associated with
 * each case. 
 *******************************************************************/
public with sharing class AccountCasesCommentsEditExt 
{
	// The cases being managed, as wrapper classes so that we can
	// uniquely identify records before they are added to the database
	public List<CaseKeyWrapper> caseWrappers {get; set;}
	
	// the standard controller for the account being managed
	public ApexPages.StandardController stdCtrl {get; set;}
	
	// the master key value for the wrapper class ids
	private Integer key=1;	
	
	// if a user chooses to delete a case, the key for the case in 
	// question will be in this property
	public String caseToDel {get; set;}
	
	// if a user chooses to delete a case comment, the key for the case 
	// and comment in question will be in this property
	public String ccToDel {get; set;}
	
	// if a user chooses to add a comment to a case, the key for the case
	// in question will be in this property
	public String caseToAddCC {get; set;}
	
	// cases the the user has chosen to delete - will be deleted from the
	// database when the user saves their work
	private List<Case> casesToDelete=new List<Case>();
	
	// comments the the user has chosen to delete - will be deleted from the
	// database when the user saves their work
	private List<CaseComment> commentsToDelete=new List<CaseComment>();
	
	// constructor - retrieves the account's cases and their comments and builds
	// the hierarchy of wrapper classes
	public AccountCasesCommentsEditExt(ApexPages.StandardController std)
	{
		stdCtrl=std;
		List<Case> cases=[select id, Status, Subject, 
						  (select id, CommentBody, IsPublished, ParentId from CaseComments) 
						  from Case
						  where AccountId=:stdCtrl.getId()];	

		caseWrappers=new list<CaseKeyWrapper>();
		for (Case cs : cases)
		{
			caseWrappers.add(new CaseKeyWrapper(key++, cs, cs.CaseComments));
		}
	}
	
	// gets the position of a case wrapper record in the list of wrappers
	private Integer getCaseWrapperPos(String keyStr)
	{
		Integer key=Integer.valueOf(keyStr.substring(2));
		Integer result=-1;
		
		Integer index=0;
		for (CaseKeyWrapper cand : caseWrappers)
		{
			if (cand.key==key)
			{
				result=index;
				break;
			}
			else
			{
				index++;
			}
		}
		
		return result;
	}
	
	// locates the case wrapper object associated with a unique key
	private CaseKeyWrapper getCaseWrapper(String keyStr)
	{
		CaseKeyWrapper wrapper=null;
		Integer pos=getCaseWrapperPos(keyStr);
		if (-1!=pos)
		{
			wrapper=caseWrappers.get(pos);
		}
		
		return wrapper;
	}
	
	// gets the position of a case comment wrapper record in the list of wrappers
	// managed by the supplied case wrapper
	private Integer getCaseCommentWrapperPos(String keyStr, CaseKeyWrapper wrapper)
	{
		Integer key=Integer.valueOf(keyStr.substring(2));
		Integer result=-1;
		
		Integer index=0;
		for (CaseCommentKeyWrapper cand : wrapper.comments)
		{
			if (cand.key==key)
			{
				result=index;
				break;
			}
			else
			{
				index++;
			}
		}
		
		return result;
	}
	
	// locates the case comment wrapper object associated with a unique key managed by the
	// supplied case wrapper object
	private CaseCommentKeyWrapper getCaseCommentWrapper(String keyStr, CaseKeyWrapper caseWrapper)
	{
		CaseCommentKeyWrapper wrapper=null;
		Integer pos=getCaseCommentWrapperPos(keyStr, caseWrapper);
		if (-1!=pos)
		{
			wrapper=caseWrapper.comments.get(pos);
		}
		
		return wrapper;
	}
	
	// action method to delete a case
	public PageReference deleteCase()
	{
		Integer pos=getCaseWrapperPos(caseToDel);
		if (-1!=pos)	
		{
			CaseKeyWrapper wrapper=caseWrappers.get(pos);
			if (null!=wrapper.cs.Id)
			{
				casesToDelete.add(wrapper.cs);
			}
			caseWrappers.remove(pos);
		}
		return null;
	}
	
	
	// action method to delete a case comment
	public PageReference deleteCaseComment()
	{
		String[] keyComps=ccToDel.split(':');
		
		Integer pos=getCaseWrapperPos(keyComps[0]);
		if (-1!=pos)	
		{
			CaseKeyWrapper wrapper=caseWrappers.get(pos);
			Integer commentPos=getCaseCommentWrapperPos(keyComps[1], wrapper);
			if (-1!=commentPos)	
			{
				CaseCommentKeyWrapper comWrap=wrapper.comments.get(commentPos);
				
				if (null!=comWrap.comment.Id)
				{
					commentsToDelete.add(comWrap.comment);
				}
				wrapper.comments.remove(commentPos);
			}
		}

		return null;
	}
	
	// action method to add a case
	public PageReference addCase()
	{
		caseWrappers.add(
				new CaseKeyWrapper(key++, 
				      new Case(AccountId=stdCtrl.getId()),
				      null));
				      
		return null;
	}
	
	// action method to add a comment to a case
	public PageReference addCaseComment()
	{
		CaseKeyWrapper wrapper=getCaseWrapper(caseToAddCC);
		if (null!=wrapper)
		{
			wrapper.addComment();
		}
		return null;
	}
	
	// action method to save the user's work
	public PageReference save()
	{
		List<Case> cases=new List<Case>();
		for (CaseKeyWrapper wrapper : caseWrappers)
		{
			cases.add(wrapper.cs);
		}

		upsert cases;
		
		List<CaseComment> caseComments=new List<CaseComment>();
		for (CaseKeyWrapper wrapper : caseWrappers)
		{
			for (CaseCommentKeywrapper ccWrapper : wrapper.comments)
			{	
				CaseComment comment=ccWrapper.comment;
				if (null==comment.ParentId)
				{
					comment.parentId=wrapper.cs.id;
				}
				caseComments.add(comment);
			}	
		}
		
		upsert caseComments;
		
		delete casesToDelete; 
		delete commentsToDelete; 
		
		return stdCtrl.save();
	}
	
}