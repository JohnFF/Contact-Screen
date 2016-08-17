<?php

require_once 'CRM/Core/Page.php';

class CRM_Contactscreen_Page_ContactView extends CRM_Core_Page {

  CONST FUTURE_FIRST_CIVICRM_ID = 7763;

  CONST DROPDOWN_SELECT_DEFAULT_VALUE = -1;

  CONST SCHOOL_IS_RELATIONSHIP_TYPE_ID    = 21;
  CONST MAIN_CONTACT_RELATIONSHIP_TYPE_ID = 10;
  CONST EMPLOYEE_OF_RELATIONSHIP_TYPE_ID  = 4;

  CONST ACTIVITY_ID_EMAIL = 2;
  CONST ACTIVITY_ID_PHONE_CALL = 3;

  CONST DO_NOT_CONTACT_PHONE_TYPE_ID = 9;

  CONST RELATIONSHIP_LEAVING_YEAR_INDEX           = 'custom_111';
  CONST RELATIONSHIP_LEAVING_YEAR_GROUP_INDEX     = 'custom_259';
  CONST RELATIONSHIP_HOW_WANT_TO_HELP_INDEX       = 'custom_112';
  CONST RELATIONSHIP_HOW_WANT_TO_HELP_OTHER_INDEX = 'custom_113';

  CONST HOW_WANT_TO_HELP_OPTION_GROUP_ID = 92;

  CONST LEAVING_YEAR_EARLIEST   = 1900;
  CONST LEAVING_YEAR_TOP_OFFSET = 4;

  CONST EMPLOYMENT_CUSTOM_GROUP_ID = 13;

  // Employment custom data.
  CONST CUSTOM_FIELD_EMPLOYMENT_STATUS_INDEX         = 'custom_37';
  CONST CUSTOM_FIELD_EMPLOYMENT_STATUS_OTHER_INDEX   = 'custom_39';
  CONST CUSTOM_FIELD_EMPLOYMENT_SECTOR_INDEX         = 'custom_44';
  CONST CUSTOM_FIELD_VOLUNTARY_WORK_INDEX            = 'custom_65';
  CONST CUSTOM_FIELD_GOVERNMENT_EMPLOYMENT_PROG_NDEX = 'custom_71';
  // Government scheme employer, actually in education group, should be under employment
  CONST CUSTOM_FIELD_GOV_EMPLOY_PROG                 = 'custom_78';
  CONST CUSTOM_FIELD_GOV_EMPLOY_DETAILS              = 'custom_326';
  CONST CUSTOM_FIELD_CAREER_HISTORY                  = 'custom_282';
  CONST CUSTOM_FIELD_PREVIOUS_NAME                   = 'custom_262';

  // Education custom data.
  CONST CUSTOM_FIELD_EDUCATION_SUMMARY      = 'custom_41';
  CONST CUSTOM_FIELD_A_LEVELS               = 'custom_45';
  CONST CUSTOM_FIELD_FURTHER_EDUCATION      = 'custom_46';
  CONST CUSTOM_FIELD_POSTGRAD_INSTITUTION   = 'custom_48';
  CONST CUSTOM_FIELD_UNDERGRAD_INSTITUTION  = 'custom_49';
//  CONST CUSTOM_FIELD_POSTGRAD_SUBJECT       = 'custom_50';
  CONST CUSTOM_FIELD_POSTGRAD_SUJECT_OTHER  = 'custom_52';
  CONST CUSTOM_FIELD_UNDERGRAD_SUJECT_OTHER = 'custom_53';
//  CONST CUSTOM_FIELD_UNDERGRAD_SUJECT       = 'custom_54';
  CONST CUSTOM_FIELD_POSTGRAD_INST_OTHER    = 'custom_55';
  CONST CUSTOM_FIELD_UNDERGRAD_INST_OTHER   = 'custom_56';
  CONST CUSTOM_FIELD_CURR_EDU_EXPECT_FINISH = 'custom_57';
  CONST CUSTOM_FIELD_CURR_OCCUPATION        = 'custom_59';
  CONST CUSTOM_FIELD_APPRENT_LEVEL          = 'custom_63';
  CONST CUSTOM_FIELD_APPRENT_SECTOR         = 'custom_64';
  CONST CUSTOM_FIELD_EDUCATION_CURRENT      = 'custom_68';
  CONST CUSTOM_FIELD_APPRENT_TITLE          = 'custom_69';
  CONST CUSTOM_FIELD_APPRENT_EMPLOYER       = 'custom_70';
  CONST CUSTOM_FIELD_NON_A_LEVEL            = 'custom_74';
  CONST CUSTOM_FIELD_EDUC_CURR_OTHER        = 'custom_75';
  CONST CUSTOM_FIELD_FURTHER_EDUC_INST      = 'custom_76';
  CONST CUSTOM_FIELD_IB_SUBJECTS            = 'custom_331';
  CONST CUSTOM_FIELD_AS_LEVELS              = 'custom_332';
  CONST CUSTOM_FIELD_SCOTTISH_HIGHERS       = 'custom_390';
  CONST CUSTOM_FIELD_UG_SUBJECT_MULTI       = 'custom_388';
  CONST CUSTOM_FIELD_PG_SUBJECT_MULTI       = 'custom_389';

  // Occupation custom data
  //CONST CUSTOM_FIELD_CURRENTLY       = 'custom_33';
  CONST CUSTOM_FIELD_CURRENTLY_OTHER = 'custom_34';
  CONST CUSTOM_FIELD_OCCUPATION_MULTI      = 'custom_386';
  CONST CUSTOM_FIELD_OCCUPATION_ADDITIONAL = 'custom_387';
  CONST OPTION_GROUP_OCCUPATION_MULTI      =  89;
  CONST OPTION_GROUP_OCCUPATION_ADDITIONAL = 101;

  // Custom questions constants
  CONST CUSTOM_QUESTIONS_BASE_NAME = 'Custom_Questions_For_School_Id_';
  CONST CREATE_ADDRESS_LOCATION_TYPE_ID = 1;

  // School custom data questions
  CONST CUSTOM_FIELD_SCHOOL_ID = 'custom_21';

