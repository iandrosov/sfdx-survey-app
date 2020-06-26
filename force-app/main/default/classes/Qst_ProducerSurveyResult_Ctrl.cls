public without sharing class Qst_ProducerSurveyResult_Ctrl {
	public Qst_ProducerSurveyResult_Ctrl(){
		String xml_data = ApexPages.currentPage().getParameters().get('xmlresult');
		String contactId = ApexPages.currentPage().getParameters().get('contact');
		if (xml_data != null && xml_data.length() > 0 && contactId != null)
			Qst_ProducerSurveyUtil.testAction(xml_data, contactId); 
	}

}