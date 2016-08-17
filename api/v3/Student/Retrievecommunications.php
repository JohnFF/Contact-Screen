<?php

const RETRIEVECOMMUNICATIONS_REL_TYPE_STUDENT      = 21;
const RETRIEVECOMMUNICATIONS_RECORD_TYPE_ID_TARGET =  3;

/**
 * Student.Retrievecommunications API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 * @return void
 * @see http://wiki.civicrm.org/confluence/display/CRM/API+Architecture+Standards
 */
function _civicrm_api3_student_retrievecommunications_spec(&$spec) {
  $spec['school_id'] = array(
    'title' => 'School/college contact ID',
    'type'  => CRM_Utils_Type::T_INT,
    'api.required' => 1,
  );
  $spec['student_id'] = array(
    'title' => 'Alumni contact ID',
    'type'  => CRM_Utils_Type::T_INT,
    'api.required' => 1,
  );
}

/**
 * Retrieve communications activities for a particular student at a particular school.
 *
 * Includes activities of certain types between the student and the school
 * and/or Future First, subject to constraints of how we create and store
 * communications activities and the privacy of some communications.
 * The dashboard mailbox is queried for all communications types in respect of
 * that student only.
 *
 * @param int $school_id
 *   Contact ID of the school
 * @param int $student_id
 *   Contact ID of the student/alumnus
 * @return array
 *   Array of details of activities
 */
function student_retrievecommunications_do_activities_query($school_id, $student_id) {
  $mailboxApiResult = civicrm_api('Activity', 'getmailbox', array(
    'version'    => 3,
    'sequential' => 1,
    'school_id'  => $school_id,
    'student_id' => $student_id,
    'type'       => array('email', 'sms', 'phone'),
    'direction'  => array('inbox', 'outbox'),
    'api.ActivityContact.getcount' => array(
      // 'activity_id' => '$value.id', is implicit
      'record_type_id' => RETRIEVECOMMUNICATIONS_RECORD_TYPE_ID_TARGET,
    ),
  ));
  if (civicrm_error($mailboxApiResult)) {
    return NULL;
  }

  foreach ($mailboxApiResult['values'] as &$result) {
    switch ($result['type']) {
      case 'email':
        $result['activity_type_name'] = 'E-mail';
        break;
      case 'sms':
        $result['activity_type_name'] = 'SMS';
        break;
      case 'phone':
        $result['activity_type_name'] = 'Phone Call';
        break;
    }

    // Get the source contact (there should be max 1)
    $result['from_cid']  = $result['source_contact_id'];
    $result['from_name'] = $result['display_name'];

    // Get the count of target contacts as a starting point for the (and X others) value
    $result['to_more']     = $result['api.ActivityContact.getcount'];
    $result['to_contacts'] = array();

    // If it's 'to' the student, the student is the only one we want to show in the 'to' column
    if ($result['direction'] == 'outbox') {
      $tcname = civicrm_api('Contact', 'getvalue', array(
        'version' => 3,
        'id'      => $student_id,
        'return'  => 'display_name',
      ));
      if (!civicrm_error($tcname)) {
        $result['to_contacts'][$student_id] = $tcname;
        $result['to_more']--;
      }
    }

    // Else show a limited number
    else {
      $tcids = civicrm_api('Activity', 'getvalue', array(
        'version' => 3,
        'id'      => $result['id'],
        'return'  => 'target_contact_id',
      ));
      if (!civicrm_error($tcids)) {
        for ($added = 0; $added < 5 && $added < count($tcids); $added++) {
          $tcname = civicrm_api('Contact', 'getvalue', array(
            'version' => 3,
            'id'      => $tcids[$added],
            'return'  => 'display_name',
          ));
          if (!civicrm_error($tcname)) {
            $result['to_contacts'][$tcids[$added]] = $tcname;
            $result['to_more']--;
          }
        }
      }
    }

  }
  return $mailboxApiResult['values'];
}

/**
 * Retrieve Mailings for a particular student at a particular school.
 * 
 * Includes both E-mail and SMS mailings. Simulates the output of the
 * activities function.
 *
 * TODO: Because we don't know which school a Mailing is regarding,
 * the $school_id parameter is currently unused and all Mailings targeting
 * a particular student will be returned.
 *
 * @param int $school_id
 *   Contact ID of the school
 * @param int $student_id
 *   Contact ID of the student/alumnus
 * @return array
 *   Array of details of mailings
 */