  CONST ADDRESS_DATA_STREET_NAME     = 'street_address';
  CONST ADDRESS_DATA_SUPPL_ADDRESS_1 = 'supplemental_address_1';
  CONST ADDRESS_DATA_SUPPL_ADDRESS_2 = 'supplemental_address_2';
  CONST ADDRESS_DATA_CITY        = 'city';
  CONST ADDRESS_DATA_POSTAL_CALL = 'postal_code';
  CONST ADDRESS_DATA_COUNTRY_ID  = 'country_id';

  // Social media custom fields
  CONST SOCIAL_MEDIA_TWITTER  = 'custom_136';
  CONST SOCIAL_MEDIA_LINKEDIN = 'custom_147';
  CONST SOCIAL_MEDIA_FACEBOOK = 'custom_25';

  private $iContactId; // the contact being viewed
  private $iRelationshipId; // the relationship between the school and the contact being viewed
  private $iUserCiviId; // the logged in teacher contact doing the viewing
  private $iSchoolId; // the selected school of the logged in teacher

  /*
   * getUsersAtSameSchool
   *
   * returns all the users at the same school as the provided user
   * needs to be static so that it can be used by the api calls
   * used to restrict the displayed communications / mobilisations / notes / etc
   * as this is process intensive it should only be called from an api function
   * @param int $iUserId the id of the logged in user
   * @return array $aTeacherIds
   */
  static function getUsersAtSameOrg($iLoggedInUserId) {
    // TODO move to school dashboard
    $aTeacherIds = array();

    $aGetSchoolsParams = array(
      'version' => 3,
      'sequential' => 1,
      'relationship_type_id' => self::MAIN_CONTACT_RELATIONSHIP_TYPE_ID,
      'contact_id_a' => $iLoggedInUserId,
    );
    $aGetSchoolsResults = civicrm_api('Relationship', 'get', $aGetSchoolsParams);

    foreach ( $aGetSchoolsResults['values'] as $aEachSchoolRelationship ) {
      $aGetUsersParams = array(
        'version' => 3,
        'sequential' => 1,
        'relationship_type_id' => self::MAIN_CONTACT_RELATIONSHIP_TYPE_ID,
        'contact_id_b' => $aEachSchoolRelationship['contact_id_b'],
      );
      $aGetUsersResults = civicrm_api('Relationship', 'get', $aGetUsersParams);

      foreach ($aGetUsersResults['values'] as $aUser) {
        $aTeacherIds[] = $aUser['contact_id_a'];
      }
    }

    return $aTeacherIds;
  }


  /*
   * getUsersWithAccess
   *
   */
  static function getUsersWithAccess($iLoggedInUserId){
    // TODO move to school dashboard
    $aUsersWithAccess = self::getUsersAtSameOrg($iLoggedInUserId);

    $getFutureFirstEmployeesParams = array(
      'version' => 3,
      'sequential' => 1,
      'relationship_type_id' => 4,
      'contact_id_b' => self::FUTURE_FIRST_CIVICRM_ID,
    );
    $getFutureFirstEmployeesResults = civicrm_api('Relationship', 'get', $getFutureFirstEmployeesParams);

    foreach ($getFutureFirstEmployeesResults['values'] as $aEachFFEmployeeRel) {
      $aUsersWithAccess[] = $aEachFFEmployeeRel['contact_id_a'];
    }

    return $aUsersWithAccess;
  }
  /**
   * Takes a students note and returns the note in the
   * appropriate way to be displeyed in the template
   * @param array $aNote
   * @return array $aNote - returns a filtered single note
   */
  static function filterNoteData($aNote) {

    if ( !$aNote['subject'] ){
      $aNote['subject'] = '';
    }

    if ( !$aNote['note'] ){
      $aNote['note'] = '';
    }

    if ( !$aNote['modified_date'] ){
      $aNote['modified_date'] = '';
    }
    // Gets the name of the author of the note
    $aNote['author_id'] = CRM_Futurefirst_veda_FF_utils::_get_contact_name($aNote['contact_id']);
    return $aNote;
  }

  /**
   * getCustomQuestionsOptions
   * Returns all the active custom question options
   * @param type $questionData - custom question data
   * @return mixed boolean|array - FALSE if there is an error
   *                               | custom question options
   */
  public function getCustomQuestionsOptions($questionData) {

    $customOptionsApiParams = array(
      'version' => 3,
      'sequential' => 1,
      'option_group_id' => $questionData['option_group_id'],
      'is_active' => 1,
      'option.sort' => 'weight ASC', // Order by weight.
    );
    $customOptionsApiResults = civicrm_api('OptionValue', 'get', $customOptionsApiParams);
    if ( civicrm_error($customOptionsApiResults) ) {
      watchdog(
        'View and Edit Contact Page',
        'Could not find the custom question options with the group id :ogid',
        array(
          ':ogid' => $questionData['option_group_id'],
        ),
        WATCHDOG_ERROR
      );
      return FALSE;
    }
    return $customOptionsApiResults;
  }
  /**
   * Retrieves the students custom question answer and
   * all custom options if the question is a Select or Multi-Select
   * @param type $iContactId - a student's ID
   * @param type $questionData - a custom question data
   * @return string - custom question answer
   */
  public static function getCustomQuestionAnswer($iContactId, $questionData){
    $questionId = $questionData['id'];
    $customField = 'custom_' . $questionId;
    $customQuestionAnswerApiParams = array(
      'version' => 3,
      'sequential' => 1,
      'id' => $iContactId,
      'contact_sub_type' => 'student',
      'return' => implode(",", array(
          $customField,
        )),
      );
    $customQuestionsApiResult =  civicrm_api('Contact', 'getsingle' ,$customQuestionAnswerApiParams);
    if (civicrm_error($customQuestionsApiResult)){
      watchdog(
        'View and Edit Contact Page',
        'Could not find the custom question answer with the id :field for the contact :cid.',
        array(
          ':field' => $customField,
          ':cid'   => $iContactId,
        ),
        WATCHDOG_ERROR
      );
      return '';
    }
    // If the question is not text get the matching custom options
    // and the selected options
    if ( $questionData['html_type'] != 'Text' ) {
      $customQuestionsApiResult[$customField] = array(
        'selected_options' => $customQuestionsApiResult[$customField],
        'custom_question_options' => CRM_Contactscreen_Page_ContactView::getCustomQuestionsOptions($questionData),
      );
    }
    return $customQuestionsApiResult[$customField];
  }

