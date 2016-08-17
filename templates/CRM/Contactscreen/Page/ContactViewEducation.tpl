{assign var="UNEMPLOYED_EMPLOYER_CODE" value="-1"}

<datalist id="higher_education_institutions_list">
</datalist>
<datalist id="further_education_institutions_list">
</datalist>
{* Hidding the datalists to that they don't appear on IE as an empty select box. *}
<datalist id="apprenticeship_employer_organisations_list" style="display: none">
  <select onchange="cj('#apprenticeship_employer_select_and_enter').val(this.value)">{* Supports older browsers *}
    {* gets populated by jQuery below *}
  </select>
</datalist>

<div class="contactScreenTabContents" id="educationTabContents" style="display: none">
  <div  style="text-align: center;" class="loading"><span class="loading"><strong>Loading, please wait...</strong></span></div>
  <div style="display: none" id="educationDiv">
    <h6 class="educationTabHeader">Education summary</h6><br>
<table>
<tr>
    <td> 
      <strong>Education summary</strong>
    </td>
    <td id="custom_41">
      <select corresponding_success_icon="#education_summary_icon" contact_id ='{$cid}' id='custom_41_select' custom_id="custom_41" class="show_update_success multi_select">
        <option value="-1">- add new -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_summary_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
    <tr>
      <td>      
      </td>
      <td id="custom_41_values"></td>
      <td></td>
    </tr>
  </tr>
  <tr>
    <td> 
      <strong>Education - current</strong>
    </td>
    <td id="custom_68">
      <select contact_id ='{$cid}' id='custom_68_select' custom_field='custom_68' corresponding_success_icon="#education_current_icon" class='custom-dropdown show_update_success'><option>- select -</option>
      </select>
      <!--<input corresponding_success_icon="#education_current_icon" class="show_update_success" list="education_institutions">-->
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_current_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td> 
      <strong>Education - current (other)</strong>
    </td>
    <td id="custom_75"> 
      <span corresponding_success_icon="#education_current_other_icon" id="contact-{$cid}" class="crmf-custom_75 crm-editable custom_75 show_update_success" ></span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_current_other_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
<tr>
    <td>
      <strong>Expected finish date of education</strong>
    </td> 
    <td id="custom_57">
      {* Date select box, it is using the same data as the basic info *}
      <select corresponding_success_icon="#education_finish_date_icon" id="expectedMonth" contact_id="{$cid}">
        <option value="-1">- select -</option>
          {foreach from=$dateMonths item=month }
            <option value="{$month}">{$month}</option>
          {/foreach}
      </select>
      <select  corresponding_success_icon="#education_finish_date_icon"  id="expectedYear" contact_id="{$cid}">
        <option selected value="-1">- select -</option> 
        {foreach from=$possible_leaving_years key=PossibleLeavingYearKey item=PossibleLeavingYearValue}
                <option value="{$PossibleLeavingYearValue}">{$PossibleLeavingYearValue}</option>
        {/foreach}
      </select>      
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_finish_date_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
</table>

        <br/>
        <h6 class="educationTabHeader">Further education</h6><br>
<table>
  {* AS-Levels and A-Levels are hidden from Scottish schools *}
  {if !$schoolIsScottish}
  <tr>
    <td> 
      <strong>AS-Levels</strong>
    </td>
    <td id="custom_332">
      <select corresponding_success_icon="#education_as_levels_icon" custom_id="custom_332" class ="multi_select show_update_success" contact_id ="{$cid}" id="custom_332_select">
          <option value='-1'>- add new -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_as_levels_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
    <tr>
      <td>
      </td>
      <td id="custom_332_values"></td>
      <td></td>
    </tr>
  </tr>
  <tr>
    <td> 
      <strong>A-Levels</strong>
    </td>
    <td id="custom_45">
      <select corresponding_success_icon="#education_a_levels_icon" custom_id="custom_45" class ="multi_select show_update_success" contact_id ="{$cid}" id="custom_45_select">
          <option value='-1'>- add new -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_a_levels_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
    <tr>
      <td>      
      </td>
      <td id="custom_45_values"></td>
      <td></td>
    </tr>
  </tr>
  {else}
  <tr>
    <td> 
      <strong>Scottish Highers</strong>
    </td>
    <td id="custom_390">
      <select corresponding_success_icon="#education_scottish_highers_icon" custom_id="custom_390" class ="multi_select show_update_success" contact_id ="{$cid}" id="custom_390_select">
          <option value='-1'>- add new -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_scottish_highers_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
    <tr>
      <td>      
      </td>
      <td id="custom_390_values"></td>
      <td></td>
    </tr>
  </tr>
  {/if}

  <tr>
    <td>
      <strong>International Baccalaureate subjects</strong>
    </td>
    <td id="custom_331">
      <select corresponding_success_icon="#education_ib_subjects_icon" custom_id="custom_331" class ="multi_select show_update_success" contact_id ="{$cid}" id="custom_331_select">
          <option value='-1'>- add new -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_ib_subjects_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
    <tr>
      <td>
      </td>
      <td id="custom_331_values"></td>
      <td></td>
    </tr>
  </tr>
  <tr>
    <td>
      <strong>Current course type</strong>
    </td>
    <td id="custom_74">
      <select corresponding_success_icon="#education_non_a_levels_icon" contact_id ='{$cid}' id='custom_74_select' custom_field='custom_74' class='custom-dropdown show_update_success'>
        <option>- select -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_non_a_levels_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>    
  <tr>
    <td>
      <strong>Current course subject</strong>
    </td> 
    <td id="custom_46">
      <select corresponding_success_icon="#education_non_a_level_subject_icon" contact_id ='{$cid}' id='custom_46_select' custom_field='custom_46' class='custom-dropdown show_update_success'>
        <option>- select -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_non_a_level_subject_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td>
      <strong>Further education institution</strong>
    </td> 
    <td id="custom_76">
      <input corresponding_success_icon="#education_fe_institution_icon" list="further_education_institutions_list" style="width: 95%;" contact_id ='{$cid}' id='custom_76_select' custom_field='custom_76' class='education-searchselect show_update_success'>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_fe_institution_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td>
      <strong>Further education institution (other)</strong>
    </td> 
    <td id="custom_271">
      <span corresponding_success_icon="#education_fe_institution_other_icon" id="contact-{$cid}" class="crmf-custom_271 crm-editable custom_271 show_update_success" ></span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_fe_institution_other_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
</table>

<br/>
<h6 class="educationTabHeader">Higher education</h6><br/>
<table>
  <tr>
    <td> 
      <strong>Undergraduate institution</strong>
    </td>
    <td id="custom_49">
      <input corresponding_success_icon="#education_he_institution_icon" list="higher_education_institutions_list" style="width: 95%;" contact_id ='{$cid}' id='custom_49_select' custom_field='custom_49' class='education-searchselect show_update_success'>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_he_institution_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td> 
      <strong>Undergraduate institution (other)</strong>
    </td>
    <td id="custom_56">
      <span corresponding_success_icon="#education_he_institution_other_icon" id="contact-{$cid}" class="crmf-custom_56 crm-editable custom_56 show_update_success" ></span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_he_institution_other_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
{* TODO: Remove this at some point following switch to multi-select. Saved in case of emergency.
  <tr>
    <td>
      <strong>Undergraduate subject area</strong>
    </td> 
    <td id="custom_54">
      <select corresponding_success_icon="#education_he_subject_icon" contact_id ='{$cid}' id='custom_54_select' custom_field='custom_54' class='custom-dropdown show_update_success'>
        <option>- select -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_he_subject_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
*}
  <tr>
    <td> 
      <strong>Undergraduate subject area(s)</strong>
    </td>
    <td id="custom_388">
      <select corresponding_success_icon="#education_ug_multi_icon" custom_id="custom_388" class ="multi_select show_update_success" contact_id ="{$cid}" id="custom_388_select">
          <option value='-1'>- add new -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_ug_multi_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
    <tr>
      <td>      
      </td>
      <td id="custom_388_values"></td>
      <td></td>
    </tr>
  </tr>
  <tr>
    <td>
      <strong>Undergraduate subject (more info)</strong>
    </td> 
    <td id="custom_53">
      <span corresponding_success_icon="#education_he_subject_more_icon" id="contact-{$cid}" class="crmf-custom_53 crm-editable custom_53 show_update_success" ></span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_he_subject_more_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td>
      <strong>Postgraduate institution</strong>
    </td> 
    <td id="custom_48">
      <input corresponding_success_icon="#education_post_grad_institution_icon" list="higher_education_institutions_list" style="width: 95%;" contact_id ='{$cid}' 
             id='custom_48_select' custom_field='custom_48' class='education-searchselect show_update_success'>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_post_grad_institution_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td>
      <strong>Postgraduate institution (other)</strong>
    </td> 
    <td id="custom_55">
      <span corresponding_success_icon="#education_post_grad_institution_other_icon" id="contact-{$cid}" class="crmf-custom_55 crm-editable custom_56 show_update_success" ></span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_post_grad_institution_other_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
{* TODO: Remove this at some point following switch to multi-select. Saved in case of emergency.
  <tr>
    <td>
      <strong>Postgraduate subject area</strong>
    </td> 
    <td id="custom_50">
      <select corresponding_success_icon="#education_post_grad_area_icon" contact_id ='{$cid}' id='custom_50_select' custom_field='custom_50' class='custom-dropdown show_update_success'>
        <option>- select -</option>
    </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_post_grad_area_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
*}
  <tr>
    <td> 
      <strong>Postgraduate subject area(s)</strong>
    </td>
    <td id="custom_389">
      <select corresponding_success_icon="#education_pg_multi_icon" custom_id="custom_389" class ="multi_select show_update_success" contact_id ="{$cid}" id="custom_389_select">
          <option value='-1'>- add new -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_pg_multi_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
    <tr>
      <td>      
      </td>
      <td id="custom_389_values"></td>
      <td></td>
    </tr>
  </tr>
  <tr>
    <td>
      <strong>Postgraduate subject (more info)</strong>
    </td> 
    <td id="custom_52">
      <span corresponding_success_icon="#education_post_grad_area_more_icon" id="contact-{$cid}" class="crmf-custom_52 crm-editable custom_52 show_update_success" ></span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_post_grad_area_more_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  
</table>
        <br/>
        <h6 class="educationTabHeader">Apprenticeship</h6><br>
<table>
  <tr>
    <td>
      <strong>Apprenticeship level</strong>
    </td>
    <td id="custom_63"> 
      <select corresponding_success_icon="#education_apprenticeship_level_icon" contact_id ='{$cid}' id='custom_63_select' custom_field='custom_63' class='custom-dropdown show_update_success'>
        <option>- select -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_apprenticeship_level_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td>
      <strong>Apprenticeship sector</strong>
    </td>
    <td id="custom_64"> 
      <select corresponding_success_icon="#education_apprenticeship_sector_icon" contact_id ='{$cid}' id='custom_64_select' custom_field='custom_64' class='custom-dropdown show_update_success'>
        <option>- select -</option>
      </select>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_apprenticeship_sector_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td>
      <strong>Apprenticeship employer</strong>
    </td>
    <td id="custom_70">
      <input corresponding_success_icon="#education_apprenticeship_employer_icon" list="apprenticeship_employer_organisations_list" style="width: 95%;" contact_id ='{$cid}'
             id='apprenticeship_employer_select_and_enter' class="show_update_success" value="">
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_apprenticeship_employer_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
  <tr>
    <td>
      <strong>Apprenticeship title</strong>
    </td>
    <td id="custom_69">
      <span corresponding_success_icon="#education_apprenticeship_title_icon" id="contact-{$cid}" class="crmf-custom_69 crm-editable custom_69 show_update_success" ></span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_apprenticeship_title_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
</table>
<br/>

<h6 class="educationTabHeader">Training</h6><br/>
<table>
  <tr>
    <td>
      <strong>Training description</strong>
    </td>
    <td style="width:60%;" id="custom_59">
      <span corresponding_success_icon="#education_training_description_icon" id="contact-{$cid}" class="crmf-custom_59 crm-editable custom_59 show_update_success" ></span>
    </td>
    <td class="view_screen_icon_wrapper">
      <span id="education_training_description_icon" class="crm-status-icon success" style="display: none"> </span>
    </td>
  </tr>
</table>
</div>
</div>


{literal}
<script type="text/javascript" language="javascript">
  /**
   * createMultiSelect
   * This function creates the multi-select dropdown menus
   * @param {string} id name of the custom field
   * @param {string} value the contact's value for this custom field
   * @param {int} option_group_id the option group id of the custom field
   */
  function createMultiSelect(id, value, option_group_id) {
    // For custom_41 (option_group_id = 91) and custom_45 (option_group_id = 94)
    // Fetch all the possible values
    CRM.api('OptionValue', 'get', {
      'sequential': 1,
      'option_group_id': option_group_id,
      'is_active': 1,
      'rowCount' : 0
    },
    { success: function(option_data) {
      var OPTION_NOT_SELECTED = -1;
      var choice = OPTION_NOT_SELECTED;
      var valuesSelected    = '';
      var valuesNotSelected = '';

      cj.each(option_data['values'], function(option_key, option_value) {
        choice = cj.inArray(option_value.value, value);
        if (choice !== OPTION_NOT_SELECTED) {
          // If the current option is in the array of selected options
          // don't add it to the array and create new 'span'.
          valuesSelected += "<span custom_id=\"" + id + "\" class =\"" + id + "_select_chosen\" id=\"multi_select_option_" + escapeHtml(option_value.value) + "\" value=\"" + escapeHtml(option_value.value) + "\" label=\"" + escapeHtml(option_value.label) + "\"  >" + escapeHtml(option_value.label) + "  <strong>(<a href=# custom_id =\"" + id + "\" title=\"Delete\" span_id=\"multi_select_option_" + escapeHtml(option_value.value) + "\" class=\"multi_select_option_delete\">x</a>)</strong><br></span>";
        }
        else {
          valuesNotSelected += "<option custom_id=\"" + id + "\" id=\"" + escapeHtml(option_value.value) + "\" value=\"" + escapeHtml(option_value.value) + "\">" + escapeHtml(option_value.label) + "</option>";
        }
      });

      // Add the multi-select to the correct place on the form
      cj('#' + id + "_values").append(valuesSelected);
      cj('#' + id + "_select").append(valuesNotSelected);
    }});
    return true;
  }

  /**
   * Returns the options that are set/enabled for a multi-select field
   */
  function getSelectedMultipleChoices(multi_select_id){
    var selected_options = cj('.' + multi_select_id + '_chosen');
    var selected_values = [];
    cj.each(selected_options, function(key, data) {
      selected_values.push(cj(data).attr('value'));
    });
    return selected_values.join();
  }
  
  /**
   * Given a date update the contact's expected education finish date. 
   */
  function updateExpectedFinishDateApi(dateToUpdate){    
    
    CRM.api('Contact','create',{
                      'sequential' : 1,
                      'id' : {/literal}{$cid}{literal}, 
                      'custom_57' : dateToUpdate,
                      'contact_type' : 'Individual', 
                      'contact_sub_type' : 'student'
                    },
      { success:function (success_data){          
        showSuccessIcon('#education_finish_date_icon');
      }
    });    
    
    return;
  }
  
  /**
   * Call API call to update date if there is a relevant change to the field.
   * 
   * It will only call the API call if both fields (month and year) have a value 
   * or both of then are unset. 
   */
  function updateExpectedFinishDate(){
    
    var expectedMonth = cj('#expectedMonth').attr("value");
    var expectedYear = cj('#expectedYear').attr("value");
    var dateToUpdate;
    // If both are not selected save the empty string.
    if ( expectedYear  == -1 && expectedMonth == -1) {
      dateToUpdate = "";
      updateExpectedFinishDateApi(dateToUpdate);
    }
    // If both are not the default save the date.
    if ( expectedYear  != -1 && expectedMonth != -1) {
      dateToUpdate = expectedYear + "-" + expectedMonth +"-01";
      updateExpectedFinishDateApi(dateToUpdate);
    }
    
    // If it's not one of these don't do 
    // anything because one of them is not selected.
    return;
  }

  cj(document).ready(function() { 

    cj('.education-searchselect').change(function() {
        var selected_name = cj(this).val();
        var custom_field = cj(this).attr("custom_field");
       
        // if it's empty, delete the entry
        if (selected_name == "") {
            var params = {
                'sequential' : 1,
                'id' : {/literal}{$cid}{literal},
                'contact_type' : 'Individual',
                'contact_sub_type' : 'student'
            };

            var new_value = cj(this).attr("id");
            params[custom_field] = '';
            CRM.api('Contact','create', params,
            { success:function (success_data){    
            }
            });
                    
        }
        
        // for each child option, see if it matches what's in here, if so save
        cj('#' + cj(this).attr('list')).children().each(function ( index ){
                
            if (cj(this).attr('value') == selected_name){
                var params = {
                    'sequential' : 1,
                    'id' : {/literal}{$cid}{literal},
                    'contact_type' : 'Individual',
                    'contact_sub_type' : 'student'
                };
                
                var new_value = cj(this).attr("id");
                params[custom_field] = new_value;
                CRM.api('Contact','create', params,
                { success:function (success_data){                 
                }
                });
           }
        });
         
         
    });
    
  /**
   * Listener for the multi-select dropdowns
   */
  cj('.multi_select').change( function() {
    var UNSELECTED_VALUE = -1;
  
    // Get the selected value.
    var new_option = cj(this).val();
    // Failsafe for the empty option.
    if (new_option == UNSELECTED_VALUE){
      return false;
    }
    // Disable the dropdown temporarily to prevent an issue where we can (if quick enough) select an option,
    // select a second option, then select the first option again before it has been removed from the list
    cj(this).attr('disabled', true);
    // Get the Id of the select and custom data.
    var select_id = cj(this).attr('id'); 
    var custom_id = cj(this).attr('custom_id');
    
    // Build string that will be used on the api
    // Get all the selected options
    var selected_options_string = getSelectedMultipleChoices(select_id);
    if (!selected_options_string){      
      selected_options_string = new_option      
    }
    else{
       selected_options_string =  selected_options_string + ',' + new_option;      
    }
    
    var updateApiParams = {
      'sequential': 1,
      'id': {/literal}{$cid}{literal}
    };
    
    updateApiParams[custom_id] = selected_options_string;
    CRM.api('Contact', 'create', updateApiParams,
       {success: function(data) {
        // Create the new option on the form
        var newOptionLabel =  cj('#' + select_id).find("option[id='" + new_option + "']").text();
        var newOptionLink = "<a href=# custom_id =\"" + custom_id + "\"  title=\"Delete\" span_id=\"multi_select_option_" + new_option + "\" class=\"multi_select_option_delete\">x</a>";
        var newOption = "<span custom_id=\"" + custom_id + "\" class =\"" + custom_id + "_select_chosen\" id=\"multi_select_option_" + new_option + "\" value=\"" + new_option + "\" label=\"" + newOptionLabel + "\"   >" + newOptionLabel + "   <strong>(" + newOptionLink + ")</strong><br></span>";
        cj('#' + custom_id + "_values").append(newOption);
        
        // this removes the option from the select      
        cj('#' + select_id).find("option[id='" + new_option + "']").remove();   
        // Ready for user to select more options
        cj('#' + select_id).attr('disabled', false);

       }
     });
  
  });
      

  /**
   * Listener for the multi-select set/enabled option delete
   */
  cj('#educationDiv').delegate('.multi_select_option_delete', 'click', function() {
  
    // Get the custom field id
    var custom_id = cj(this).attr('custom_id');
    
    // Get the ID of the option that is going to be removed
    var span_id = cj(this).attr('span_id');
    
    // This line is needed because some fields have special characters in their names/values/labels
    span_id = span_id.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, "\\$1");
    
    var current_value = cj('#' + span_id).attr('value');
    // Get the clean text (without the - X)
    var option_label =  cj('#' + span_id).attr('label');
    
    cj('#' + span_id + '.' + custom_id + '_select_chosen').remove();    
    
    // Get the selected options
    var multi_select_id =  custom_id + '_select';
    var update_options = getSelectedMultipleChoices(multi_select_id);
    
    var params = {
            'sequential' : 1,
            'id' : {/literal}{$cid}{literal},
            'contact_type' : 'Individual',
            'contact_sub_type' : 'student'
          };
          params[custom_id] = update_options;
    CRM.api('Contact', 'create', params,
       {success: function(data) {
           // Re-add the deleted option to the start of the dropdown (but after the default value)
           cj('#' + multi_select_id + ' option:first').after("<option custom_id=\"" + custom_id + "\" id=\"" + current_value + "\" value=\"" + current_value + "\">" + option_label + "</option>");    
           // Removes the span from the form
           // Show the success icon
           var success_icon_id = cj('#'+ multi_select_id).attr("corresponding_success_icon");
           showSuccessIcon(success_icon_id);
       }
     });
     
     return false;
  });
  
  /**
   * Populate the Education Details Form
   * Retrieves the contact's data and then 
   * populates the rest of the form
   */
  cj('#educationButton').click(function() {          
    if (cj(this).attr('loaded') == "false") {
      var tabToShow = cj(this).attr('tabToShow');
      // Id's of the custom fields 
      var education_summary = 'custom_41';
      var education_current = 'custom_68';
      var education_current_other = 'custom_75';
      var a_levels = 'custom_45';
      var ib_subjects = 'custom_331';
      var as_levels = 'custom_332';
      var scottish_highers = 'custom_390';
      var non_a_level_course = 'custom_74';
      var further_education = 'custom_46';
      var further_education_institution = 'custom_76';
      var further_education_other = 'custom_271'; // this is the live ID,  local 274
      var undergrad_institution = 'custom_49';
      var undergrad_intitution_other = 'custom_56';
      //var undergrad_subject = 'custom_54';
      var undergrad_subject_info = 'custom_53';
      var undergrad_subject_multi = 'custom_388';
      var postgrad_institution = 'custom_48';
      var postgrad_institution_other = 'custom_55';
      //var postgrad_subject = 'custom_50';
      var postgrad_subject_info = 'custom_52';
      var postgrad_subject_multi = 'custom_389';
      var education_expected_finish_date = 'custom_57';
      var apprenticeship_level = 'custom_63';
      var apprenticeship_sector = 'custom_64';
      var apprenticeship_employer = 'custom_70';
      var apprenticeship_title = 'custom_69';
      var training_description = 'custom_59';
      
      // Id's of the option_groups
      var education_current_option_group = 103;
      var further_edu_subject_option_group = 95;
      var undergrad_subject_option_group = 97;
      var apprenticeship_level_option_group = 99;
      var apprenticeship_sector_option_group = 100;
      var education_summary_option_group = 91;
      // These share an option group
      var a_levels_option_group    = 94;
      var as_levels_option_group   = 94;
      var ib_subjects_option_group = 94;
      var scottish_highers_option_group = 94;

      var EDUCATION_CUSTOM_FIELD_DATA_INDEX = 0;

      CRM.api('Student', 'retrieveeducation', {
        'version': 3,
        'sequential': 1,
        'iContactId' :{/literal}{$cid}{literal}
        },
        {success: function(data) {

            cj.each(data['values'][EDUCATION_CUSTOM_FIELD_DATA_INDEX], function(key, value) {
            // Populate all the custom fields for this contact
            switch(key){
              // Expected Leaving Year Dropdown
              case education_expected_finish_date:
                if (value){
                  // The expected format is "Y-m";
                  // Separate the year from the month.
                  var date = value.split("-");
                  
                  cj('#expectedYear').val(date[0]);
                  cj('#expectedMonth').val(date[1]);
                }
                
                // Expected education finish date listener.
                cj('#' + education_expected_finish_date).change(updateExpectedFinishDate);                
                break;
              // Dropdown Selects           
              case further_education:
                populateCustomDropdown(key, value, further_edu_subject_option_group);
                break;
// TODO: Remove this at some point following switch to multi-select. Saved in case of emergency.
//              case postgrad_subject:
//                populateCustomDropdown(key, value, undergrad_subject_option_group);
//                break;
//              case undergrad_subject:
//                populateCustomDropdown(key, value, undergrad_subject_option_group);
//                break;
              case apprenticeship_level:
                populateCustomDropdown(key, value, apprenticeship_level_option_group);
                break;
              case apprenticeship_sector:                
                populateCustomDropdown(key, value, apprenticeship_sector_option_group);
                break;              
              case education_current:                
                populateCustomDropdown(key, value, education_current_option_group);
                break;
              case non_a_level_course:                
                populateCustomDropdown(key, value, education_summary_option_group);
                break;
              // Multiple choice (education Level and A-levels)
              case education_summary:
                createMultiSelect(key, value, education_summary_option_group); // id = 91
                break;
              case a_levels:
                createMultiSelect(key, value, a_levels_option_group); // id = 94
                break;
              case as_levels:
                createMultiSelect(key, value, as_levels_option_group); // id = 94
                break;
              case ib_subjects:
                createMultiSelect(key, value, ib_subjects_option_group); // id = 94
                break;
              case scottish_highers:
                createMultiSelect(key, value, scottish_highers_option_group); // id = 94
                break;
              case postgrad_subject_multi:
                createMultiSelect(key, value, undergrad_subject_option_group);
                break;
              case undergrad_subject_multi:
                createMultiSelect(key, value, undergrad_subject_option_group);
                break;

              // Select-Autocompletes
              // TODO - Autocomplete fields
              case undergrad_institution: 
              case postgrad_institution: //  contact_sub_type = Higher_Education_Institution
              case further_education_institution: // contact_sub_type = Further_Education_Institution
                if (value != null){
                    var listName = cj("#"+key+"_select").attr('list');
                    cj("#" + listName).children().each(function ( index ) {
                        if (cj(this).attr('id') == value) {
                            cj("#"+key+"_select").val(cj(this).attr('value'));
                        }
                    });
                }
                break;
              // autocompletes that are not education institutions
              case apprenticeship_employer:
                if (value) {
                  cj('#apprenticeship_employer_select_and_enter').val(value);
                }
                break;
              // normal text fields
              case postgrad_subject_info:
              case undergrad_subject_info:
              case postgrad_institution_other:
              case undergrad_intitution_other:
              case training_description:
              case apprenticeship_title:
              case education_current_other:
              case further_education_other:
                if(value != ''){
                  cj('.' + key).text(value);
                }
                break;
            }
          });

          // Remove the loading message
          cj('#' + tabToShow).children('.loading').remove();
          cj('#educationDiv').show();
         }
        }); // end retrieve data
    }
    cj(this).attr('loaded', 'true'); // unset the callback when first clicked 
    return false;
  });

  // Apprenticeship employer dropdown change listener
  cj('#apprenticeship_employer_select_and_enter').change(function() {
    var apprenticeship_employer = 'custom_70';

    // api will take care of creation and setting to existing employers
    var new_employer = cj(this).val();
    if (new_employer == '') {
      new_employer = '{/literal}{$UNEMPLOYED_EMPLOYER_CODE}{literal}';
    }

    var newEmployerParams = {
      'sequential' : 1,
      'employer_name' : new_employer,
      'iContactId': {/literal}{$cid}{literal},
      'employer_id_field': apprenticeship_employer
    };
    CRM.api('Student','Setemployer', newEmployerParams,
    { success: function(success_data) {

    }});
  });

 });
</script>
{/literal}
