<?php

/**
 * Student.Retrievecustomquestionanswers API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 * @return void
 * @see http://wiki.civicrm.org/confluence/display/CRM/API+Architecture+Standards
 */
function _civicrm_api3_student_retrievecustomquestionanswers_spec(&$spec) {
  $spec['iContactId']['api.required'] = 1;
  $spec['schoolId']['api.required']   = 1;
}
  
/**
 * Student.Retrievecustomquestionanswers API
 *
 * @param array $params
 * @return array API result descriptor
 * @see civicrm_api3_create_success
 * @see civicrm_api3_create_error
 * @throws API_Exception
 */
function civicrm_api3_student_retrievecustomquestionanswers($params) {
  // Access control, members only
  if (!CRM_Contactscreen_Page_ContactView::userIsMember()) {
    throw new API_Exception('This API call is restricted to users with an active membership.');
  }

  if ( array_key_exists('iContactId', $params) && $params['iContactId'] > 0 ) {
    if ( !array_key_exists('schoolId', $params) || $params['schoolId'] < 0 ){
      throw new API_Exception(/*errorMessage*/ 'No School found.', /*errorCode*/ 1234);
    }
    // Filter the values
    $schoolId = (int) $params['schoolId'];
    $iContactId = (int) $params['iContactId'];
    
    $returnValues = array();
    // Get the Custom Question Group for the school
    $schoolCustomQuestionData = CRM_Contactscreen_Page_ContactView::getSchoolActiveCustomQuestionData($schoolId);
    if ( !$schoolCustomQuestionData ){
      throw new API_Exception(/*errorMessage*/ 'No Custom Questions Detected.', /*errorCode*/ 1234);
    }
    // Get the active custom questions
    $schoolActiveCustomQuestions = CRM_Contactscreen_Page_ContactView::getActiveCustomQuestions($schoolCustomQuestionData['id']);
    if ( !$schoolActiveCustomQuestions ){
      throw new API_Exception(/*errorMessage*/ 'No Active Custom Questions Detected.', /*errorCode*/ 1234);
    }
    // For each active custom question get the student answer
    foreach ( $schoolActiveCustomQuestions['values'] as $aValue ){
     
      $questionAnswer = CRM_Contactscreen_Page_ContactView::getCustomQuestionAnswer($iContactId, $aValue);
     
      $returnValues[] = array(
        'id'        => $aValue['id'],
        'label'     => $aValue['label'],        
        'answer'    => $questionAnswer,
        'html_type' => $aValue['html_type'],
      ); 
    }    
    return civicrm_api3_create_success($returnValues, $params, 'Student', 'retrievecustomquestionanswers');
  } 
  else {
    throw new API_Exception(/*errorMessage*/ 'No Contact found.', /*errorCode*/ 1234);
  }
}