  function setSchoolAndRelationshipIds(){

    require_once drupal_get_path('module', 'school_dashboard').'/school_dashboard.module';
    $aSchoolIds = school_dashboard_get_schools_for_logged_in_teacher();

    foreach( $aSchoolIds as $eachSchoolId ){
      $getRelationshipParams = array(
        'version'      => 3,
        'sequential'   => 1,
        'contact_id_a' => $this->iContactId,
        'contact_id_b' => $eachSchoolId,
    		'is_active' => '1',
        'relationship_type_id' => self::SCHOOL_IS_RELATIONSHIP_TYPE_ID,
      );
      $getRelationshipResults = civicrm_api( 'Relationship', 'get', $getRelationshipParams );

      // select the first applicable school
      if ($getRelationshipResults['count'] > 0){
        $this->iRelationshipId = $getRelationshipResults['values'][0]['id'];
        $this->iSchoolId = $eachSchoolId;
        return;
      }
    }
  }


  function buildFullName( $first_name, $last_name, $nick_name, $previousName ){

    // add inverted commas and space to nick name
    if ($nick_name){
      $nick_name = '"' . $nick_name .'" ';
    }

    // add brackets and space to previous name
    if ($previousName){
      $previousName = ' (' . $previousName .')';
    }

    return $first_name . ' ' . $nick_name . $last_name . $previousName ;
  }


  /*
   * buildContactDetails_Main
   *
   * Produce contact details tab
   * @param  int     $cid
   * @return array   $contactInfo
   *
   */
  function buildContactDetails_Main(){
    $contactDetails = civicrm_api( "Contact",
                                   "getsingle",
                                   array ( 'version'     => '3',
                                           'sequential'  => '1',
                                           'id'          => $this->iContactId,
                                           'contact_type' => 'Individual',
                                           'contact_sub_type' => 'Student',
                                    )
                                );

    // TODO include date joined if appropriate activity

    $getCustomContactDetailsParams = array(
      'version' => 3,
      'sequential' => 1,
      'id' => $this->iContactId,
      'contact_sub_type' => 'student',
      'return' => implode(",", array(
        self::CUSTOM_FIELD_PREVIOUS_NAME,
        //self::CUSTOM_FIELD_CURRENTLY,
        self::CUSTOM_FIELD_OCCUPATION_MULTI,
        self::CUSTOM_FIELD_OCCUPATION_ADDITIONAL,
        self::CUSTOM_FIELD_CURRENTLY_OTHER,
      )),
    );
    $getCustomContactDetailsResults = civicrm_api('Contact', 'getsingle', $getCustomContactDetailsParams);

    $contactDetails['previous_name'] = $getCustomContactDetailsResults[self::CUSTOM_FIELD_PREVIOUS_NAME];
    //$contactDetails['currently'] = $getCustomContactDetailsResults[self::CUSTOM_FIELD_CURRENTLY];
    $contactDetails['occupation']            = $this->buildContactDetails_GetContactMulti($getCustomContactDetailsResults, self::OPTION_GROUP_OCCUPATION_MULTI,      self::CUSTOM_FIELD_OCCUPATION_MULTI);
    $contactDetails['occupation_additional'] = $this->buildContactDetails_GetContactMulti($getCustomContactDetailsResults, self::OPTION_GROUP_OCCUPATION_ADDITIONAL, self::CUSTOM_FIELD_OCCUPATION_ADDITIONAL);
    $contactDetails['currently_other'] = $getCustomContactDetailsResults[self::CUSTOM_FIELD_CURRENTLY_OTHER];

    // Format date for dropdowns
    if( $contactDetails['birth_date']){
      $date = DateTime::createFromFormat("Y-m-d", $contactDetails['birth_date']);
      $contactDetails['birth_day'] = $date->format('d');
      $contactDetails['birth_month'] = $date->format('m');
      $contactDetails['birth_year'] = $date->format('Y');
    }
    $contactDetails['full_name'] = $this->buildFullName(
      $contactDetails['first_name'],
      $contactDetails['last_name'],
      $contactDetails['nick_name'],
      $contactDetails['previous_name']
    );

    // TODO is_deceased when we're sure this isn't in the search results

    return $contactDetails;
  }
  /**
   * Returns the custom education details from a student
   * @param int $iContactId - the student's contact ID
   * @return mixed FALSE|Array - false if error; array of education custom data
   */
  function getCustomEducationDetails($iContactId){
    $fieldsToReturn = array(
      self::CUSTOM_FIELD_EDUCATION_SUMMARY,
      self::CUSTOM_FIELD_FURTHER_EDUCATION,
      self::CUSTOM_FIELD_POSTGRAD_INSTITUTION,
      self::CUSTOM_FIELD_UNDERGRAD_INSTITUTION,
      //self::CUSTOM_FIELD_POSTGRAD_SUBJECT,
      self::CUSTOM_FIELD_POSTGRAD_SUJECT_OTHER,
      self::CUSTOM_FIELD_PG_SUBJECT_MULTI,
      self::CUSTOM_FIELD_UNDERGRAD_SUJECT_OTHER,
      //self::CUSTOM_FIELD_UNDERGRAD_SUJECT,
      self::CUSTOM_FIELD_UG_SUBJECT_MULTI,
      self::CUSTOM_FIELD_POSTGRAD_INST_OTHER,
      self::CUSTOM_FIELD_UNDERGRAD_INST_OTHER,
      self::CUSTOM_FIELD_CURR_EDU_EXPECT_FINISH,
      self::CUSTOM_FIELD_CURR_OCCUPATION,
      self::CUSTOM_FIELD_APPRENT_LEVEL,
      self::CUSTOM_FIELD_APPRENT_SECTOR,
      self::CUSTOM_FIELD_EDUCATION_CURRENT,
      self::CUSTOM_FIELD_APPRENT_TITLE,
      self::CUSTOM_FIELD_APPRENT_EMPLOYER,
      self::CUSTOM_FIELD_NON_A_LEVEL,
      self::CUSTOM_FIELD_EDUC_CURR_OTHER,
      self::CUSTOM_FIELD_FURTHER_EDUC_INST,
      self::CUSTOM_FIELD_IB_SUBJECTS,
    );

    // If school is Scottish, don't return AS/A-Level options
    // Otherwise, don't return Scottish Highers
    require_once 'CRM/Futurefirst/veda_FF_utils.php';
    $schoolId = CRM_Futurefirst_veda_FF_utils::get_teacher_school_ID();
    if (!CRM_Futurefirst_veda_FF_utils::school_is_scottish($schoolId)) {
      $fieldsToReturn[] = self::CUSTOM_FIELD_AS_LEVELS;
      $fieldsToReturn[] = self::CUSTOM_FIELD_A_LEVELS;
    }
    else {
      $fieldsToReturn[] = self::CUSTOM_FIELD_SCOTTISH_HIGHERS;
    }

    $getEducationDetailsParams = array(
      'version' => 3,
      'sequential' => 1,
      'id' => $iContactId,
      'contact_sub_type' => 'student',
      'return' => implode(",", $fieldsToReturn),
    );
    $getEducationDetailsResults = civicrm_api('Contact', 'getsingle', $getEducationDetailsParams);
    if ( civicrm_error($getEducationDetailsResults) ){
      watchdog(
        'View and Edit Contact Page',
        'Could not find the education details for the contact :cid',
        array(
          ':cid' => $iContactId,
        ),
        WATCHDOG_ERROR
      );
      return FALSE;
    }
    // Extract the year from the date
    // DateTime::createFromFormat was not working
    if ($getEducationDetailsResults[self::CUSTOM_FIELD_CURR_EDU_EXPECT_FINISH]) {
      $eduDate =  new DateTime($getEducationDetailsResults[self::CUSTOM_FIELD_CURR_EDU_EXPECT_FINISH]);
      $getEducationDetailsResults[self::CUSTOM_FIELD_CURR_EDU_EXPECT_FINISH] = $eduDate->format("Y-m");
    }
    // Get the Contact's names from their IDs
    $getEducationDetailsResults[self::CUSTOM_FIELD_APPRENT_EMPLOYER] =
      ( $getEducationDetailsResults[self::CUSTOM_FIELD_APPRENT_EMPLOYER] != '')
        ? CRM_Futurefirst_veda_FF_utils::_get_contact_name($getEducationDetailsResults[self::CUSTOM_FIELD_APPRENT_EMPLOYER])
        : '';

    // Arrange the data so it can be easily read in the Template/Javascript
    return $getEducationDetailsResults;
  }

