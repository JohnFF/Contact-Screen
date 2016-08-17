{assign var="UNEMPLOYED_EMPLOYER_CODE" value="-1"}
{* Hidding the datalists to that they don't appear on IE as an empty select box. *}
<datalist id="employer_organisations_list" style="display: none">
  <select onchange="cj('#employer_select_and_enter').val(this.value)">{* Supports older browsers *}
    {* gets populated by jQuery below *}
  </select>
</datalist>
<datalist id="gov_employer_organisations_list" style="display: none">
  <select onchange="cj('#gov_employer_select_and_enter').val(this.value)">{* Supports older browsers *}
    {* gets populated by jQuery below *}
  </select>
</datalist>

<div class="contactScreenTabContents" id="employmentTabContents" style="display: none">
  <div  style="text-align: center;" class="loading"><span class="loading"><strong>Loading, please wait...</strong></span></div>
   <table  style="display: none" id='employmentTable'>
    <tr>
      <td>
        <strong>Employer</strong>
      </td>
      <td>
        <input corresponding_success_icon="#employment_employer_name_icon" list="employer_organisations_list" style="width: 95%;" contact_id ='{$cid}' 
               id='employer_select_and_enter' class="show_update_success" value="{$summary.current_employer}"> 
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="employment_employer_name_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Job title</strong>
      </td>
      <td>
        <span corresponding_success_icon="#employment_job_title_icon" id="contact-{$cid}" class="crmf-job_title crm-editable show_update_success">{$summary.job_title}</span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="employment_job_title_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Employment status</strong>
      </td>
      <td id="employment_status">
        <select corresponding_success_icon="#employment_employment_status_icon" contact_id ='{$cid}' id='custom_37_select' custom_field='custom_37' class="custom-dropdown show_update_success">
          <option>- select -</option>
        </select>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="employment_employment_status_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>      
    <tr>
      <td>
        <strong>Employment status other</strong>
      </td>
      <td id="employment_status_other" >
        <span corresponding_success_icon="#employment_employment_status_other_icon" id="contact-{$cid}" class="crmf-custom_39 crm-editable custom_39 show_update_success" ></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="employment_employment_status_other_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Employment sector</strong>
      </td>
      <td id="employment_sector">
        <select corresponding_success_icon="#employment_employment_sector_icon" contact_id ='{$cid}' id='custom_44_select' custom_field='custom_44' class="custom-dropdown show_update_success">
          <option>- select -</option>
        </select>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="employment_employment_sector_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Government scheme</strong>
      </td>
      <td id="employment_government_scheme">
        <select corresponding_success_icon="#employment_gov_scheme_icon" contact_id ='{$cid}' id='custom_71_select' custom_field='custom_71' class="custom-dropdown show_update_success">
          <option>- select -</option>
        </select>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="employment_gov_scheme_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Government scheme employer</strong>
      </td>
      <td id="employment_government_employer">
        <input corresponding_success_icon="#employment_gov_employer_icon" list="gov_employer_organisations_list" style="width: 95%;" contact_id ='{$cid}'
               id='gov_employer_select_and_enter' class="show_update_success" value="">
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="employment_gov_employer_icon" class="crm-status-icon success" style="display: none"></span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Government scheme details</strong>
      </td>
      <td id="employment_government_details">
        <span corresponding_success_icon="#employment_gov_details_icon" id="contact-{$cid}" class="crmf-custom_326 crm-editable custom_326 show_update_success"></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="employment_gov_details_icon" class="crm-status-icon success" style="display: none"></span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Career history</strong>
      </td>
      <td id="career_history">
        <span corresponding_success_icon="#career_history_icon" id="contact-{$cid}" class="crmf-custom_282 crm-editable custom_282 show_update_success"></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="career_history_icon" class="crm-status-icon success" style="display: none"></span>
      </td>
    </tr>
  </table>
</div>

{literal}
<script type="text/javascript" language="javascript">

  cj(document).ready(function() {
    // Employment API Call
    cj('#employmentButton').click(function() {
      var employment_status_custom_field = 'custom_37';
      var employment_status_other_custom_field = 'custom_39';
      var employment_sector_custom_field = 'custom_44';
      var gov_scheme_custom_field = 'custom_71';
      var gov_employer_custom_field = 'custom_78';
      var gov_details_custom_field = 'custom_326';
      var career_history_custom_field = 'custom_282';
      var employment_status_group_id = 90;
      var employment_sector_group_id = 93;
      var gov_scheme_group_id = 104;

      if (cj(this).attr('loaded') == "false") {
        var tabToShow = cj(this).attr('tabToShow');

        var EMPLOYMENT_CUSTOM_FIELD_DATA_INDEX = 0;

        // Load the data here for the form  (dropdowns)
        // and then populate the fields
        // Retrieves the contact's custom data.
        CRM.api('Student', 'retrieveemployment', {
          'version': 3, 
          'sequential': 1, 
          'iContactId' :{/literal}{$cid}{literal},
          },
          {success: function(data) {
            cj.each(data['values'][EMPLOYMENT_CUSTOM_FIELD_DATA_INDEX], function(key, value) {
              // Switch statement to create and populate every custom field
              switch (value.id){
                case employment_status_custom_field:
                  populateCustomDropdown(value.id, value.value, employment_status_group_id);
                  break;
                case employment_sector_custom_field:
                  populateCustomDropdown(value.id, value.value, employment_sector_group_id);
                  break
                case gov_scheme_custom_field:
                  populateCustomDropdown(value.id, value.value, gov_scheme_group_id);
                  break;
                case gov_employer_custom_field:
                  if (value.value) {
                    cj('#gov_employer_select_and_enter').val(value.value);
                  }
                  break;
                case gov_details_custom_field:
                  if (value.value) {
                    cj('.' + gov_details_custom_field).text(value.value);
                  }
                  break;
                case career_history_custom_field:
                  if (value.value) {
                    cj('.' + career_history_custom_field).text(value.value);
                  }
                  break;
                case employment_status_other_custom_field:              
                  if (value.value) {
                    cj('.' + employment_status_other_custom_field).text(value.value);
                  }
                  break;
              }                  
            });

            // Remove the loading message and show the table
            cj('#' + tabToShow).children('.loading').remove();
            cj('#employmentTable').show();
           }  
          }); 

      }
      cj(this).attr('loaded', 'true'); // unset the callback when first clicked 
      return false;
    });

    // Employer dropdown change listener
    cj('#employer_select_and_enter').change(function () {
      // api will take care of creation and setting to existing employers
      var new_employer = cj(this).val();
      if (new_employer == '') {
        new_employer = '{/literal}{$UNEMPLOYED_EMPLOYER_CODE}{literal}';
      }

      var newEmployerParams = {
        'sequential' : 1,
        'employer_name' : new_employer,
        'iContactId': {/literal}{$cid}{literal}
      };
      CRM.api('Student','Setemployer', newEmployerParams,
      { success: function(success_data) {

      }});
    });
    
    // Government programme employer dropdown change listener
    cj('#gov_employer_select_and_enter').change(function() {
      var gov_program_employer = 'custom_78';

      // api will take care of creation and setting to existing employers
      var new_employer = cj(this).val();
      if (new_employer == '') {
        new_employer = '{/literal}{$UNEMPLOYED_EMPLOYER_CODE}{literal}';
      }

      var newEmployerParams = {
        'sequential' : 1,
        'employer_name' : new_employer,
        'iContactId': {/literal}{$cid}{literal},
        'employer_id_field': gov_program_employer
      };
      CRM.api('Student','Setemployer', newEmployerParams,
      { success: function(success_data) {

      }});
    });

  });
</script>
{/literal}
