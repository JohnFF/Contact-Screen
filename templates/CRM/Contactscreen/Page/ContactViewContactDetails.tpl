<div class="contactScreenTabContents" id="contactDetailsTabContents" style="display: none">
<div style="text-align: center;" class="loading"><span class="loading"><strong>Loading, please wait...</strong></span></div>  
  <table id="email_table" class="contact_details_table view-and-edit-table" style="display: none">
    <tr>
      <th width="60%">
        <strong>Email address</strong>
      </th>
      <th class="is_primary_radio">
        <strong>Primary</strong>
      </th>
      <th>
        <strong>Actions</strong>
      </th>
      <th></th>     
    </tr>
    <tr id="new_email_row">
      <td>
          <input correspondingEnabledButton="#add_new_email" correspondingDisabledButton="#add_new_email_placeholder" class="newEmailInput" size="40" type="email" id="new_email_address" placeholder="Email address here">
      </td>
      <td></td>
      <td style="text-align:right;">
        <a href='#' style="background-color: #EFEFEF ;" class="button placeholder_button" id="add_new_email_placeholder">  Add new </a>
        <a style="display: none" class="button" href="#" id="add_new_email" title="Click here to add a new email address to this contact.">Add new</a> 
      </td>
      <td></td>      
    </tr>
  </table>
    
  <table id="phone_table" class="contact_details_table view-and-edit-table" style="display: none">
    <tr>
      <th width="55%">
        <strong>Phone number</strong>
      </th>
      <th class="is_primary_radio">
        <strong>Primary</strong>
      </th>
      <th>
        <strong>Actions</strong>
      </th>
      <th></th>
    </tr>
    <tr id="new_phone_row">
      <td>
        <input correspondingEnabledButton="#add_new_phone" correspondingDisabledButton="#add_new_phone_placeholder" class="newPhoneInput" type="tel" id="new_phone_number" placeholder="Phone number here">
      </td>
      <td></td>
      <td style="text-align:right;">
        <a href='#' style="background-color: #EFEFEF ;" class="button  placeholder_button" id="add_new_phone_placeholder">  Add new </a>
        <a style="display: none" class="button" href="#" id="add_new_phone" title="Click here to add a phone number to this contact.">Add new</a> 
      </td>
      <td></td>
    </tr>
  </table> 
  
  <table id="social-media-table" class="contact_details_table" style="display: none">
    <tr>
      <th>Type</th>
      <th width="70%">Value</th>
      <th></th>      
    </tr>
    <tr>
      <td>
        <strong>Twitter handle</strong>
      </td>
      <td id="custom_136">
        <span corresponding_success_icon="#contact_details_twitter_icon" id="contact-{$cid}" class="crmf-custom_136 crm-editable custom_136 show_update_success" ></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="contact_details_twitter_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>LinkedIn URL</strong>
      </td>
      <td id="custom_147">
        <span corresponding_success_icon="#contact_details_linkedin_icon" id="contact-{$cid}" class="crmf-custom_147 crm-editable custom_147 show_update_success" ></span> 
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="contact_details_linkedin_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
  </table>

  <table id="address-{$summary.address.id}" class="crm-entity {$summary.address.id} contact_details_table" style="display: none">
    <tr>
      <td>
        <strong>Street address</strong>
      </td>
      <td id="street_address">
        <span corresponding_success_icon="#contact_details_street_address_icon" id="contact-{$summary.address.id}" class="crmf-street_address crm-editable show_update_success"></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="contact_details_street_address_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Address line 1</strong>
      </td>
      <td id="supplemental_address_1">
        <span corresponding_success_icon="#contact_details_address_1_icon" id="address-{$summary.address.id}" class="crmf-supplemental_address_1 crm-editable show_update_success"></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="contact_details_address_1_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Address line 2</strong>
      </td>
      <td  id="supplemental_address_2">
        <span corresponding_success_icon="#contact_details_address_2_icon" id="address-{$summary.address.id}" class="crmf-supplemental_address_2 crm-editable show_update_success"></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="contact_details_address_2_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>City</strong>
      </td>
      <td id="city">
        <span corresponding_success_icon="#contact_details_city_icon" id="address-{$summary.address.id}" class="crmf-city crm-editable show_update_success"></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="contact_details_city_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>
      <td>
        <strong>Postcode</strong>
      </td>
      <td id="postal_code">
        <span corresponding_success_icon="#contact_details_post_code_icon" id="address-{$summary.address.id}" class="crmf-postal_code crm-editable show_update_success"></span>
      </td>
      <td class="view_screen_icon_wrapper">
        <span id="contact_details_post_code_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
    </tr>
    <tr>      
      <td>
        <strong>Country</strong>
      </td>      
      <td>
        <select corresponding_success_icon="#contact_details_country_icon" id="address_country_list" address_id="{$summary.address.id}" class="country_select show_update_success" contact_id="{$cid}">
          <option value="-1"> - select - </option>
        </select>
      <td class="view_screen_icon_wrapper">
        <span id="contact_details_country_icon" class="crm-status-icon success" style="display: none"> </span>
      </td>
      </td>
    </tr>
  </table>