  /**
   * Retrieves a student's custom employment details
   * @param int $iContactId
   * @return mixed FALSE|Array falsein case of error; array of custom employment data
   */
  function getCustomEmploymentDetails($iContactId){

    $getEmploymentDetailsParams = array(
      'version' => 3,
      'sequential' => 1,
      'id' => $iContactId,
      'contact_sub_type' => 'student',

      'return' => implode(",", array(
          self::CUSTOM_FIELD_EMPLOYMENT_STATUS_INDEX,
          self::CUSTOM_FIELD_EMPLOYMENT_STATUS_OTHER_INDEX,
          self::CUSTOM_FIELD_EMPLOYMENT_SECTOR_INDEX,
          self::CUSTOM_FIELD_GOVERNMENT_EMPLOYMENT_PROG_NDEX,
          self::CUSTOM_FIELD_GOV_EMPLOY_PROG,
          self::CUSTOM_FIELD_GOV_EMPLOY_DETAILS,
          self::CUSTOM_FIELD_CAREER_HISTORY,
        )),
      );
    $getEmploymentDetailsResults = civicrm_api('Contact', 'getsingle', $getEmploymentDetailsParams);

    if ( civicrm_error($getEmploymentDetailsResults) ){
      watchdog(
        'View and Edit Contact Page',
        'Could not find the custom employment details for the contact: :cid',
        array(
          ':cid' => $iContactId,
        ),
        WATCHDOG_ERROR
      );
      return FALSE;
    }

    // Get the Contact's names from their IDs
    $getEmploymentDetailsResults[self::CUSTOM_FIELD_GOV_EMPLOY_PROG] =
      ( $getEmploymentDetailsResults[self::CUSTOM_FIELD_GOV_EMPLOY_PROG] != '')
        ? CRM_Futurefirst_veda_FF_utils::_get_contact_name($getEmploymentDetailsResults[self::CUSTOM_FIELD_GOV_EMPLOY_PROG])
        : '';

    $aEmploymentDetails = array();
    // Arrange the data so it can be easily read in the Template/Javascript
    $aEmploymentDetails[] = array('id' => self::CUSTOM_FIELD_EMPLOYMENT_STATUS_INDEX, 'value'=> $getEmploymentDetailsResults[self::CUSTOM_FIELD_EMPLOYMENT_STATUS_INDEX]);
    $aEmploymentDetails[] = array('id' => self::CUSTOM_FIELD_EMPLOYMENT_STATUS_OTHER_INDEX, 'value'=> $getEmploymentDetailsResults[self::CUSTOM_FIELD_EMPLOYMENT_STATUS_OTHER_INDEX]);
    $aEmploymentDetails[] = array('id' => self::CUSTOM_FIELD_EMPLOYMENT_SECTOR_INDEX, 'value'=> $getEmploymentDetailsResults[self::CUSTOM_FIELD_EMPLOYMENT_SECTOR_INDEX]);
    $aEmploymentDetails[] = array('id' => self::CUSTOM_FIELD_GOVERNMENT_EMPLOYMENT_PROG_NDEX, 'value'=> $getEmploymentDetailsResults[self::CUSTOM_FIELD_GOVERNMENT_EMPLOYMENT_PROG_NDEX]);
    $aEmploymentDetails[] = array('id' => self::CUSTOM_FIELD_GOV_EMPLOY_PROG, 'value'=> $getEmploymentDetailsResults[self::CUSTOM_FIELD_GOV_EMPLOY_PROG]);
    $aEmploymentDetails[] = array('id' => self::CUSTOM_FIELD_GOV_EMPLOY_DETAILS, 'value'=> $getEmploymentDetailsResults[self::CUSTOM_FIELD_GOV_EMPLOY_DETAILS]);
    $aEmploymentDetails[] = array('id' => self::CUSTOM_FIELD_CAREER_HISTORY, 'value'=> $getEmploymentDetailsResults[self::CUSTOM_FIELD_CAREER_HISTORY]);

    return $aEmploymentDetails;
  }

