<?php

require_once 'contactscreen.civix.php';

const CONTACTSCREEN_REL_TYPE_TEACHER = 10; // Main contact
const CONTACTSCREEN_REL_TYPE_STUDENT = 21; // School is

/**
 * Implementation of hook_civicrm_config
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_config
 */
function contactscreen_civicrm_config(&$config) {
  _contactscreen_civix_civicrm_config($config);
}

/**
 * Implementation of hook_civicrm_xmlMenu
 *
 * @param $files array(string)
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_xmlMenu
 */
function contactscreen_civicrm_xmlMenu(&$files) {
  _contactscreen_civix_civicrm_xmlMenu($files);
}

/**
 * Implementation of hook_civicrm_install
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_install
 */
function contactscreen_civicrm_install() {
  return _contactscreen_civix_civicrm_install();
}

/**
 * Implementation of hook_civicrm_uninstall
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_uninstall
 */
function contactscreen_civicrm_uninstall() {
  return _contactscreen_civix_civicrm_uninstall();
}

/**
 * Implementation of hook_civicrm_enable
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_enable
 */
function contactscreen_civicrm_enable() {
  return _contactscreen_civix_civicrm_enable();
}

/**
 * Implementation of hook_civicrm_disable
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_disable
 */
function contactscreen_civicrm_disable() {
  return _contactscreen_civix_civicrm_disable();
}

/**
 * Implementation of hook_civicrm_upgrade
 *
 * @param $op string, the type of operation being performed; 'check' or 'enqueue'
 * @param $queue CRM_Queue_Queue, (for 'enqueue') the modifiable list of pending up upgrade tasks
 *
 * @return mixed  based on op. for 'check', returns array(boolean) (TRUE if upgrades are pending)
 *                for 'enqueue', returns void
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_upgrade
 */
function contactscreen_civicrm_upgrade($op, CRM_Queue_Queue $queue = NULL) {
  return _contactscreen_civix_civicrm_upgrade($op, $queue);
}

/**
 * Implementation of hook_civicrm_managed
 *
 * Generate a list of entities to create/deactivate/delete when this module
 * is installed, disabled, uninstalled.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_managed
 */
function contactscreen_civicrm_managed(&$entities) {
  return _contactscreen_civix_civicrm_managed($entities);
}

/**
 * Implementation of hook_civicrm_caseTypes
 *
 * Generate a list of case-types
 *
 * Note: This hook only runs in CiviCRM 4.4+.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_caseTypes
 */
function contactscreen_civicrm_caseTypes(&$caseTypes) {
  _contactscreen_civix_civicrm_caseTypes($caseTypes);
}

/**
 * Implementation of hook_civicrm_alterSettingsFolders
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_alterSettingsFolders
 */
function contactscreen_civicrm_alterSettingsFolders(&$metaDataFolders = NULL) {
  _contactscreen_civix_civicrm_alterSettingsFolders($metaDataFolders);
}

/**
 * Gets contacts related to a certain contact by a certain relationship type.
 * 
 * Checks that the relationship is active and the contact is not deleted
 * in each case.
 *
 * @param int $contactIdA
 *   Contact ID on the A side of the relationship.
 * @param int $relationshipTypeId
 *   Get contacts related by this relationship type.
 * @param boolean $mustBeActive
 *   TRUE (default) if relationship must be active. FALSE if it doesn't matter either way.
 * @return array|null
 *   Array of contact IDs on the B side of relationships, empty if none, NULL on error
 */
function contactscreen_getrelatedcontacts($contactIdA, $relationshipTypeId, $mustBeActive = TRUE) {
  $params = array(
    'version'               => 3,
    'sequential'            => 1,
    'contact_id_a'          => $contactIdA,
    'relationship_type_id'  => $relationshipTypeId,
    'api.contact.getsingle' => array(
      'id'         => '$value.contact_id_b',
      'is_deleted' => FALSE,
    ),
  );
  if ($mustBeActive) {
    $params['is_active'] = TRUE;
  }
  $relResult = civicrm_api('Relationship', 'get', $params);
  if (civicrm_error($relResult)) {
    return NULL;
  }

  $relContacts = array();
  foreach ($relResult['values'] as $rel) {
    if (civicrm_error($rel['api.contact.getsingle'])) {
      continue;
    }
    $relContacts[] = $rel['api.contact.getsingle']['id'];
  }
  return $relContacts;
}

