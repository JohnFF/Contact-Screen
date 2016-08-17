<?php

define('UNEMPLOYED_EMPLOYER_CODE', '-1');

/**
 * Student.Setemployer API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 * @return void
 * @see http://wiki.civicrm.org/confluence/display/CRM/API+Architecture+Standards
 */
function _civicrm_api3_student_setemployer_spec(&$spec) {
  $spec['iContactId']['api.required'] = 1;
  $spec['employer_name']['api.required'] = 1;
  $spec['employer_id_field']['api.required'] = 0;
}

/**
 * Student.Setemployer API
 *
 * @param array $params
 * @return array API result descriptor
 * @see civicrm_api3_create_success
 * @see civicrm_api3_create_error
 * @throws API_Exception
 */
function civicrm_api3_student_setemployer($params) {
  // Allows this function to be used for apprenticeship and
  // government scheme employers, as well as 'normal' employers
  if (!array_key_exists('employer_id_field', $params)) {
    $params['employer_id_field'] = 'employer_id';
  }
  elseif (!in_array($params['employer_id_field'], array(
    'employer_id',
    CRM_Contactscreen_Page_ContactView::CUSTOM_FIELD_APPRENT_EMPLOYER,
    CRM_Contactscreen_Page_ContactView::CUSTOM_FIELD_GOV_EMPLOY_PROG,
  ))) {
    watchdog(
      'View and Edit Contact Page',
      "Can't use Student.Setemployer on a field that isn't for an employer ID, params: :params",
      array(
        ':params' => print_r($params, TRUE),
      ),
      WATCHDOG_ERROR
    );
    throw new API_Exception(/*errorMessage*/ "Can't use Student.Setemployer on a field that isn't for an employer ID.", /*errorCode*/ 4);
  }

  if ($params['employer_name'] == UNEMPLOYED_EMPLOYER_CODE) {
    // 'null' didn't work for the custom fields, NULL didn't work for any of them
    $employerId = '';
  }
  else {
    $getEmployerIdParams = array(
      'version' => 3,
      'sequential' => 1,
      'contact_type' => 'Organization',
      'organization_name' => $params['employer_name'],
    );
    $getEmployerIdResults = civicrm_api('Contact', 'get', $getEmployerIdParams);

    if ( civicrm_error($getEmployerIdResults) ) {
      throw new API_Exception(/*errorMessage*/ 'Failed to retrieve organisations.', /*errorCode*/ 1);
    }
      //throw new API_Exception(/*errorMessage*/ 'Retrieved : ' . $getEmployerIdResults['count'], /*errorCode*/ 1);

    if ($getEmployerIdResults['count'] > 0) {
      $employerId = $getEmployerIdResults['values'][0]['id'];
    }
    else {
      $createNewOrganizationParams = array(
        'version' => 3,
        'sequential' => 1,
        'contact_type' => 'Organization',
        'organization_name' => $params['employer_name'],
      );
      $createNewOrganizationResults = civicrm_api('Contact', 'create', $createNewOrganizationParams);

      if ( civicrm_error($createNewOrganizationResults) ) {
        throw new API_Exception(/*errorMessage*/ 'Failed to create new organisation.', /*errorCode*/ 2);
      }

      $employerId = $createNewOrganizationResults['id'];
    }
  }
  
  //  throw new API_Exception(/*errorMessage*/ 'Retrieved emp id : ' . $employerId, /*errorCode*/ 1);
  $updateStudentsEmployerParams = array(
    'version' => 3,
    'sequential' => 1,
    'id' => $params['iContactId'],
    $params['employer_id_field'] => $employerId,
  );

  watchdog(
    'View and Edit Contact Page',
    'Updating employer :params',
    array(
      ':params' => print_r($updateStudentsEmployerParams, TRUE),
    ),
    WATCHDOG_DEBUG
  );

  $updateStudentsEmployerResults = civicrm_api('Contact', 'create', $updateStudentsEmployerParams);


  if ( civicrm_error($updateStudentsEmployerResults) ) {
    watchdog(
      'View and Edit Contact Page',
      'Updating employer result :results',
      array(
        ':results' => print_r($updateStudentsEmployerResults, TRUE),
      ),
      WATCHDOG_ERROR
    );
    throw new API_Exception(/*errorMessage*/ "Failed to update the student's employer.", /*errorCode*/ 3);
  }

  return civicrm_api3_create_success(array(), $params, 'Student', 'Setemployer');
}