  /**
   * buildContactDetails_AddressInfo
   * Get all the existing address data of a specific contact. If there is no
   * address for this contact create it and return it's ID.
   * If there is no country ID in the address, set it to the default value.
   *
   * @param type $iContactId - the contact's id
   * @param array $aContactAddressInfo - returns a keyed array that
   * holds the address details
   */
  function buildContactDetails_AddressInfo($iContactId){
    // Get only the necessary data, thus the return.
    $aGetAddressParams = array(
      'version' => 3,
      'sequential' => 1,
      'contact_id' => $iContactId,
      'return' => implode(",", array(
          self::ADDRESS_DATA_STREET_NAME,
          self::ADDRESS_DATA_SUPPL_ADDRESS_1,
          self::ADDRESS_DATA_SUPPL_ADDRESS_2,
          self::ADDRESS_DATA_CITY,
          self::ADDRESS_DATA_POSTAL_CALL,
          self::ADDRESS_DATA_COUNTRY_ID,
        )),
    );
    $aGetAddressResults = civicrm_api('Address', 'get', $aGetAddressParams);

    if ( $aGetAddressResults['count'] > 0 ) {
      // Set all existing values for the template.
      // Use the first address returned.
      foreach ($aGetAddressResults['values'][0] as $field_key => $field_value){
        $aContactAddressInfo[$field_key] = $field_value;
      }
    }
    else {
      // We need the address to exist ahead of time for inline editing to work.
      $aCreateAddressParams = array(
        'version' => 3,
        'sequential' => 1,
        'contact_id' => $iContactId,
        'location_type_id' => self::CREATE_ADDRESS_LOCATION_TYPE_ID,
      );
      $aCreateAddressResult = civicrm_api('Address', 'create', $aCreateAddressParams);
      $aContactAddressInfo['id'] = $aCreateAddressResult['id'];
    }
    // If there is no country id set it to the default value.
    if( empty($aContactAddressInfo['country_id']) ){
      $aContactAddressInfo['country_id'] = self::DROPDOWN_SELECT_DEFAULT_VALUE;
    }
    return $aContactAddressInfo;
  }
 /**
   * buildContactDetails_PhoneNumbersInfo
   * Get the contact's phone numbers
   * @param int $aContactId - the contact ID
   * @return array $aContactPhoneNumbersInfo - keyed array that contains
   * the phone ID, phone number and the 'is primary' identifier
   */
  function buildContactDetails_PhoneNumbersInfo($aContactId){
    $aContactPhoneNumbersInfo = array();
    $aGetPhoneNumbersParams = array(
      'version' => 3,
      'sequential' => 1,
      'contact_id' => $aContactId,
    );
    $aGetPhoneNumbersResults = civicrm_api('Phone', 'get', $aGetPhoneNumbersParams);

    foreach($aGetPhoneNumbersResults['values'] as $sEachPhoneNumber){
      // If the phone is of the type is empty (i.e. not hasn't been set to
      // a specific type) or is different of "Do Not Contact"
      //  include it on the return array

      if ( empty($sEachPhoneNumber['phone_type_id'])
          || $sEachPhoneNumber['phone_type_id'] != self::DO_NOT_CONTACT_PHONE_TYPE_ID ) {
        $aContactPhoneNumbersInfo[] = array(
          'id' => $sEachPhoneNumber['id'],
          'phone' => $sEachPhoneNumber['phone'],
          'is_primary' => $sEachPhoneNumber['is_primary'],
        );

      }
    }
    return $aContactPhoneNumbersInfo;
  }

  /**
   *
   * Get all the social media related information about an alumnus.
   *
   * @param int $aContactId - Id of the contact.
   * @return array - Keyed array that contains all the
   * wanted social media information
   */
  static function buildContactDetails_SocialMediaInfo($aContactId){
    $contactSocialMediaDetails = array();
    $aGetSocialMediaParams = array(
      'version' => 3,
      'sequential' => 1,
      'id' => $aContactId,
      'return' => implode(",", array(
          self::SOCIAL_MEDIA_TWITTER,
          self::SOCIAL_MEDIA_LINKEDIN,
        )),
    );

    $aGetSocialMediaResults = civicrm_api('Contact','getsingle',$aGetSocialMediaParams);

    if ( civicrm_error($aGetSocialMediaResults) ) {
      // Log watchdog
      watchdog(
        'View and Edit Contact Page',
        'Unable to get social media details for contact id :cid, error message: :error',
        array(
          ':cid'   => $aContactId,
          ':error' => $aGetSocialMediaResults['error_message'],
        ),
        WATCHDOG_ERROR
      );
      return $contactSocialMediaDetails;
    }
    // Build return array.
    $contactSocialMediaDetails = array(
      self::SOCIAL_MEDIA_TWITTER  => $aGetSocialMediaResults[self::SOCIAL_MEDIA_TWITTER],
      self::SOCIAL_MEDIA_LINKEDIN => $aGetSocialMediaResults[self::SOCIAL_MEDIA_LINKEDIN],
    );

    return $contactSocialMediaDetails;
  }

  /**
   * buildContactDetails_EmailAddressesInfo
   * Get the contact's emails addresses
   * @param int $aContactId - the contact ID
   * @return array $aContactEmailAddressInfo - keyed array that contains
   * the email ID, email address and the 'is primary' identifier
   */
  function buildContactDetails_EmailAddressesInfo($aContactId){
    $aContactEmailAddressInfo = array();
    $aGetEmailAddressesParams = array(
      'version' => 3,
      'sequential' => 1,
      'contact_id' => $aContactId,
      'on_hold' => 0,
    );
    $aGetEmailAddressesResults = civicrm_api('Email', 'get', $aGetEmailAddressesParams);

    foreach($aGetEmailAddressesResults['values'] as $sEachEmailAddress){
      $aContactEmailAddressInfo[] = array(
        'id' => $sEachEmailAddress['id'],
        'email' => $sEachEmailAddress['email'],
        'is_primary' => $sEachEmailAddress['is_primary'],
      );
    }
    return $aContactEmailAddressInfo;
  }