/**
 * Check whether student and teacher are attached to any of the same schools.
 *
 * @param int $teacherCid
 *   Contact ID of teacher- most likely the logged in user
 * @param int $studentCid
 *   Contact ID of student- most likely the one being edited
 * @return boolean
 *   TRUE if one or more schools have an active relationship to both the teacher and the student, FALSE if not.
 */
function contactscreen_teacherstudentoverlap($teacherCid, $studentCid) {
  $teacherSchools = contactscreen_getrelatedcontacts($teacherCid, CONTACTSCREEN_REL_TYPE_TEACHER);
  $studentSchools = contactscreen_getrelatedcontacts($studentCid, CONTACTSCREEN_REL_TYPE_STUDENT);
  return (count(array_intersect($teacherSchools, $studentSchools)) > 0);
}

/**
 * Check whether two teachers are attached to any of the same schools.
 *
 * @param int $teacherCidA
 *   Contact ID of one teacher, who must be active- most likely the logged in user
 * @param int $teacherCidB
 *   Contact ID of another teacher, who may or may not be active
 * @return boolean
 *   TRUE if one or more schools have an active relationship to both teachers, FALSE if not.
 */
function contactscreen_teacherteacheroverlap($teacherCidA, $teacherCidB) {
  $teacherSchoolsA = contactscreen_getrelatedcontacts($teacherCidA, CONTACTSCREEN_REL_TYPE_TEACHER, TRUE);
  $teacherSchoolsB = contactscreen_getrelatedcontacts($teacherCidB, CONTACTSCREEN_REL_TYPE_TEACHER, FALSE);
  return (count(array_intersect($teacherSchoolsA, $teacherSchoolsB)) > 0);
}

/**
 * Implementation of hook_civicrm_alterAPIPermissions
 * 
 * Temporarily relaxes permissions on certain API calls as required by the new view/edit contact interface.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_alterAPIPermissions
 */
function contactscreen_civicrm_alterAPIPermissions($entity, $action, &$params, &$permissions) {
  // Access control, members only
  if (!CRM_Contactscreen_Page_ContactView::userIsMember()) {
    return; // without altering any permissions
  }

//  watchdog(
//    'View and Edit Contact Page',
//    'Invoked alterAPIPermissions on :entity/:action, params: :params',
//    array(
//      ':entity' => $entity,
//      ':action' => $action,
//      ':params' => print_r($params, TRUE),
//    ),
//    WATCHDOG_DEBUG
//  );
  $relax = FALSE;

  // Break it up into several functions as the checks that need to be performed may differ
  if ($entity == 'contact' && in_array($action, array('setvalue', 'update'))) {
    $relax = contactscreen_alterAPIPermissions_contact_setvalue($entity, $action, $params, $permissions);
  }
  else if ($entity == 'relationship' && in_array($action, array('setvalue', 'update'))) {
    $relax = contactscreen_alterAPIPermissions_relationship_update($entity, $action, $params, $permissions);
  }
  else if (in_array($entity, array('address', 'email', 'phone')) && in_array($action, array('setvalue', 'update'))) {
    $relax = contactscreen_alterAPIPermissions_address_setvalue($entity, $action, $params, $permissions);
  }
  else if (in_array($entity, array('email', 'phone')) && in_array($action, array('create', 'get'))) {
    $relax = contactscreen_alterAPIPermissions_email_create($entity, $action, $params, $permissions);
  }
  else if ($entity == 'note' && $action == 'create') {
    $relax = contactscreen_alterAPIPermissions_note_create($entity, $action, $params, $permissions);
  }
  else if ($entity == 'student' && in_array($action, array('retrievecustomquestionanswers', 'retrieveeducation', 'retrieveemployment', 'retrievemobilisations', 'retrievenotes', 'setemployer', 'retrievecontactdetails'))) {
    $relax = contactscreen_alterAPIPermissions_student_retrieve($entity, $action, $params, $permissions);
  }
  else if ($entity == 'student' && $action == 'retrievecommunications') {
    $relax = contactscreen_alterAPIPermissions_student_retrievecommunications($entity, $action, $params, $permissions);
  }
  else if ($entity == 'student' && $action == 'getorganisations') {
    $relax = TRUE;
  }
  else if ($entity == 'option_value' && in_array($action, array('get', 'getcount'))) {
    $relax = contactscreen_alterAPIPermissions_optionvalue_get($entity, $action, $params, $permissions);
  }
  else if ($entity == 'note' && $action == 'setvalue') {
    $relax = contactscreen_alterAPIPermissions_note_setvalue($entity, $action, $params, $permissions);
  }

  if ($relax) {
    $permissions[$entity][$action] = array('access CiviCRM');
    // I was getting "1213 ** Deadlock found when trying to get lock; try restarting transaction"
    // regarding civicrm_acl_cache in the logs, this seems to fix it
    CRM_ACL_BAO_Cache::resetCache();
    watchdog(
      'View and Edit Contact Page',
      'Relaxing permissions on :entity/:action, params: :params',
      array(
        ':entity' => $entity,
        ':action' => $action,
        ':params' => print_r($params, TRUE),
      ),
      WATCHDOG_INFO
    );
  }
}