</div>

{literal}
<script type="text/javascript" language="javascript">
  var SEND_SMS_LINK   = "<span><a id=\"send_sms_link\"   href=\"{/literal}{crmURL p='civicrm/activity/sms/add'   q='selectedChild=activity&atype=4'}&cid={$cid}{literal}\" title=\"Send an SMS through the Dashboard mailer.\">Send SMS</a> |</span>";
  var SEND_EMAIL_LINK = "<span><a id=\"send_email_link\" href=\"{/literal}{crmURL p='civicrm/sendemail' q='cid='}{$cid}{literal}\" title=\"Send an email through the Dashboard mailer.\">Send email</a> |</span>";

  /**
   * buildNewEmailRow
   * Construct a new email row for the email table
   * @param emailData - Data of the email to be added.
   */
  function buildNewEmailRow(emailData) {
    // See if it is the primary email.
    var is_checked = '';
    var email_link = '';
    if (emailData.is_primary == 1){
      is_checked = "checked";
      email_link = SEND_EMAIL_LINK;
    }
    // Construct the string for the new table row.
    return {/literal}"\
      <tr id=\"email_row_" + emailData.id + "\">\n\
          <td id=\"email-" + emailData.id + "\" class=\"crm-entity " + emailData.id + "\">\n\
              <span corresponding_success_icon=\"#email_" + emailData.id + "_row_icon\" id=\"email-" + emailData.id + "\" class=\"crmf-email crm-editable show_update_success\">" + escapeHtml(emailData.email) + "</span>\n\
          </td>\n\
            <td class=\"is_primary_radio\">\n\
                 <input " + is_checked + " corresponding_success_icon=\"#email_" + emailData.id + "_row_icon\" class=\"show_update_success email_primary_check\" id=\"is_primary_email_" + emailData.id + "\" email_id=\"" + emailData.id + "\" type=\"radio\">\n\
            </td>\n\
          <td id=\"email-" + emailData.id + "-actions-row\">\n\
              " + email_link + "\n\
              <span><a href=\"#\" class=\"delete_email delete-button\" email_id=\"" + emailData.id + "\" title=\"Permanently delete this email address for this contact.\">Delete</a></span>\n\
          </td>\n\
          <td class=\"view_screen_icon_wrapper\">\n\
            <span id=\"email_" + emailData.id + "_row_icon\" class=\"crm-status-icon success\" style=\"display: none\"></span>\n\
          </td>\n\
      </tr>\n\
    "{literal};
  }

  /**
   * buildNewPhoneRow
   * Construct a new phone row for the phone table
   * @param phoneData - Data of the phone to be added.
   */
  function buildNewPhoneRow(phoneData) {
    // See if this is the primary phone.
    var is_checked = '';
    var sms_link = '';
    if (phoneData.is_primary == 1){
      is_checked = "checked";
      sms_link = SEND_SMS_LINK;
    }
    // Construct the string for the new table row.
    return {/literal}"\
      <tr id=\"phone_row_" + phoneData.id + "\">\n\
          <td id=\"phone-" + phoneData.id + "\" class=\"crm-entity " + phoneData.id + "\">\n\
              <span corresponding_success_icon=\"#phone_" + phoneData.id + "_row_icon\" id=\"phone-" + phoneData.id + "\" class=\"crmf-phone crm-editable show_update_success\">" + escapeHtml(phoneData.phone) + "</span>\n\
          </td>\n\
          <td class=\"is_primary_radio\">\n\
             <input " + is_checked + " corresponding_success_icon=\"#phone_" + phoneData.id + "_row_icon\" class=\"phone_primary_check show_update_success\" id=\"is_primary_phone_" + phoneData.id + "\" phone_id=\"" + phoneData.id + "\" type=\"radio\">\n\
          </td>\n\
          <td id=\"phone-" + phoneData.id + "-actions-row\">\n\
              " + sms_link + "\n\
              <span><a href=\"#\" class=\"delete_phone delete-button\" phone_id=\"" + phoneData.id + "\" title=\"Permanently delete this phone number for this contact.\">Delete</a></span>\n\
          </td>\n\
          <td class=\"view_screen_icon_wrapper\">\n\
            <span id=\"phone_" + phoneData.id + "_row_icon\" class=\"crm-status-icon success\" style=\"display: none\"></span>\n\
          </td>\n\
      </tr>\n\
    "{literal};
  }

  cj(document).ready(function() {
    var LARGER_THAN_ZERO_VALIDATOR = 1;
    // Indexes of the RetrieveContactDetails API call.
    var CONTACT_DETAILS_COUNTRY_LIST_INDEX = 0;
    var CONTACT_DETAILS_ADDRESS_DATA_INDEX = 1;
    var CONTACT_DETAILS_PHONES_INDEX = 2;
    var CONTACT_DETAILS_EMAILS_INDEX = 3;
    var CONTACT_DETAILS_SOCIAL_INDEX = 4;
    var ADDRESS_DATA_COUNTRY_ID = 'country_id';

    cj('#contactDetailsButton').click(function(){
      if(cj(this).attr('loaded') == "false"){
        var tabToShow = cj(this).attr('tabToShow');
        
        // Retrieve the contact's contact details
        CRM.api('Student', 'retrievecontactdetails', {
          'version': 3,
          'iContactId' : {/literal}{$cid}{literal}
          },
          { success: function(data) {
            // Populate the country dropdown list
            var countryOptions = '';
            cj.each(data['values'][CONTACT_DETAILS_COUNTRY_LIST_INDEX], function(countryDataKey, countryDataValue) {
              // Create a new option and attach it to the dropdown list.
              countryOptions += "<option value=\"" + countryDataValue.id + "\">" + countryDataValue.name + "</option>";
            });
            cj('#address_country_list').append(countryOptions);

            // Set all the address fields data
            cj.each(data['values'][CONTACT_DETAILS_ADDRESS_DATA_INDEX], function(addressDataKey, addressDataValue) {
              if (addressDataKey === ADDRESS_DATA_COUNTRY_ID) {
                // Set the value of the select box
                cj('#address_country_list').val(addressDataValue);
              }
              else if (addressDataValue) {
                // Set the value of all the other address fields (plain text).
                cj('#' + addressDataKey + ' span').text(addressDataValue);
              }
            });

            // Set all the phone numbers.
            var is_checked = '';
            cj.each(data['values'][CONTACT_DETAILS_PHONES_INDEX], function(phoneDataKey, phoneDataValue) {
              // Add a new phone row.
              cj(buildNewPhoneRow(phoneDataValue)).insertBefore('#new_phone_row');
            });
            // Enable their edit boxes
            cj('span.crmf-phone.crm-editable').crmEditable();

            cj.each(data['values'][CONTACT_DETAILS_EMAILS_INDEX], function(emailDataKey, emailDataValue) {
              // Add a new email row.
              cj(buildNewEmailRow(emailDataValue)).insertBefore('#new_email_row');
            });
            // Enable their edit boxes
            cj('span.crmf-email.crm-editable').crmEditable();

            // Get all the social media details.            
            cj.each(data['values'][CONTACT_DETAILS_SOCIAL_INDEX], function(socialDataKey, socialDataValue) {
              // If data exists populate the field.
              if (socialDataValue) {
                cj('#' + socialDataKey + ' span').text(socialDataValue);
              }
            });

            // Show all the basic details tables.
            cj('.contact_details_table').show();
            // remove the loading elements
            cj('#' + tabToShow).children('.loading').remove();            
          }}
        );

        cj(this).attr('loaded', 'true'); 
        return false;
      }
    });
    
    // Phone Primary check button
    // The delegate is used so that elements added after the render can also be manipulated
    cj('#phone_table').delegate('.phone_primary_check', 'change', function() {

      cj('.phone_primary_check').attr("checked", false);
      cj(this).attr("checked", true);
      var phone_id = cj(this).attr("phone_id");
      
      // Remove the 'Send SMS' link.
      cj('#send_sms_link').parent().remove();
      // Attach send SMS link to the new row.
      cj('#phone-' + phone_id +'-actions-row').prepend(SEND_SMS_LINK);
      
      CRM.api('Phone', 'create', {
        'id':         phone_id,
        'contact_id': {/literal}{$cid}{literal},
        'is_primary': 1,
      },
      { success: function(data) {
        //
      }});
    });

    // Email Primary check button
    // The delegate is used so that elements added after the render can also be manipulated
    cj('#email_table').delegate('.email_primary_check', 'change', function() {

      cj('.email_primary_check').attr("checked", false);
      cj(this).attr("checked", true);
      var email_id = cj(this).attr("email_id");
      var email_text = cj('span#email-' + email_id).text();

      // Remove the 'Send email' link.
      cj('#send_email_link').parent().remove();
      // Attach send email link to the new row.
      cj('#email-' + email_id +'-actions-row').prepend(SEND_EMAIL_LINK);
      
      CRM.api('Email', 'create', {
        'id':         email_id,
        'contact_id': {/literal}{$cid}{literal},
        'is_primary': 1,            
        'email':      email_text,
      },
      { success: function(data) {
        //
      }});
    });

    // Handler for the change on the country dropdown list
    cj('#address_country_list').change(function() {        
      var country_id = cj(this).attr("value");
      // Failsafe for the default option
      if (country_id < LARGER_THAN_ZERO_VALIDATOR) {
        country_id = '';
      }
      CRM.api('Address', 'create', {
        'id':         cj(this).attr("address_id"),
        'country_id': country_id,
      },
      { success: function(data) {
        //
      }});
    });

    // Enable the delete email links- even ones added dynamically
    cj('#email_table').delegate('.delete_email', 'click', function() {
      if (!confirm("Do you want to permanently delete this email address?")){
        return false;
      }
      var email_id = cj(this).attr('email_id');
      // Call the API to remove it from the database
      CRM.api('Email', 'delete', {
        'id': email_id
      }, { success: function(data) {
        // If successful, remove it from the form
        cj('#email_row_' + email_id).remove();
        
      }});
      // Prevent jumping to top of page
      return false;
    });

    // Enable the delete phone links- even ones added dynamically
    cj('#phone_table').delegate('.delete_phone', 'click', function() {
      if (!confirm("Do you want to permanently delete this phone number?")){
        return false;
      }
      var phone_id = cj(this).attr('phone_id');
      // Call the API to remove it from the database
      CRM.api('Phone', 'delete', {
        'id': phone_id
      }, { success: function(data) {
        // If successful, remove it from the form
        cj('#phone_row_' + phone_id).remove();
        
      }});
      // Prevent jumping to top of page
      return false;
    });

    // Enable the add new email link
    cj('#add_new_email').click(function() {
      // Call the API to add the email in the 'new' box to the database
      CRM.api('Email', 'create', {
        'contact_id': {/literal}{$cid}{literal},
        'email':      cj('#new_email_address').val()

      }, { success: function(data) {
        // If successful, add a row to the form with the new address
        cj(buildNewEmailRow(data.values[data.id])).insertBefore('#new_email_row');
        // Enable its edit box
        cj('span#email-' + data.values[data.id].id + '.crm-editable').crmEditable();
        // Clear the now-added address from the new address box
        cj('#new_email_address').val(null);
        // make the button disabled
        hideButton(cj('#new_email_address'));

      }});
      // Prevent jumping to top of page
      return false;
    });

    // Enable the add new phone link
    cj('#add_new_phone').click(function() {
      // Call the API to add the phone in the 'new' box to the database
      CRM.api('Phone', 'create', {
        'contact_id': {/literal}{$cid}{literal},
        'phone':      cj('#new_phone_number').val()

      }, { success: function(data) {
        // If successful, add a row to the form with the new number
        cj(buildNewPhoneRow(data.values[data.id])).insertBefore('#new_phone_row');
        // Enable its edit box
        cj('span#phone-' + data.values[data.id].id + '.crm-editable').crmEditable();
        // Clear the now-added number from the new number box
        cj('#new_phone_number').val(null);
        // make the button disabled
        hideButton(cj('#new_phone_number'));

      }});
      // Prevent jumping to top of page
      return false;
    });

    /**
     * This function validates if an input field 
     * has an email written on it, it will then enable the
     * submit button, if the input is not an email the disabled 
     * button is displayed 
     */ 
    function validateInputEmail() {
      // like validateInputGeneric but with x@y.z
      var email_string = cj(this).val();
      if( /(.+)@(.+){2,}\.(.+){2,}/.test( email_string) ){
        // show submit button
       showButton(cj(this));
      }
      else {
        // hide submit button
        hideButton(cj(this));
      }
      return false;
    }
    /**
     * Disables the submit button and shows the placeholder one
     * @param element field -  field that has changed
     */
    function hideButton( field ){
      cj(field.attr('correspondingDisabledButton')).show();
      cj(field.attr('correspondingEnabledButton')).hide();
    }
    /*
     * Enables the submit button and hides the placeholder one
     * @param element field - field that has been changed     * 
     */
    function showButton( field ){
      cj(field.attr('correspondingEnabledButton')).show();
      cj(field.attr('correspondingDisabledButton')).hide();
    }
    /**
     * This function is used to validate the 
     * existance of a string in the input field
     * It will then make the submit button visible or not
     *      
     */
    function validateInputGeneric( ) {
      if (cj(this).val() === ""){
        // hide submit button
        hideButton(cj(this));
      }
      else {
        // show submit button
        showButton(cj(this));
      }
      return false;
    }
  // listeners for the inputs
  cj('.newEmailInput').keyup(validateInputEmail);
  cj('.newPhoneInput').keyup(validateInputGeneric);
  // deny the default behaviour of the placeholder buttons
  cj('.placeholder_button').click(function(){
        return false;
  });
  });
</script>
{/literal}
