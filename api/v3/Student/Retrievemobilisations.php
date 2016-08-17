<?php

/**
 * Student.Retrievemobilisations API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 * @return void
 * @see http://wiki.civicrm.org/confluence/display/CRM/API+Architecture+Standards
 */
function _civicrm_api3_student_retrievemobilisations_spec(&$spec) {
  $spec['iContactId']['api.required'] = 1;
}

/**
 * Student.Retrievemobilisations API
 *
 * @param array $params
 * @return array API result descriptor
 * @see civicrm_api3_create_success
 * @see civicrm_api3_create_error
 * @throws API_Exception
 */
function civicrm_api3_student_retrievemobilisations($params) {
  // Access control, members only
  if (!CRM_Contactscreen_Page_ContactView::userIsMember()) {
    throw new API_Exception('This API call is restricted to users with an active membership.');
  }

  if (array_key_exists('iContactId', $params)) {
    
    if ( !$params['iContactId'] ) {
      throw new API_Exception(/*errorMessage*/ 'No Contact found.', /*errorCode*/ 1234);
    }
    $iContactId = (int) $params['iContactId'];
    
    // Get the mobilisations for a specific contact
    $mobilisations = CRM_Futurefirst_Page_AJAX::buildProfileDisplay($iContactId);    
    
    foreach ($mobilisations as $eachMobilisation) {
      // Core APIs unescape their output, we'll escape it on display
      $eachMobilisation['displayString'] = html_entity_decode($eachMobilisation['displayString']);
      $returnValues[] = $eachMobilisation;
    }    
    return civicrm_api3_create_success($returnValues, $params, 'Student', 'retrievemobilisations');
  } 
  else {
    throw new API_Exception(/*errorMessage*/ 'Missing contact id', /*errorCode*/ 1);
  }
}