function student_retrievecommunications_do_mailings_query($school_id, $student_id) {
  // Student as a mailing recipient
  $recipients = civicrm_api('MailingRecipients', 'get', array(
    'version'    => 3,
    'sequential' => 1,
    'contact_id' => $student_id,
    'rowCount'   => 0, // Use the count to override the default API limit of 25
    // The Mailing itself
    'api.mailing.getsingle' => array(
      'id'           => '$value.mailing_id',
      'is_completed' => 1,
      // 'From' name will be the creator of the mailing
      'api.contact.getvalue' => array(
        'id'     => '$value.created_id',
        'return' => 'display_name',
      ),
      // Count of recipients of the mailing
      'api.mailingrecipients.getcount' => array(
        // 'mailing_id' => '$value.id' is implicit
      ),
    ),
    // Student's name
    'api.contact.getvalue' => array(
      'id'     => '$value.contact_id',
      'return' => 'display_name',
    ),
  ));
  if (civicrm_error($recipients)) {
    return NULL;
  }

  // Process the results of the API call into a similar format to the activities function above
  $results = array();
  foreach ($recipients['values'] as $recipient) {
    if (civicrm_error($recipient['api.mailing.getsingle'])) {
      continue;
    }
    $results[] = array(
      'id'                 => $recipient['api.mailing.getsingle']['id'],
      'activity_date_time' => $recipient['api.mailing.getsingle']['scheduled_date'],
      'activity_type_id'   => NULL,
      // SMS Mailings don't have a subject line, use the FF-internal name
      'subject'            => $recipient['api.mailing.getsingle']['subject'] ?: $recipient['api.mailing.getsingle']['name'],
      // SMS vs. e-mail Mailings are identified by the presence vs. absence of an sms_provider_id
      'activity_type_name' => array_key_exists('sms_provider_id', $recipient['api.mailing.getsingle']) ? 'SMS Mailing' : 'Mailing',
      'from_cid'           => $recipient['api.mailing.getsingle']['created_id'],
      'from_name'          => $recipient['api.mailing.getsingle']['api.contact.getvalue'],
      // Name this student, but not all the others (there may be thousands)
      'to_more'            => $recipient['api.mailing.getsingle']['api.mailingrecipients.getcount'] - 1,
      'to_contacts'        => array($recipient['contact_id'] => $recipient['api.contact.getvalue']),
    );
  }
  return $results;
}

/**
 * Student.Retrievecommunications API
 *
 * Retrieves details of mailings and certain types of activity (ie. communications),
 * between an alumnus and a school (and/or its teachers) or Future First (and/or its employees).
 *
 * There is a possible problem where if a teacher has communicated with an
 * alumnus and there is more than one school that they both have, it is
 * unclear which of those schools the communication was regarding
 * (it will be returned for both schools).
 *
 * Doesn't care about the 'sequential' parameter that 'get' has.
 * Records are returned in no particular order.
 *
 * @param array $params
 * @return array API result descriptor
 * @see civicrm_api3_create_success
 * @see civicrm_api3_create_error
 * @throws API_Exception
 */
function civicrm_api3_student_retrievecommunications($params) {
  // Access control, members only
  if (!CRM_Contactscreen_Page_ContactView::userIsMember()) {
    throw new API_Exception('This API call is restricted to users with an active membership.');
  }

  // Check the student went to that school
  $result = civicrm_api('Relationship', 'getcount', array(
    'version'              => 3,
    'contact_id_a'         => $params['student_id'],
    'contact_id_b'         => $params['school_id'],
    'relationship_type_id' => RETRIEVECOMMUNICATIONS_REL_TYPE_STUDENT,
    'is_active'            => 1,
  ));
  if (civicrm_error($result)) {
    throw new API_Exception("Error checking relationship between student_id {$params['student_id']} and school_id {$params['school_id']}.");
  }
  if ($result < 1) {
    throw new API_Exception("student_id {$params['student_id']} is not an alumnus/a of school_id {$params['school_id']}.");
  }

  $activities   = student_retrievecommunications_do_activities_query($params['school_id'], $params['student_id']);
  $mailings     = student_retrievecommunications_do_mailings_query($params['school_id'], $params['student_id']);
  $returnValues = array_merge($activities, $mailings);

  return civicrm_api3_create_success($returnValues, $params, 'Student', 'Retrievecommunications');
}
