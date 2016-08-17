<?php

/**
 * Student.Retrievenotes API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 * @return void
 * @see http://wiki.civicrm.org/confluence/display/CRM/API+Architecture+Standards
 */
function _civicrm_api3_student_retrievenotes_spec(&$spec) {
  $spec['iLoggedInUser']['api.required'] = 1;
  $spec['iContactId']['api.required'] = 1;
}

/**
 * Student.Retrievenotes API
 *
 * @param array $params
 * @return array API result descriptor
 * @see civicrm_api3_create_success
 * @see civicrm_api3_create_error
 * @throws API_Exception
 */
function civicrm_api3_student_retrievenotes($params) {
  // Access control, members only
  if (!CRM_Contactscreen_Page_ContactView::userIsMember()) {
    throw new API_Exception('This API call is restricted to users with an active membership.');
  }

  
  if ( $params['iContactId'] > 0 && $params['iLoggedInUser'] > 0 ) {
    $aGetNotesParams = array(
      'version' => 3,
      'sequential' => 1,
      'entity_id' => $params['iContactId'],
      'privacy' => '0',
    );
    $aGetNotesResults = civicrm_api('Note', 'get', $aGetNotesParams);
    
    if (civicrm_error($aGetNotesResults)) {
      throw new API_Exception(/*errorMessage*/ "Retrieve Notes failed " . print_r($aGetNotesResults, TRUE), /*errorCode*/ 1);
    }
    else if ($aGetNotesResults['count'] == 0) {
      return civicrm_api3_create_success(array(), $params, 'Student', 'retrievenotes');
    }    
    $aUsersWithAccess = CRM_Contactscreen_Page_ContactView::getUsersWithAccess($params['iLoggedInUser']);
    $returnValues = array();
    foreach ($aGetNotesResults['values'] as $key => $aNote) {
      // in the note data structure - contact_id is the author, entity_id is the contact the note's about
      if (in_array($aNote['contact_id'], $aUsersWithAccess)) {
        // if we don't have access to the note, remove it from the list
        $returnValues[] = CRM_Contactscreen_Page_ContactView::filterNoteData($aNote);
      }
    }
    
   
    return civicrm_api3_create_success($returnValues, $params, 'Student', 'retrievenotes');
  }
  else {
    throw new API_Exception(/*errorMessage*/ "Retrieve Notes invalid ids contact: " . $params['iContactId']  . " logged in user:" . $params['iLoggedInUser'], /*errorCode*/ 1234);
  }
}

