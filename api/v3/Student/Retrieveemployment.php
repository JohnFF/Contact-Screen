<?php

define('EMPLOYMENT_CUSTOM_FIELDS_INDEX', 0);

/**
 * Student.Retrieveemployment API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 * @return void
 * @see http://wiki.civicrm.org/confluence/display/CRM/API+Architecture+Standards
 */
function _civicrm_api3_student_retrieveemployment_spec(&$spec) {
  $spec['iContactId']['api.required'] = 1;
}


/**
 * Student.Retrieveemployment API
 *
 * @param array $params
 * @return array API result descriptor
 * @see civicrm_api3_create_success
 * @see civicrm_api3_create_error
 * @throws API_Exception
 */
function civicrm_api3_student_retrieveemployment($params) {
  // Access control, members only
  if (!CRM_Contactscreen_Page_ContactView::userIsMember()) {
    throw new API_Exception('This API call is restricted to users with an active membership.');
  }

  // Assert that the contact id exists
  if (array_key_exists('iContactId', $params) && $params['iContactId'] > 0 ) {
    
    $iContactId = (int) $params['iContactId'];
    // Get the Employment Details
    $returnValues = array();
    $returnValues[EMPLOYMENT_CUSTOM_FIELDS_INDEX] = CRM_Contactscreen_Page_ContactView::getCustomEmploymentDetails($iContactId);

    if (!$returnValues) {
      throw new API_Exception(/*errorMessage*/ 'Failed to retrieve employment data.', /*errorCode*/ 4321);
    }
    return civicrm_api3_create_success($returnValues, $params, 'Student', 'retrieveemployment');
  }
  else {
    throw new API_Exception(/*errorMessage*/ 'No Contact found.', /*errorCode*/ 1234);
  }
}
