<div class="contactScreenTabContents" id="basicTabContents">
{if $summary.image_URL}
<!--<span><img src="{$summary.image_URL}"></img></span>-->
{/if}
{assign var=showCurrentlyOther value='Doing_something_else'}
<table>
    <tr>
      <td width="30%">
        <strong>First name</strong>
        <span corresponding_success_icon="#basic_details_first_row_icon" id="contact-{$cid}" class="crmf-first_name crm-editable show_update_success" data-action="create">{$summary.first_name}</span>
      </td>
      <td width="30%">
        <strong>Middle name(s)</strong>
        <span corresponding_success_icon="#basic_details_first_row_icon" id="contact-{$cid}" class="crmf-middle_name crm-editable show_update_success" data-action="create">{$summary.middle_name}</span>
      </td>
      <td width="40%">
        <strong>Last name</strong>
        <span corresponding_success_icon="#basic_details_first_row_icon" id="contact-{$cid}" class="crmf-last_name crm-editable show_update_success" data-action="create">{$summary.last_name}</span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="basic_details_first_row_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Previous name</strong>
        <span corresponding_success_icon="#basic_details_second_row_icon" id="contact-{$cid}" class="crmf-custom_262 crm-editable show_update_success">{$summary.previous_name}</span>
      </td>
      <td>
        <strong>Nickname</strong>
        <span corresponding_success_icon="#basic_details_second_row_icon" id="contact-{$cid}" class="crmf-nick_name crm-editable show_update_success">{$summary.nick_name}</span>
      </td>
      <td>
        <strong>Birth date<p></strong>
        <select corresponding_success_icon="#basic_details_second_row_icon" id="birthday_day" class="birthdate" contact_id="{$cid}">
          <option id="day_default" value="-1"> - </option>
            {foreach from=$dateDays item=day }
              <option id="day_{$day}" {if $summary.birth_day == $day} selected{/if} value="{$day}">{$day}</option>
            {/foreach}
        </select>
        <select corresponding_success_icon="#basic_details_second_row_icon" id="birthday_month" class="birthdate" contact_id="{$cid}">
          <option value="-1"> - </option>
            {foreach from=$dateMonths item=month }
              <option {if $summary.birth_month == $month} selected{/if} value="{$month}">{$month}</option>
            {/foreach}
        </select>
        <select corresponding_success_icon="#basic_details_second_row_icon" id="birthday_year" class="birthdate" contact_id="{$cid}">
          <option value="-1"> - </option>
            {foreach from=$dateYears item=year }
              <option {if $summary.birth_year == $year} selected{/if} value="{$year}">{$year}</option>
            {/foreach}
        </select>
        </td>
        <td class="view_screen_icon_wrapper">
          <span id="basic_details_second_row_icon" class="crm-status-icon success" style="display: none"> </span>
        </td>
    </tr>
    <tr>
      <td><strong>Gender</strong>
        <select corresponding_success_icon="#basic_details_gender_row_icon" id="contact-{$cid}" contact_id="{$cid}" class="select_setGenderId show_update_success">
            <option value="">- select -</option>
            {crmAPI var="OptionValueS" entity="OptionValue" action="get" sequential="1" option_group_name="gender" is_active="1" option_sort="weight"}
            {foreach from=$OptionValueS.values item=OptionValue}
                <option {if $summary.gender_id == $OptionValue.value} selected{/if} value="{$OptionValue.value}">{$OptionValue.label}</option>
            {/foreach}
        </select>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="basic_details_gender_row_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
      <td></td>
    </tr>
</table>
<table>
    <tr> 
      <td width="50%">
        <strong>Leaving year</strong>
        <select class="show_update_success" corresponding_success_icon="#basic_details_third_row_icon" id="schoolToStudentData" contact_id="{$cid}" relationship_id="{$iRelationshipId}">
        <option value="-1">- select -</option> 
        {foreach from=$possible_leaving_years key=PossibleLeavingYearKey item=PossibleLeavingYearValue}
                <option {if $summary.leaving_year == $PossibleLeavingYearValue} selected{/if} value="{$PossibleLeavingYearValue}">{$PossibleLeavingYearValue}</option>
        {/foreach}
        </select>
      </td>
      <td width="50%">
        {if ($institutionType == 'school') }
          <strong>Leaving year group</strong>      
          <select class="show_update_success" corresponding_success_icon="#basic_details_third_row_icon" id="schoolToStudentData_LeavingYearGroup" class="schoolToStudentData" contact_id="{$cid}" relationship_id="{$iRelationshipId}">
            {foreach from=$possible_leaving_year_groups key=PossibleLeavingYearGroupKey item=PossibleLeavingYearGroupValue}
              <option {if $summary.leaving_year_group == $PossibleLeavingYearGroupValue} selected{/if} value="{$PossibleLeavingYearGroupValue}">{$PossibleLeavingYearGroupKey}</option>
            {/foreach}
          </select>
        {/if}
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="basic_details_third_row_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
</table>

