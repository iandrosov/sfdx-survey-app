global class Qst_ProducerSurveyUtil {

	private Integer heapSizeLimit;
  	private String errMsg_heapSize;
	private List<Qst_Survey_Result__c> surveyResultList_c = new List<Qst_Survey_Result__c>(); 
	private List<SurveyResult> surveyResultList = new List<SurveyResult>();
	private String contactId;
	  
       webService static String testAction(String xmldata, String contactId) {
		String str = 'Action execute:';
		System.debug('### FLEX Action - '+xmldata);
		// Parse XML data here and save to SFDC
    	
    	Qst_ProducerSurveyUtil psu = new Qst_ProducerSurveyUtil();		
		psu.processXML(xmldata, contactId);
		
		return str;
       }
       
       
  //-----------------------------------------------------------------------------//
  // Parse input file
  //-----------------------------------------------------------------------------//
  public String processXML(String xmlString, String cid) {
    XmlStreamReader xsr = new XmlStreamReader(xmlString);
		this.heapSizeLimit = Limits.getLimitHeapSize();
    	this.errMsg_heapSize = 'Too much data to upload. Please try with less data to upload.';
    this.contactId = cid;
    while (xsr.hasNext()) {
      if (xsr.getLocalName() == 'question' && xsr.getEventType() == XmlTag.START_ELEMENT) {
        // Throw exception if heap size limit may be reached
        if (Limits.getHeapSize() > heapSizeLimit)
          throw new ClassException(errMsg_heapSize);
        
        surveyResultList.add(getSurveyResult(xsr));
      }
      xsr.next();
    }
    String out_err = '';
                            
    if (surveyResultList_c.size() > 0)
        insert surveyResultList_c;
    
    return out_err;
  }       

  //-----------------------------------------------------------------------------//
  // Make MPN_Survey_Result__c objects from data of XML file
  //-----------------------------------------------------------------------------//
  private SurveyResult getSurveyResult(XmlStreamReader xsr) {
    Qst_Survey_Result__c surveyResult_c = new Qst_Survey_Result__c();
    SurveyResult surveyResult = new SurveyResult(surveyResult_c);
    
    while (xsr.hasNext()) {
      if (xsr.getLocalName() == 'question' && xsr.getEventType() == XmlTag.END_ELEMENT) {
        	break;
      }
      
      if (xsr.getLocalName() == 'questionText' && xsr.getEventType() == XmlTag.START_ELEMENT) {
          xsr.next();
          if (xsr.getEventType() == XmlTag.CHARACTERS) {
          	surveyResult_c.Question_Text__c = xsr.getText();
          }
      }  
      if (xsr.getLocalName() == 'answers' && xsr.getEventType() == XmlTag.START_ELEMENT) {
          xsr.next();
          if (xsr.getEventType() == XmlTag.CHARACTERS) {
          	surveyResult_c.Rating__c = xsr.getText();
          }
      }  
              
      xsr.next();
    }
    System.debug('### XML parsing Contact ID - '+this.contactId);
    surveyResult_c.ContactId__c = this.contactId;
    surveyResultList_c.add(surveyResult_c);
    return surveyResult;
  }

// private exception class
  private class ClassException extends Exception {}
  
	private class SurveyResult {
    	private Qst_Survey_Result__c surveyRes;
    
    	public SurveyResult(Qst_Survey_Result__c custRes) {
      		this.surveyRes = custRes;
    	}
       
    	public void setSurveyRes(Qst_Survey_Result__c custRes) {
      		this.surveyRes = custRes;
    	}
    
    	public Qst_Survey_Result__c getSurveyRes() {
      		return this.surveyRes;
    	}
  }

}