/**
 * Performs additional checks whether to relax permissions for contact/{setvalue,update}
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_contact_setvalue($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('id', $params)) {
    return FALSE;
  }
  $session = CRM_Core_Session::singleton();
  $teacherCid = $session->get('userID');
  $studentCid = $params['id'];

  // If logged-in user is a teacher at any of the schools student went to,
  // return true, relaxing the permissions and letting the API call through
  return contactscreen_teacherstudentoverlap($teacherCid, $studentCid);
}

/**
 * Performs additional checks whether to relax permissions for relationship/{setvalue,update}
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_relationship_update($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('id', $params)) {
    return FALSE;
  }
  $session = CRM_Core_Session::singleton();
  $teacherCid = $session->get('userID');
  $relId = $params['id'];

  $teacherSchools = contactscreen_getrelatedcontacts($teacherCid, CONTACTSCREEN_REL_TYPE_TEACHER);

  // Teacher can only edit relationship if it's an active student-school relationship from their school(s)
  $studentResult = civicrm_api('Relationship', 'getsingle', array(
    'version'               => 3,
    'id'                    => $relId,
    'relationship_type_id'  => CONTACTSCREEN_REL_TYPE_STUDENT,
    'is_active'             => TRUE,
    'api.contact.getsingle' => array(
      'id'         => '$value.contact_id_b',
      'is_deleted' => FALSE,
    ),
  ));
  if (civicrm_error($studentResult)) {
    return FALSE;
  }
  if (civicrm_error($studentResult['api.contact.getsingle'])) {
    return FALSE;
  }
  $studentSchools = array($studentResult['api.contact.getsingle']['id']);

  return (count(array_intersect($teacherSchools, $studentSchools)) > 0);
}

/**
 * Performs additional checks whether to relax permissions for {address,email,phone}/{setvalue,update}
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_address_setvalue($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('id', $params)) {
    return FALSE;
  }
  $session = CRM_Core_Session::singleton();
  $teacherCid = $session->get('userID');

  // Get the owner of the address we're trying to alter
  $studentCid = civicrm_api($entity, 'getvalue', array(
    'version' => 3,
    'id'      => $params['id'],
    'return'  => 'contact_id',
  ));
  if (civicrm_error($studentCid)) {
    return FALSE;
  }

  // Address can only be edited for your own students
  return contactscreen_teacherstudentoverlap($teacherCid, $studentCid);
}

/**
 * Performs additional checks whether to relax permissions for {email,phone}/{create,get}
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_email_create($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('contact_id', $params)) {
    return FALSE;
  }
  $session = CRM_Core_Session::singleton();
  $teacherCid = $session->get('userID');
  $studentCid = $params['contact_id'];

  // New email/phone can only be created, or existing one got, for your own students
  return contactscreen_teacherstudentoverlap($teacherCid, $studentCid);
}

/**
 * Performs additional checks whether to relax permissions for note/create
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_note_create($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('entity_id', $params)) {
    return FALSE;
  }
  $session = CRM_Core_Session::singleton();
  $teacherCid = $session->get('userID');
  $studentCid = $params['entity_id'];

  // Don't relax permissions on creation of notes as somebody else, or against entities other than Contacts
  if (array_key_exists('contact_id', $params) && $params['contact_id'] != $teacherCid) {
    return FALSE;
  }
  if (array_key_exists('entity_table', $params) && $params['entity_table'] != 'civicrm_contact') {
    return FALSE;
  }

  return contactscreen_teacherstudentoverlap($teacherCid, $studentCid);
}

/**
 * Performs additional checks whether to relax permissions for student/{retrievecustomquestionanswers,retrieveeducation,retrieveemployment,retrievemobilisations,retrievenotes,setemployer,retrievecontactdetails}
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_student_retrieve($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('iContactId', $params)) {
    return FALSE;
  }
  $session = CRM_Core_Session::singleton();
  $teacherCid = $session->get('userID');
  $studentCid = $params['iContactId'];

  // Don't relax permissions if looking up details on behalf of someone other than the teacher you're logged in as
  if (array_key_exists('iLoggedInUser', $params) && $params['iLoggedInUser'] != $teacherCid) {
    return FALSE;
  }
  return contactscreen_teacherstudentoverlap($teacherCid, $studentCid);
}

/**
 * Performs additional checks whether to relax permissions for student/retrievecommunications
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_student_retrievecommunications($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('student_id', $params)) {
    return FALSE;
  }
  $session = CRM_Core_Session::singleton();
  $teacherCid = $session->get('userID');
  $studentCid = $params['student_id'];

  return contactscreen_teacherstudentoverlap($teacherCid, $studentCid);
}

/**
 * Performs additional checks whether to relax permissions for optionvalue/{get,getcount}
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_optionvalue_get($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('option_group_id', $params)) {
    return FALSE;
  }

  // Option groups to relax permissions for
  return in_array($params['option_group_id'], array(
    // Employment
     90, // employment_status_20120622121237
     93, // employment_sector_20120627115455
    104, // occupation__training_or_governme_20121030144025
    // Education
     95, // further_education_subject_20120627120258
     97, // undergraduate_subject_20120627130515
     99, // apprenticeship_level_20121024113647
    100, // apprenticeship_sector_20121024114050
    103, // education__current_20121025104039
     91, // education_summary_20120627104157
     94, // a_levels_20120627120206
  ));
}

/**
 * Performs additional checks whether to relax permissions for note/setvalue
 *
 * @see contactscreen_civicrm_alterAPIPermissions
 * @return boolean
 *   TRUE if permission should be relaxed, FALSE if not
 */
function contactscreen_alterAPIPermissions_note_setvalue($entity, $action, &$params, &$permissions) {
  if (!array_key_exists('id', $params) || !array_key_exists('field', $params)) {
    return FALSE;
  }
  $session = CRM_Core_Session::singleton();
  $teacherCid = $session->get('userID');

  // Details of the note- and if it doesn't exist, we can't give perms on it
  $result = civicrm_api($entity, 'getsingle', array('version' => 3, 'id' => $params['id']));
  if (civicrm_error($result)) {
    return FALSE;
  }

  // Check that:
  // The note is against a Contact, not some other entity type
  // The note was written by a teacher (past/present) at one of logged-in teacher's schools
  // The field being edited is the subject or body of the note
  if (
    $result['entity_table'] != 'civicrm_contact' ||
    !contactscreen_teacherteacheroverlap($teacherCid, $result['contact_id']) ||
    !in_array($params['field'], array('subject', 'note'))
  ) {
    return FALSE;
  }
  $studentCid = $result['entity_id'];

  return contactscreen_teacherstudentoverlap($teacherCid, $studentCid);
}


