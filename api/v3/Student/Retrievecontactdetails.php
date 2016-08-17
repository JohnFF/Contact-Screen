<?php
define('CONTACT_DETAILS_COUNTRY_LIST_INDEX',  0);
define('CONTACT_DETAILS_ADDRESS_INDEX',       1);
define('CONTACT_DETAILS_PHONES_INDEX',        2);
define('CONTACT_DETAILS_EMAILS_INDEX',        3);
define('CONTACT_DETAILS_SOCIAL_MEDIA_INDEX',  4);
/**
 * Student.Retrievecontactdetails API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 * @return void
 * @see http://wiki.civicrm.org/confluence/display/CRM/API+Architecture+Standards
 */
function _civicrm_api3_student_retrievecontactdetails_spec(&$spec) {
  $spec['iContactId']['api.required'] = 1;
}

/**
 * Student.Retrievecontactdetails API
 *
 * @param array $requestParams
 * @return array API result descriptor
 * @see civicrm_api3_create_success
 * @see civicrm_api3_create_error
 * @throws API_Exception
 */
function civicrm_api3_student_retrievecontactdetails($requestParams) {
  if ( $requestParams['iContactId'] > 0 ) {
    
    $returnValues = array();
    CRM_Contactscreen_Page_ContactView::getCountryList( $returnValues[CONTACT_DETAILS_COUNTRY_LIST_INDEX] );
    $returnValues[CONTACT_DETAILS_ADDRESS_INDEX] = CRM_Contactscreen_Page_ContactView::buildContactDetails_AddressInfo($requestParams['iContactId']);
    $returnValues[CONTACT_DETAILS_PHONES_INDEX]  = CRM_Contactscreen_Page_ContactView::buildContactDetails_PhoneNumbersInfo($requestParams['iContactId']);
    $returnValues[CONTACT_DETAILS_EMAILS_INDEX]  = CRM_Contactscreen_Page_ContactView::buildContactDetails_EmailAddressesInfo($requestParams['iContactId']);
    $returnValues[CONTACT_DETAILS_SOCIAL_MEDIA_INDEX]  = CRM_Contactscreen_Page_ContactView::buildContactDetails_SocialMediaInfo($requestParams['iContactId']);
    
    return civicrm_api3_create_success($returnValues, $requestParams, 'Student', 'retrievecontactdetails');
  }
  else {
    throw new API_Exception(/*errorMessage*/ "Retrieve Contact details invalid contact Id: " . $requestParams['iContactId'] , /*errorCode*/ 1234);
  }
}