{* TODO: Remove this at some point following switch to multi-select. Saved in case of emergency.
<table>
  <tr>
    <td>
      <strong>Currently</strong>
    </td>
    <td>
      <select style="width: 80%; text-overflow: ellipsis" corresponding_success_icon="#basic_details_currently_row_icon" id="currently_select" class=" show_update_success">
            <option value="">- select -</option>
            {crmAPI var="OptionValueS" entity="OptionValue" action="get" sequential="1" option_group_name="what_are_you_doing_now__20120622114310" is_active="1" option_sort="weight"}
            {foreach from=$OptionValueS.values item=OptionValue}
                <option {if $summary.currently == $OptionValue.value} selected{/if} value="{$OptionValue.value}">{$OptionValue.label}</option>
            {/foreach}
        </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="basic_details_currently_row_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
    
  </tr>
  <tr id="currently_other" {if $summary.currently != $showCurrentlyOther} style="display : none;"{/if}>
    <td>
      <strong>Other</strong>
    </td>
    <td>
      <span corresponding_success_icon="#basic_details_currently_other_row_icon" id="contact-{$cid}" class="crmf-custom_34 crm-editable show_update_success" data-action="create">{$summary.currently_other}</span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="basic_details_currently_other_row_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
</table>
*}

<table>
  <tr>
    <td>
      <strong>Currently</strong>
      <br/>
      {foreach from=$summary.occupation item=Occ}
        <input corresponding_success_icon="#basic_details_occupation_icon" type="checkbox" class="show_update_success occupation" {$Occ.checked} value="{$Occ.value}">&nbsp;{$Occ.label}
        <br/>
      {/foreach}          
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="basic_details_occupation_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr id="occupation-additional">
    <td>
      <strong>Additional options</strong>
      <br/>
      {foreach from=$summary.occupation_additional item=OccAdd}
        <input corresponding_success_icon="#basic_details_occupation_additional_icon" type="checkbox" class="show_update_success occupation-additional" {$OccAdd.checked} value="{$OccAdd.value}">&nbsp;{$OccAdd.label}
        <br/>
      {/foreach}          
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="basic_details_occupation_additional_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr id="occupation-other">
    <td>
      <strong>Other</strong>
      <br/>
      <span corresponding_success_icon="#basic_details_currently_other_row_icon" id="contact-{$cid}" class="crmf-custom_34 crm-editable show_update_success" data-action="create">{$summary.currently_other}</span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="basic_details_currently_other_row_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
</table>

<table>
    <tr>
      <td>
        <strong>Support offered<br></strong>   
          {foreach from=$summary.how_want_to_help item=HowWantToHelp}
            {if $HowWantToHelp.value != 'Other'} 
              <input corresponding_success_icon="#basic_details_offered_support_icon" type="checkbox" class="show_update_success support-offered" {$HowWantToHelp.checked} value="{$HowWantToHelp.value}">&nbsp{$HowWantToHelp.label}
              <br/>
            {/if}
          {/foreach}          
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="basic_details_offered_support_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Other support offered<br></strong>
          <span corresponding_success_icon="#basic_details_other_support_icon" contact_custom_field="custom_43" id="relationship-{$iRelationshipId}" class="crm-entity crmf-custom_113 crm-editable relationship-inline-edit show_update_success">{$summary.other_support_offered}</span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span align="center" id="basic_details_other_support_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
</table>
<a href="#" class="button" id="delete-contact-button" title="Removes this contact from your school/college's network.">Delete contact</a>
</div>