  /**
   * Given the output of a Contact.getsingle requesting the relevant fields,
   * for a multi-select (checkbox) custom field on a Contact,
   * retrieve a list of possible options and whether they are checked.
   *
   * @param array  $aGetContactDetailResults Result array from a Contact.getsingle API
   * @param int    $optionGroupId
   * @param string $customFieldIndex         eg. custom_999
   * @return array
   */
  function buildContactDetails_GetContactMulti(&$aGetContactDetailResults, $optionGroupId, $customFieldIndex) {
    // Get list of possible options in that option group
    $optionsParams = array(
      'version'         => 3,
      'sequential'      => 1,
      'option_group_id' => $optionGroupId,
      'is_active'       => 1,
      'sort'            => 'weight',
    );
    $optionsResult = civicrm_api('OptionValue', 'get', $optionsParams);

    // Return just the details we want, plus a 'checked' field if this contact has the option selected
    $optionsReturn = array();
    foreach ($optionsResult['values'] as $option) {
      $optionsReturn[$option['value']] = array(
        'label'   => $option['label'],
        'value'   => $option['value'],
        'checked' => '',
      );
    }

    // Look at the contact's custom data and fill in the 'checked' part
    // If the contact hasn't selected any of the options, move on
    // Note, this is slightly different to buildContactDetails_GetHowWantToHelp below:
    // http://civicrm.stackexchange.com/questions/329/format-of-multi-select-custom-field-api-returns-from-contact-vs-relationship
    if (!empty($aGetContactDetailResults[$customFieldIndex])) {
      foreach ($aGetContactDetailResults[$customFieldIndex] as $selectedOption) {
        $optionsReturn[$selectedOption]['checked'] = 'checked';
      }
    }
    return $optionsReturn;
  }

  /**
   * buildContactDetails_GetHowWantToHelp
   * This function retrives all the support offered options (sorted by weight)
   * and sets a parameter 'checked' if the contact data has that option selected.
   * It then adds the 'Other support offered" if it extists on the contact's data,
   * if not set's it blank.
   * @param $aGetRelationshipDetailResults array - only pass by reference for efficiency, no mutability here
   * @return $aHowWantToHelpAssociativeArray array - associative array that
   * contains all the support offered options
   */
  function buildContactDetails_GetHowWantToHelp(&$aGetRelationshipDetailResults) {

    $aHowWantHelpOptionsParams = array(
      'version' => 3,
      'sequential' => 1,
      'option_group_id' => self::HOW_WANT_TO_HELP_OPTION_GROUP_ID,
      'is_active' => 1,
      'sort' => 'weight',
    );
    $aHowWantHelpOptionsResult = civicrm_api('OptionValue', 'get', $aHowWantHelpOptionsParams);

    $aHowWantToHelpAssociativeArray = array();
    // Creation of an array to be returned in a more manageable structure,
    // and with the desired fields
    foreach ($aHowWantHelpOptionsResult['values'] as $aHowWantToHelpOption) {
      $aHowWantToHelpAssociativeArray[$aHowWantToHelpOption['value']] = array(
        'label' => $aHowWantToHelpOption['label'],
        'value' => $aHowWantToHelpOption['value'],
        // New checked parameter added here. Used to
        // store if the contact has this option selected
        'checked' => '',
        );
    }
    // If the contact hasn't selected any on the options move on
    if ( !empty($aGetRelationshipDetailResults[self::RELATIONSHIP_HOW_WANT_TO_HELP_INDEX]) ){
      // If selected options exist, set them "checked". The string "checked" is used so it
      // can be inserted on the HTML
      foreach ( $aGetRelationshipDetailResults[self::RELATIONSHIP_HOW_WANT_TO_HELP_INDEX] as $sWantToHelpKey => $value) {
          $aHowWantToHelpAssociativeArray[$sWantToHelpKey]['checked'] = 'checked' ;
      }
    }
    return  $aHowWantToHelpAssociativeArray;
  }
  /**
   * buildContactDetails_OtherSupportOffered
   * Returns the "Other support offered" field if it exists, if not
   * returns an empty string.
   * @param array $getRelationshipDetailResults - relationship data between
   * the school and student
   * @return string $otherSupportOffered
   */
  function buildContactDetails_OtherSupportOffered( &$getRelationshipDetailResults ){

    // Does the "Other support offered" data exists in the relationship?
    if ( !empty($getRelationshipDetailResults[self::RELATIONSHIP_HOW_WANT_TO_HELP_OTHER_INDEX]) ){
      $otherSupportOffered = $getRelationshipDetailResults[self::RELATIONSHIP_HOW_WANT_TO_HELP_OTHER_INDEX];
     }
    else {
      // If not set it to empty so no problems occur on the template.
      $otherSupportOffered = '';
    }
    return $otherSupportOffered;
  }
  /*
   * buildContactDetails_RelationshipToSchool
   *
   * Produce contact details tab
   * @return array   $contactInfo
   *
   */
  function buildContactDetails_RelationshipToSchool(){

    $aOutput = array();

    $getRelationshipDetailParams = array(
      'version'    => 3,
      'sequential' => 1,
      'id'         => $this->iRelationshipId,
      'relationship_type_id' => self::SCHOOL_IS_RELATIONSHIP_TYPE_ID,
    );

    $getRelationshipDetailResults = civicrm_api('Relationship', 'getsingle', $getRelationshipDetailParams);

    // If no value is set (NULL) the field won't be returned. Avoid the notice by checking for empty.
    if (!empty($getRelationshipDetailResults[self::RELATIONSHIP_LEAVING_YEAR_INDEX])) {
      $aLeavingYearFullDate = getdate( strtotime( $getRelationshipDetailResults[self::RELATIONSHIP_LEAVING_YEAR_INDEX] ) );
      $aOutput['leaving_year'] = $aLeavingYearFullDate['year'];
    }
    else {
      $aOutput['leaving_year'] = '';
    }

    if (!empty($getRelationshipDetailResults[self::RELATIONSHIP_LEAVING_YEAR_GROUP_INDEX])) {
      $aOutput['leaving_year_group'] = $getRelationshipDetailResults[self::RELATIONSHIP_LEAVING_YEAR_GROUP_INDEX];
    }
    else {
      $aOutput['leaving_year_group'] = '';
    }

    $aOutput['how_want_to_help'] = $this->buildContactDetails_GetHowWantToHelp( $getRelationshipDetailResults );
    $aOutput['other_support_offered'] = $this->buildContactDetails_OtherSupportOffered( $getRelationshipDetailResults );

    return $aOutput;
  }


