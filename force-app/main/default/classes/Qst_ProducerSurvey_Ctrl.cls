public without sharing class Qst_ProducerSurvey_Ctrl {
    
	public String contactId {get; set;}
	public String xmldata{get; set;}

	public multiselectinput[] inputs { get; set; }
	
	public Qst_ProducerSurvey_Ctrl(){
    	 inputs = new multiselectinput[]{};  	
    
    	User user = [Select ContactId from User where Id = :UserInfo.getUserId()];
    	this.contactId = user.ContactId;
    			
		// Set static XML data to initialize survey component
		this.xmldata = '<?xml version="1.0" encoding="UTF-8"?><questionaire><questions>		<question identifier="q1"><type>InputText</type><questionText>How satisfied are you with the purchase you made (of a product or service)?</questionText>			<answers/>		</question>		<question identifier="q2">			<type>InputText</type>			<questionText>How satisfied are you with the service you received?</questionText>			<answers/>		</question>		<question identifier="q3">			<type>InputText</type>			<questionText>How satisfied are you with our company overall?</questionText>			<answers/>		</question>		<question identifier="q4">			<type>InputText</type>			<questionText>担当プロデューサーはいかがでした？</questionText>			<answers/>		</question>		<question identifier="q5">			<type>InputText</type>			<questionText>How likely are you to buy from us again?</questionText>			<answers/>		</question>		<question identifier="q6">			<type>InputText</type>			<questionText>How likely are you to recommend our product/service to others?</questionText>			<answers/>		</question>		<question identifier="q6">			<type>InputText</type>			<questionText>How likely are you to recommend our company to others?</questionText>			<answers/>		</question>				</questions></questionaire>';

		List<Qst_Survey_Question__c> sqList = [select Id, Name, Qst_Survey__c, Question_Text__c, Rating__c from Qst_Survey_Question__c order by Name];
		String strXML = '<?xml version="1.0" encoding="UTF-8"?><questionaire><questions>';
		for (Qst_Survey_Question__c sq : sqList){
			strXML += '<question identifier="'+ sq.Id +'"><type>InputText</type><questionText>';
			strXML += sq.Question_Text__c;
			strXML += '</questionText><answers/></question>';
			
			multiselectinput msi = new multiselectinput();
			msi.question = sq.Question_Text__c;
			inputs.add(msi);
			
		}
		strXML += '</questions></questionaire>';
		
		if (sqList != null && sqList.size() > 0)
			this.xmldata = strXML;
		
	}
	public List<Qst_Survey_Question__c> getQuestionList(){
    	User user = [Select ContactId from User where Id = :UserInfo.getUserId()];
    	this.contactId = user.ContactId;
		List<Qst_Survey_Question__c> sqList = [select Id, Name, Qst_Survey__c, Question_Text__c, Rating__c from Qst_Survey_Question__c order by Name];
		return sqList;		
	}
	public String getCurrentSessionId(){
		System.debug('### Get session ID. For Sites Portal users');
		return UserInfo.getSessionId();
	}
	
	public List<SelectOption> getItems() {
		List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1','1')); 
        options.add(new SelectOption('2','2')); 
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5')); 
        return options; 
    }
                   
	public PageReference saveSurvey(){
		String s = '';
		List<Qst_Survey_Result__c> surveyResultList_c = new List<Qst_Survey_Result__c>(); 
			
		for (multiselectinput msi : inputs){
			s += ' Q. '+msi.question+' - '+msi.values;	
			// Collect all results
			Qst_Survey_Result__c sr = new Qst_Survey_Result__c();
			sr.ContactId__c = this.contactId;
			sr.Question_Text__c = msi.question; 
			sr.Rating__c = msi.values;
			surveyResultList_c.add(sr);
		}	
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Survey is completed, thank you.'));
		insert surveyResultList_c;
		
		//PageReference pageRef = Page.MPN_Portal_Top_Page;
    	//pageRef.setRedirect(true);
    	//return pageRef;
    	return null;
    }	
	
	
	public class multiselectinput {
        public String values { get; set; }
        public String question { get; set; }
        
        public multiselectinput() {
            //values = new String[]{};
        }    
    }

}