{literal}
<script type="text/javascript" language="javascript">
  var showCurrentlyOther = "{/literal}{$showCurrentlyOther}{literal}";
  function setClassDisabled(checkboxClass, status){
    cj.each(cj(checkboxClass), function(optionKey, optionValue){
      cj(optionValue).attr("disabled", status);
    }); 
  }
  /**
   * This function takes care of showing only the correct days on 
   * the dropdown menu according to the month, e.g. for february
   * the days 30 and 31 will not be show and the day 29 will only
   * be shown if it is a leap year
   * @param int month -  number of the month (e.g. 01, 03, 10)
   * @param bool isLeap - is the current year a leap year
   * @param int day - day of the month
   */
  function sanitizeDay (month, isLeap, day){
    var maxDay = 31;
    switch (month) {
      case "02" :
        cj('#day_31').hide();
        cj('#day_30').hide();
        // hide 31 and 30
        // is not leapyear? if so hide 29
        if (!isLeap){
          cj('#day_29').hide();
          maxDay = 28;
        } 
        else {
          cj('#day_29').show();
          maxDay = 29;
        }       
        break;
      case "04":
      case "06":
      case "09":
      case "11":
        cj('#day_29').show();
        cj('#day_30').show();
        
        cj('#day_31').hide();
        // show all except 31 (show thw ones disabled by feb)
        maxDay = 30;        
        break;
      case "01":
      case "03":
      case "05":
      case "07":
      case "08":
      case "10":
      case "12":
        // show all days
        cj('#day_29').show();
        cj('#day_30').show();
        cj('#day_31').show();
        maxDay = 31;
        break;
    }
    if ( day > maxDay ){
      cj('#birthday_day').val(cj('#day_default'));
    }
  }
  /**
   * This function deals with setting the correct values of the year/month/day
   * dropdown menus
   * @returns {Boolean|String} false|birth_date -  will return false if there is
   * at least one empty field, or else it will return the corrent birth 
   * date string
   */
  function sanitizeBirthDate(){
    var year  = cj('#birthday_year').val();
    // see if a year is selected
    if ( year == -1 ) {
      // no year selected 
      // show all days in the days dropdown
      cj('#day_29').show();
      cj('#day_30').show();
      cj('#day_31').show();
    }
    
    var day = cj('#birthday_day').val();    
    
    // hack to determine if is leap year
    var isLeap = new Date(year, 1, 29).getMonth() == 1;
    
    var month = cj('#birthday_month').val();
    // see if a month is selected
    if ( month == -1 ) {
      // no month selected
      cj('#day_29').show();
      cj('#day_30').show();
      cj('#day_31').show();
    }
    // this makes changes to the day dropdown in 
    // accordance to the month selected
    sanitizeDay(month, isLeap, day);
    // validate day 
    if ( day == -1 ){
      // no day selected
      // show all days in the days dropdown
      cj('#day_29').show();
      cj('#day_30').show();
      cj('#day_31').show();
    }
    // If they are all empty returns false (will clear custom data)
    if (year == -1 &&  month == -1 && day == -1 ){      
      return false;
    }
    // If at least one of them is empty return empty so not update will occurr
    if (year == -1 ||  month == -1 || day == -1 ){      
      return "";
    }
    // return the formated date string
    var birth_date = year + "-" + month  + "-" + day;
    return birth_date;
  }

  /**
   * Updates a multiple-select checkbox field on some entity.
   *
   * @param {string} selector jQuery selector covering the checkboxes for the field eg. '.selector'
   * @param {string} field    Custom field identifier eg. 'custom_999'
   * @param {string} type     Entity type eg. 'Contact'
   * @param {int}    id       Entity ID
   * @returns {void}
   */
  function updateCheckboxField(selector, field, type, id) {
    // Disable all the checkboxes to prevent incoherent API calls.
    setClassDisabled(selector, true);

    // Get a list of all the checked options only, to update the field
    var checked_options = new Object();
    cj(selector).each(function(optionKey, optionValue) {
      if (cj(optionValue).attr('checked')) {
        checked_options[cj(optionValue).val()] = 1;
      }
    });

    // Save the selected options
    var update_params = {
      'version': 3,
      'id': id
    };
    update_params[field] = checked_options;
    CRM.api(type, 'create', update_params, {
      success: function() {
        // Re-enable the checkboxes
        setClassDisabled(selector, false);
      }
    });
  };

  /**
   * Show the additional occupation options only when 'Doing something else' is
   * checked in the primary occupation options. Show the 'Other' box only when
   * 'Other' is ticked again. This corresponds to the FS-MS-S3-II webform changes.
   *
   * @returns {void}
   */
  function updateOccupationVisibility() {
    currentlyOther = cj('.occupation[value="Doing_something_else"]:checked').length;
    addOther       = cj('.occupation-additional[value="Other"]:checked').length;

    if (currentlyOther > 0) {
      cj('#occupation-additional').fadeIn();
    }
    else {
      cj('#occupation-additional').fadeOut();
    }

    if (currentlyOther > 0 && addOther > 0) {
      cj('#occupation-other').fadeIn();
    }
    else {
      cj('#occupation-other').fadeOut();
    }
  }

  cj(document).ready(function() {
    // is the logged in teacher from the same school
    // as the contact's current data?
    var isTeacherCustomData = {/literal}{$isTeacherSameSchoolCustomData}{literal};
    // make sure unexisting dates don't appear on the dropdowns
    sanitizeBirthDate();
    updateOccupationVisibility();

    /**
     *  Listener for the inline editatable fields for the 
     *  relationship between the school and the contact.
     *  Saves the contact's school custom data if the 
     *  logged in teacher is from the same school.
     *  This listener is prepated to support more text fields in the future.
     */
    
    cj('.relationship-inline-edit').delegate('input', 'change', function() {
      // If the teacher is not from the same school as the custom data bail.
      if ( isTeacherCustomData != true ){
        return false;
      }
      // Get the new other support offered string.
      var other_support_offered = cj(this).val();
      // Get the custom field ID from the span, this way this code can support
      // the adition of more custom fields.
      // First parent <form>, second parent <span>.
      var contact_data_support_other_custom_field = cj(this).parent().parent().attr("contact_custom_field");
      // Build the API parameters object.
      var update_contact_params = {
        'version' : 3,
        'sequential' : 1,
        'id' : {/literal}{$cid}{literal},
      }
      // Add the custom field parameter to the object.
      update_contact_params[contact_data_support_other_custom_field] = other_support_offered;
      // Save the data.
      CRM.api('Contact', 'create', update_contact_params,{
        success : function(){
        }
      });  
    });

    /**
     * Listener for the "Currently" / "Occupation" checkboxes
     */
    cj('.occupation').change(function() {
      updateCheckboxField('.occupation', 'custom_386', 'Contact', {/literal}{$cid}{literal});
      updateOccupationVisibility();
    });

    /**
     * Listener for the additional occupation checkboxes
     */
    cj('.occupation-additional').change(function() {
      updateCheckboxField('.occupation-additional', 'custom_387', 'Contact', {/literal}{$cid}{literal});
      updateOccupationVisibility();
    });

    /**
     * Listener for the "Support Offered" checkboxes
     * It will update the relationship and also the 
     * contact's custom data if the logged in teacher is from the
     * same school.
     */
    cj('.support-offered').change(function(){
      // Disable all the checkboxes to prevent 
      // incoherent API calls.
      setClassDisabled('.support-offered', true);
      
      // Set correspondent custom field.
      var relationship_support_offered_custom_field = 'custom_112';

      var support_offered_custom_data = new Object();
      // Get all the checked options to update the field
      cj.each(cj('.support-offered'), function(optionKey, optionValue){
        if(cj(optionValue).attr("checked")){
          // If the option is checked add it to the object
          support_offered_custom_data[cj(optionValue).val()] = 1;
        }
      }); 
      // Build the API parameters object.
      var update_relationship_params = {
        'version' : 3,
        'sequential' : 1,
        'id' : '{/literal}{$iRelationshipId}{literal}',        
      }
      // Add the custom field to the parameters,
      // the custom field is an array that has the checked options
      // e.g. {Apply_to_become_a_Governor : 1, Fundraise_Donate_for_specific_school_needs : 1 }
      update_relationship_params[relationship_support_offered_custom_field] = support_offered_custom_data;
      // Update the relationship data.
      CRM.api('Relationship' ,'create', update_relationship_params,
      { success:function(){
          // If there is not going to be any contact update
          // enable all the checkboxes
          if (isTeacherCustomData != true){
            // Enable the checkboxes
            setClassDisabled('.support-offered', false);
          }
        }        
      });

      // Is the logged in teacher from the same school as the student's custom data?
      if (isTeacherCustomData == true) {
        updateCheckboxField('.support-offered', 'custom_42', 'Contact', {/literal}{$cid}{literal});
      }
    });

    // add the functionality to save the new gender type if it's changed 
    cj('.select_setGenderId').change(function() {
      var contact_id = cj(this).attr("contact_id");
      var new_value = cj(this).attr("value");  
      var success_icon_id = cj(this).attr("corresponding_success_icon");
      CRM.api('Contact','update',{ id:contact_id, gender_id:new_value }
              ,{ success:function (){
                  showSuccessIcon(success_icon_id);              }
      });     
      return false;
    });
    
    /**
     * Birthdate listener.
     * The listener will only save the date if:
     *  - It's a correct date; (all fields are filled)
     *  - All the fields have been deselected.
     */
    cj('.birthdate').change(function(){

      var birth_date = sanitizeBirthDate();

      // if the string is empty bailout
      // not using false because if it is false it should clear the custom data
      if (birth_date === ''){
        return false;
      }
      // Get the correct success icon
      var success_icon_id = cj(this).attr("corresponding_success_icon");
      // TODO add validation to dates (e.g. feb 31);
      CRM.api('Contact', 'create',{
        'sequential': 1,
        'id' : {/literal}{$cid}{literal},
        'birth_date':  birth_date,
        'contact_type': 'Individual', 
        'contact_sub_type': 'student'
      },
        {success: function(data) {
            showSuccessIcon(success_icon_id);
        }});
      return false;
    });
    // if the school custom data of the alumnus
    // is the logged in school then adjustments to the leaving year
    // and leaving year group change the custom data as well as the relationship.
    cj('#schoolToStudentData').change(function(){
      var schoolIsRelId = 21;
      // Hack to match the date field in civi,
      // if it is not here will not save properly
      var new_value = cj(this).attr("value");
      var correctedDate = '';
      if (new_value == parseInt(new_value) && new_value > 0){
        // create a new date object to fetch other date pieces.
        var leavingYear = new Date();
        var correctedDate = new_value + "-" + leavingYear.getMonth() + "-" + leavingYear.getDay();
      }   

      // Is this logged in teacher from the same school as the custom data?
      if(isTeacherCustomData == true){
        // Update the contact custom data
         CRM.api('Contact', 'create', {
             'sequential': 1, 
             'id': cj(this).attr("contact_id"), 
             'custom_32': correctedDate, 
             'contact_type': 'Individual', 
             'contact_sub_type': 'student'
         },
         {success: function(data) {

         }
         });
      }
      // Update relationship custom data 
      CRM.api('Relationship', 'create', {
           'sequential': 1, 
           'id': cj(this).attr("relationship_id"),
           'custom_111': correctedDate, 
           'relationship_type_id': schoolIsRelId
       },
       {success: function(data) {

       }

       });

    });
    // Listener for the Leaving Group Year dropdown
    cj('#schoolToStudentData_LeavingYearGroup').change(function() {
      var schoolIsRelId = 21;
      /* two updates: one for the contact's custom data, one for the relationship's custom data */
      // Is this logged in teacher from the same school as the custom data?
      if(isTeacherCustomData == true){
        CRM.api('Contact', 'create', {
            'sequential': 1, 
            'id': cj(this).attr("contact_id"), 
            'custom_12': cj(this).attr("value"), 
            'contact_type': 'Individual', 
            'contact_sub_type': 'student'
        },
        {success: function(data) {

        }
        });
      }

      CRM.api('Relationship', 'create', {
          'sequential': 1, 
          'id': cj(this).attr("relationship_id"),
          'custom_259': cj(this).attr("value"), 
          'relationship_type_id': schoolIsRelId
      },
      {success: function(data) {

      }

      });
    });

    // Enable the delete contact button
    cj('#delete-contact-button').click(function() {
      var activityTypeIdDeleteStudent = 114; // 'Deleted from network'
      if (!confirm("Do you want to delete this contact?")) {
        return false;
      }
      // Call the API to disable the relationship
      CRM.api('Relationship', 'create', {
        'id':        {/literal}{$iRelationshipId}{literal},
        'is_active': 0
      }, { success: function(data) {
        // Record it with an activity
        CRM.api('Activity', 'create', {
          'activity_type_id':  activityTypeIdDeleteStudent,
          'source_contact_id': {/literal}{$loggedInUserCiviId}{literal},
          'target_contact_id': [{/literal}{$cid}{literal}, {/literal}{$schoolId}{literal}],
          'details':           'Disabled relationship {/literal}{$iRelationshipId}{literal}'
        }, { success: function(data) {
          // If successful, redirect to school dashboard
          window.location = '/school-dashboard';
        }});
      }});
      // Prevent jumping to top of page
      return false;
    });
    
    // Listener for the 'Currently' dropdown
    // TODO: Remove this at some point following switch to multi-select. Saved in case of emergency.
    /*cj('#currently_select').change(function(){
    
      var selectedValue = this.value;
      // If the "Doing something else" option was selected,
      // show the "Other" field.
      if (selectedValue == showCurrentlyOther) {
        cj('#currently_other').fadeIn();
      }
      else {
        cj('#currently_other').hide();
      }
      // Do the API call.
      CRM.api('Contact', 'create', {
            'version' : 3,
            'sequential': 1, 
            'id': {/literal}{$cid}{literal}, 
            'custom_33': selectedValue, 
        },
        {success: function(data) {            

        }
        });
    
    });*/

  });
</script>
{/literal}