  /*
   * buildContactDetails
   *
   * Produce contact details tab
   * @param  int     $cid
   * @return array   $collatedContactInfo
   *
   */
  function buildContactDetails(){
    $collatedContactInfo = array();

    $collatedContactInfo = array_merge(
        $this->buildContactDetails_Main( $this->iContactId ),
        $this->buildContactDetails_RelationshipToSchool()
    );
    // Get the address data.
    $collatedContactInfo['address'] = $this->buildContactDetails_AddressInfo($this->iContactId);
    return $collatedContactInfo;
  }


  /*
   * buildMobilisationDetails
   *
   * Produce mobilisation details tab
   * @param  int     $cid
   * @return array   $mobilisations
   *
   */
  function buildMobilisationDetails(){
    $mobilisation    = new CRM_Mobilise_Utils_Mobilisation( $this->iContactId );
    $lastMobilisations   = array_values( $mobilisation->getMobilisations( $this->iContactId, NULL ) );

    return $lastMobilisations;
  }

  /**
   * Retrieves all the active custom questions for a custom option group
   * @param int $optionGroupId - option group ID
   * @return mixed FALSE|Array false if there is an error; array of active custom questions
   */
  public static function getActiveCustomQuestions($optionGroupId){

    $getActiveCustomQuestionsApiParams = array(
      'version' => 3,
      'sequential' => 1,
      'custom_group_id' => $optionGroupId,
      'is_active' => 1,
    );
    $activeCustomQuestions = civicrm_api('CustomField', 'get', $getActiveCustomQuestionsApiParams);
    if (civicrm_error($activeCustomQuestions)) {
      watchdog(
        'View and Edit Contact Page',
        'Could not find the custom questions for the custom group id :cgid',
        array(
          ':cgid' => $optionGroupId,
        ),
        WATCHDOG_ERROR
      );
      return FALSE;
    }
    return $activeCustomQuestions;
  }

  /**
   * Returns the the schools custom question option group
   * Needs to be static for use in api
   * @param type $iSchoolId - a school's ID
   * @return FALSE | Array - FALSE if error; custom questions option group
   */
  public static function getSchoolActiveCustomQuestionData($iSchoolId){

    $schoolCustomQuestionDataApiParams = array(
      'version' => 3,
      'sequential' => 1,
      'name' => self::CUSTOM_QUESTIONS_BASE_NAME . $iSchoolId,
      'is_active' => 1,
    );

    $schoolCustomQuestionData = civicrm_api('CustomGroup', 'getsingle', $schoolCustomQuestionDataApiParams);
    if (civicrm_error($schoolCustomQuestionData)) {
      watchdog(
        'View and Edit Contact Page',
        'Could not find the custom questions group for the school :schoolid',
        array(
          ':schoolid' => $iSchoolId,
        ),
        WATCHDOG_ERROR
      );
      return FALSE;
    }
    return $schoolCustomQuestionData;
  }

  /**
   * Checks if the school of the current logged in teacher has custom questions or not
   * @return boolean - TRUE if there are custom questions False if not
   */
  public function hasCustomQuestions() {

    $schoolCustomQuestionData = $this->getSchoolActiveCustomQuestionData($this->iSchoolId);

    if(!$schoolCustomQuestionData){
      return FALSE;
    }

    $activeQuestions = $this->getActiveCustomQuestions($schoolCustomQuestionData['id']);

    if (!$activeQuestions || $activeQuestions['count'] == 0){
      return FALSE;
    }
    return TRUE;
  }

  /**
   * Determines if the logged in teacher's school is the same
   * on that is in the student's school custom data
   * @param type $contactId - contact ID of the student
   * @return boolean returns TRUE or FALSE depending is the
   */
  function isTeacherSameSchoolCustomData( $contactId ){
    $schoolCustomDataApiParams = array(
      'version' => 3,
      'sequential' => 1,
      'id' => $contactId,
      'return' => self::CUSTOM_FIELD_SCHOOL_ID,
    );
    // The returns are integers so they can be better handled on the template
    $schoolCustomDataApiReturn = civicrm_api('Contact', 'getsingle', $schoolCustomDataApiParams);
    if ( civicrm_error($schoolCustomDataApiReturn) ) {
      watchdog(
        'View and Edit Contact Page',
        "Could not determine the student's school for the contact ID :cid",
        array(
          ':cid' => $contactId,
        ),
        WATCHDOG_ERROR
      );
      return 0;
    }

    // Is the logged in teacher from the same school as the student's custom data?
    if( $schoolCustomDataApiReturn[self::CUSTOM_FIELD_SCHOOL_ID] == $this->iSchoolId ){
      return 1;
    }
    return 0;
  }

  /**
   * Get all the countries in CiviCRM
   * @params array $countryList - array that will hold all the countries in CiviCRM
   *
   */
  public function getCountryList(&$countryList){
    $query = "SELECT id , name FROM civicrm_country;";
    $queryResult = CRM_Core_DAO::executeQuery($query);
    while($queryResult->fetch()){
      $countryList[] = array(
        'id' => $queryResult->id,
        'name' => $queryResult->name,
        );
    }
  }

  /*
   * isContactDeleted
   *
   * Checks the contact isn't deleted
   */
  function isContactDeleted(){
    $bIsDeleted = civicrm_api('Contact', 'getvalue', array(
      'version'    => 3,
      'sequential' => 1,
      'contact_id' => $this->iContactId,
      'return'     => 'contact_is_deleted',
    ));
    if (civicrm_error($bIsDeleted)) {
      return FALSE;
    }
    if ($bIsDeleted) {
      return FALSE;
    }
    return TRUE;
  }

