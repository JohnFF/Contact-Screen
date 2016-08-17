<?php

/**
 * Student.Getorganisations API specification (optional)
 * This is used for documentation and validation.
 *
 * @param array $spec description of fields supported by this API call
 * @return void
 * @see http://wiki.civicrm.org/confluence/display/CRM/API+Architecture+Standards
 */
function _civicrm_api3_student_getorganisations_spec(&$spec) {
  $spec['contact_sub_type']['api.required'] = 0;
  $spec['sequential']['api.required'] = 0;
}

/**
 * Student.Getorganisations API
 *
 * @param array $params
 * @return array API result descriptor
 * @see civicrm_api3_create_success
 * @see civicrm_api3_create_error
 * @throws API_Exception
 */
function civicrm_api3_student_getorganisations($params) {
  // Access control, members only
  if (!CRM_Contactscreen_Page_ContactView::userIsMember()) {
    throw new API_Exception('This API call is restricted to users with an active membership.');
  }

  $query = "
    SELECT `cc`.`id`                 AS `id`,
           `cc`.`display_name`       AS `display_name`,
           `cc`.`contact_sub_type`   AS `contact_sub_type`
      FROM `civicrm_contact`         AS `cc`
 LEFT JOIN `civicrm_value_school_1`  AS `cvs`
        ON `cvs`.`entity_id`          = `cc`.`id`
     WHERE `cc`.`contact_type`        = 'Organization'
       AND `cc`.`is_deleted`         IS NOT TRUE
       AND (
           `cvs`.`hide_in_search_options_270` IS NULL
        OR `cvs`.`hide_in_search_options_270` NOT LIKE '%1%'
           )
  ";
  if (!empty($params['contact_sub_type'])) {
    $query .= " AND `cc`.`contact_sub_type` LIKE '%" .
      CRM_Utils_Array::implodePadded(CRM_Core_DAO::escapeString($params['contact_sub_type'])) . "%' ";
  }
  $query .= " ORDER BY `cc`.`display_name` ASC ";

  $dao = CRM_Core_DAO::executeQuery($query);
  $returnValues = array();
  while ($dao->fetch()) {
    $thisOrg = array(
      // Core APIs unescape their output, we'll escape it on display
      'id'               => $dao->id,
      'display_name'     => html_entity_decode(trim($dao->display_name)),
      'contact_sub_type' => CRM_Utils_Array::explodePadded($dao->contact_sub_type),
    );

    if (array_key_exists('sequential', $params) && $params['sequential']) {
      $returnValues[] = $thisOrg;
    }
    else {
      $returnValues[$dao->id] = $thisOrg;
    }
  }

  return civicrm_api3_create_success($returnValues, $params, 'Student', 'Getorganisations');
}
