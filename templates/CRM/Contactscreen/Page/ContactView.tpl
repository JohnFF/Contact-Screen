{include file="CRM/common/crmeditable.tpl"}
{literal}
<style type="text/css">
  thead *, th *, th{
    color: #4C4C4C !important;
  }
</style>
{/literal}
<br/>
<h1>{$summary.full_name}</h1>
<br/>

<a href="#" class="tabButton" title="The contact's name, date of birth, leaving year, and how they've offered to help." tabToShow="basicTabContents" style="font-weight: bold">Basic Info</a> | 
<a href="#" class="tabButton" title="The contact's email address, phone number, and post address." tabToShow="contactDetailsTabContents" id="contactDetailsButton" loaded="false" onClickApiCall="retrievecontactdetails">Contact Details</a> | 
<a href="#" class="tabButton" title="Details of the contact's current employment." tabToShow="employmentTabContents" id="employmentButton" loaded="false" onClickApiCall="retrieveemployment">Employment</a> | 
<a href="#" class="tabButton" title="Details of the contact's education, including further education, higher education, and apprenticeships." tabToShow="educationTabContents" id="educationButton" loaded="false" onClickApiCall="retrieveeducation">Education</a> | 
<a href="#" class="tabButton" title="Email messages, SMS messages, and phone calls that have been sent to and from the contact." tabToShow="communicationsTabContents" id="communicationsButton" loaded="false" onClickApiCall="retrievecommunications">Communications</a> | 
<a href="#" class="tabButton" title="How the contact has been engaged so far." tabToShow="mobilisationsTabContents" id="mobilisationsButton" loaded="false" onClickApiCall="retrievemobilisations">Mobilisations</a> | 
<a href="#" class="tabButton" title="Notes about the contact." tabToShow="notesTabContents" id="notesButton" loaded="false" onClickApiCall="retrievenotes">Notes</a> <br/>
<div id="mainViewAndEditDiv">
{* If the school doesn't have any active custom questions the custom question tab will not be shown*}
{if $hasCustomQuestions}
  | <a href="#" class="tabButton" title="This contact's answers to your custom sign up form questions." tabToShow="customQuestionsAnswersTabContent" id="customQuestionsButton" loaded="false" onClickApiCall="retrievecustomquestionanswers">Custom Question Answers</a>
  {include file="CRM/Contactscreen/Page/ContactViewQuestionAnswers.tpl"}
{/if}

<span id="contact-{$cid}" class="crm-entity {$cid}">

<br/><br/>
{include file="CRM/Contactscreen/Page/ContactViewBasicInfo.tpl"}

{include file="CRM/Contactscreen/Page/ContactViewContactDetails.tpl"}

{include file="CRM/Contactscreen/Page/ContactViewEmployment.tpl"}

{include file="CRM/Contactscreen/Page/ContactViewEducation.tpl"}

{include file="CRM/Contactscreen/Page/ContactViewCommunications.tpl"}

{include file="CRM/Contactscreen/Page/ContactViewMobilisations.tpl"}

{include file="CRM/Contactscreen/Page/ContactViewNotes.tpl"}

</span>
</div>
{literal}
<script type="text/javascript" language="javascript">
  /**
   * Escapes HTML entities in a string.
   * @see {@link http://shebang.brandonmintern.com/foolproof-html-escaping-in-javascript/}
   * @param {string} str
   * @returns {string}
   */
  function escapeHtml(str) {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  }

  /**
   * populateCustomDropdown
   * Creates the dropdown select for a custom field and sets it's value 
   * accordingly to the contact's data
   * @param {string} custom_field_id name of the custom field
   * @param {string} current_value the contact's value for this custom field
   * @param {int} option_group_id the option group id of the custom field
   * @returns If the function is successful creates a new dropdown select
   */
  function populateCustomDropdown(custom_field_id, current_value, option_group_id) {
    CRM.api('OptionValue', 'get', {
      'sequential': 1,
      'option_group_id': option_group_id,
      'is_active': 1,
      'rowCount': 0 // override the default API limit of 25
    },
    { success: function(option_data) {
      var selected;
      var currentOptions = "";
      cj.each(option_data['values'], function(option_key, option_value) {
        selected = '';
        if (option_value.value === current_value) {
          selected = 'selected';
        }
        currentOptions += "<option id=\"" + escapeHtml(option_value.value) + "\" value=\"" + escapeHtml(option_value.value) + "\"" + selected + ">" + escapeHtml(option_value.label) + "</option>";
      });
      cj('#' + custom_field_id + "_select").append(currentOptions); 
    }});
  }
  
  // Overide to the default CRM.alert function so that no
  // "Saved" messages are displayed
  CRM.alert = function (text, title, type, options) {
    return null;
  };
  
  // This functions is here so it can be used in elements that are
  // not being caught in the change listener 
  // cj('#mainViewAndEditDiv').on("change",'.show_update_success', function()
  function showSuccessIcon(iconId) {
    cj(iconId).fadeIn(500).delay(250).fadeOut(1000);
  }

  /**
   * Populate all the organisations lists with one API call.
   *
   * @returns {void}
   */
  function loadOrgList() {
    CRM.api3('Student', 'getorganisations', {
      'version':    3,
      'sequential': 1
    }).done(function(data) {
      var empList = '';
      var feiList = '';
      var heiList = '';

      // Note: Using string concatenation inside the loop then a big append()
      // afterwards is less CPU-intensive (less noticeable delay in browser)
      // than append() inside the loop
      cj.each(data['values'], function(key, orgDetails) {
        var newOrgOption = '<option id="' + orgDetails['id'] + '" value="' + orgDetails['display_name'] + '">';
        empList += newOrgOption;

        if (orgDetails['contact_sub_type'] instanceof Array) {
          if (orgDetails['contact_sub_type'].indexOf('Further_Education_Institution') != -1) {
            feiList += newOrgOption;
          }
          if (orgDetails['contact_sub_type'].indexOf('Higher_Education_Institution') != -1) {
            heiList += newOrgOption;
          }
        }
      });

      // From the Employment tab: these fields can choose from all organisations
      cj('#employer_organisations_list').append(empList);
      cj('#gov_employer_organisations_list').append(empList);

      // From the Education tab: this field can choose from all organisations
      cj('#apprenticeship_employer_organisations_list').append(empList);

      // But restrict FEI/HEI fields to only show that subtype
      cj('#further_education_institutions_list').append(feiList);
      cj('#higher_education_institutions_list').append(heiList);
    });
  }

  // handle functionality to switch to a new tab 
  cj(document).ready(function() {

    // TODO find out why it is not working on the multi-selects
    cj('#mainViewAndEditDiv').on("change",'.show_update_success', function() {
      var success_icon_id = cj(this).attr("corresponding_success_icon");
      showSuccessIcon(success_icon_id);
    });

    // handle functionality to switch to a new tab 
    cj('.tabButton').click(function() {
      var tabToShow = cj(this).attr('tabToShow');
      var apiCallback = cj(this).attr('onClickApiCall');
      cj('.contactScreenTabContents').hide();
      cj('#' + tabToShow).show();
      cj('.tabButton').css('font-weight', 'normal');
      cj(this).css('font-weight', 'bold');
      return false;
    });

    // Listener for the dropdowns
    cj('.custom-dropdown').change(function() {
      var contact_id = cj(this).attr("contact_id");
      var new_value = cj(this).attr("value");
      var custom_field = cj(this).attr("custom_field");
      var params = {
        'sequential' : 1,
        'id' : contact_id,
        'contact_type' : 'Individual',
        'contact_sub_type' : 'student'
      };
      params[custom_field] = new_value;
      CRM.api('Contact','create', params,
      { success: function(success_data) {
        //
      }});
      
    });

    loadOrgList();
  });
</script>
{/literal}