  function init() {
    // TODO add error checking etc

    $session = CRM_Core_Session::singleton();
    $this->iUserCiviId = $session->get('userID');

    $this->iContactId = filter_input( INPUT_GET, 'cid' );

    global $base_url;
    if ($this->isContactDeleted() == FALSE) {
       // TODO suitable error message and redirect path
      watchdog(
        'View and Edit Contact Page',
        'User :userid attempted to to access a view & edit page of the contact :cid',
        array(
          ':userid' => $this->iUserCiviId,
          ':cid'    => $this->iContactId,
        ),
        WATCHDOG_WARNING
      );
      drupal_set_message("We were unable to display this page at this time. Please contact support. 1");
      drupal_goto($base_url . "/school-dashboard");
    }

    // Get one of the relationships between the school and the contact being viewed.
    $this->setSchoolAndRelationshipIds();

    // Determine if the teacher can look at this contact, or bail.
    if ( $this->iRelationshipId == NULL || $this->iSchoolId == NULL){
      // TODO suitable error message and redirect path
      watchdog(
        'View and Edit Contact Page',
        'User :userid attempted to to access a view & edit page of the contact :cid but he has no relationship to the school.',
        array(
          ':userid' => $this->iUserCiviId,
          ':cid'    => $this->iContactId,
        ),
        WATCHDOG_WARNING
      );
      drupal_set_message("We were unable to display this page at this time. Please contact support. 2");
      drupal_goto($base_url . "/school-dashboard");
    }

  }

  /**
   * Escapes HTML entities in all string values in an array, traversing deeply.
   *
   * @param array $arrayToEscape
   * @return array
   */
  static function array_escape($arrayToEscape) {
    array_walk_recursive($arrayToEscape, function (&$arrayValue, $arrayKey) {
      if (is_string($arrayValue)) {
        $arrayValue = htmlentities($arrayValue, ENT_QUOTES, 'UTF-8', FALSE);
      }
    });
    return $arrayToEscape;
  }

  function run() {
    // Access control, members only
    if (!self::userIsMember()) {
      CRM_Utils_System::redirect('/membership-not-found'); // Leading slash is necessary
      return;
    }

    $this->init();

    CRM_Utils_System::setTitle( '' );

    $this->assign('cid', $this->iContactId);
    $this->assign('loggedInUserCiviId', $this->iUserCiviId);
    // Sends the current teacher's name to the template
    $this->assign('loggedInUserName', htmlentities(CRM_Futurefirst_veda_FF_utils::_get_contact_name($this->iUserCiviId)));
    $this->assign('institutionType', $this->getLoggedInInstitutionType());

    // Build contact summary.
    $this->assign( 'summary', self::array_escape($this->buildContactDetails()) );

    // Set some usefull variables.
    global $base_url;
    $this->assign('base_url', $base_url);
    // Variable that will enable (or not) the custom questions tab.
    $this->assign('hasCustomQuestions', print_r($this->hasCustomQuestions(), TRUE));
    // The school id of the logged in teacher.
    $this->assign('schoolId', print_r($this->iSchoolId, TRUE));
    // See if the teacher is from the same school has the contact's custom data
    $this->assign('isTeacherSameSchoolCustomData', $this->isTeacherSameSchoolCustomData( $this->iContactId ));
    // If school is Scottish, set a variable saying so
    require_once 'CRM/Futurefirst/veda_FF_utils.php';
    $this->assign('schoolIsScottish', CRM_Futurefirst_veda_FF_utils::school_is_scottish($this->iSchoolId));

    // Values for the birthdate dropdowns
    $dateYears = array_reverse(range(self::LEAVING_YEAR_EARLIEST, date('Y')));
    $dateMonths = array("01","02","03","04","05","06","07","08","09","10","11","12");
    $dateDays = array_merge($dateMonths, range (13,31));
    $this->assign('dateYears', $dateYears);
    $this->assign('dateMonths', $dateMonths);
    $this->assign('dateDays', $dateDays);

    $aPossibleLeavingYears = array_reverse( range( self::LEAVING_YEAR_EARLIEST, date( "Y" ) + self::LEAVING_YEAR_TOP_OFFSET ) );

    $this->assign( 'possible_leaving_years', $aPossibleLeavingYears );
    $this->assign( 'possible_leaving_year_groups', array(
      '- select -' => '',
      'Year 11' => 'eleven',
      'Year 12' => 'twelve',
      'Year 13' => 'thirteen',
      'Unknown' => 'Unknown',
    ));

    $this->assign( 'iRelationshipId', $this->iRelationshipId );

    parent::run();
  }

  /*
   * getLoggedInInstitutionType
   *
   * Checks the class iSchoolId variable
   *
   * return string "school" or "college"
   * If an institution is both a school and a college it returns "college"
   *
   */
  function getLoggedInInstitutionType(){
    $getInstituteTypeApiParams = array(
      'version' => 3,
      'sequential' => 1,
      'id' => $this->iSchoolId,
      'return' => 'contact_sub_type',
    );
    $getInstituteTypeApiResults = civicrm_api('Contact', 'getvalue', $getInstituteTypeApiParams);

    if (civicrm_error($getInstituteTypeApiResults)) {
      watchdog('View and Edit Contact Page', 'Error on retrieving institution type', array(), WATCHDOG_ERROR);
    }

    if (in_array('Further_Education_Institution', $getInstituteTypeApiResults)){
      return "college";
    }
    else if (in_array('School', $getInstituteTypeApiResults)){
      return 'school';
    }

    watchdog('View and Edit Contact Page', 'Unknown logged in institution type.', array(), WATCHDOG_ERROR);

    return NULL;
  }

  /**
   * Check whether the logged-in user has an active membership.
   *
   * @return boolean
   *   TRUE if logged-in user has an active membership, FALSE if not.
   */
  public static function userIsMember() {
    // Get Civi cid of logged-in user
    $session = CRM_Core_Session::singleton();
    $teacherCid = $session->get('userID');

    // Get their memberships, if any
    $teacherMemberships = civicrm_api('Membership', 'get', array(
      'version'    => 3,
      'sequential' => 1,
      'contact_id' => $teacherCid,
    ));
    if (civicrm_error($teacherMemberships)) {
      watchdog(
        'View and Edit Contact Page',
        'Error retrieving memberships for logged-in cid :tcid: :error',
        array(
          ':tcid'  => $teacherCid,
          ':error' => $teacherMemberships['error_message'],
        ),
        WATCHDOG_ERROR
      );
      return FALSE;
    }

    // Are any of them active?
    $activeStatuses = CRM_Member_BAO_MembershipStatus::getMembershipStatusCurrent();
    foreach ($teacherMemberships['values'] as $teacherMembership) {
      if (in_array($teacherMembership['status_id'], $activeStatuses)) {
        return TRUE;
      }
    }

    // None of them were active
    return FALSE;
  }
}
