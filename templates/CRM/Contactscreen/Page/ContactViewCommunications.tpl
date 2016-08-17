<div class="contactScreenTabContents" id="communicationsTabContents" style="display: none">
  <!-- Buttons to email this alumnus, if they have a primary, not 'on hold', not 'do not email' email address -->
  <div id="communications-buttons" style="display: none;">
    <a class="button communications-button-email" style="display: none;" href="{crmURL p='civicrm/sendemail' q='cid='}{$cid}" title="E-mail this contact through the Dashboard mailer.">Email Alumni (Dashboard)</a>
    <a class="button communications-button-email" style="display: none;" id="communications-button-mailto" title="E-mail this contact using your regular e-mail client.">Email Alumni (Outlook, etc.)</a>
    <a class="button communications-button-sms"   style="display: none;" href="{crmURL p='civicrm/activity/sms/add'   q='selectedChild=activity&atype=4&cid='}{$cid}" title="SMS this contact through the Dashboard mailer.">Send SMS to Alumni</a>
    <br/><br/><br/>
  </div>

  <!-- Table of existing communications between this alumnus and the school and/or FF, loaded on select -->
  <div id="communications-table-div">
    <h6 class="educationTabHeader">Recorded Communications</h6>
    <table id="communications-table" style="display: none;">
      <thead>
        <th>Date/Time</th>
        <th>Type</th>
        <th>Subject</th>
        <th>From</th>
        <th>To</th>
        <!--<th>Actions</th>-->
      </thead>
      <tbody>
      </tbody>
    </table>
    <span id="no-communications" style="display: none;">There are no communications to be displayed.</span>
  </div>
  <div style="text-align: center;" class="loading"><span class="loading"><strong>Loading, please wait...</strong></span></div>
  <br/><br/><br/>

  <!-- Allow teachers to record communications that took place outside of the system -->
  <div id="add-communication">
    <h6 class="educationTabHeader">Record a communication</h6>
    <p><em>
      Please note that communications added here will not be sent.<br/>
      This is just so that you can record communications that haven't taken place through the teacher dashboard.
    </em></p>

    <label for="add-communication-date">Date <input type="text" style="width: 100px;" id="add-communication-date"/></label>
    <label>
      Time
      <input type="number" min="0" max="23" value="0" style="width: 50px;" id="add-communication-hour"/>
      :
      <input type="number" min="0" max="59" value="0" style="width: 50px;" id="add-communication-minute"/>
    </label>

    <!-- Activity type IDs -->
    <label for="add-communication-type">Type <select id="add-communication-type">
      <option value="3" selected="selected">E-mail</option>
      <option value="2">Phone Call</option>
      <option value="4">SMS</option>
    </select></label>
    <br/>

    <label><input type="radio" name="add-communication-direction" value="0" checked="checked"/> To this contact</label><br/>
    <label><input type="radio" name="add-communication-direction" value="1"/> From this contact</label><br/>

    <label for="add-communication-subject">Subject <input type="text" id="add-communication-subject" size="40"/></label><br/>
    <label for="add-communication-details">Details <br/><textarea id="add-communication-details" rows="8" cols="50"></textarea></label><br/>

    <!-- Simulating a single button that can be enabled or disabled -->
    <a class="button" title="Record these communication details" style="background-color: #efefef;" id="add-communication-submit-disabled">Add</a>
    <a class="button" title="Record these communication details" style="display: none;"             id="add-communication-submit"         >Add</a>
    <div class="view_screen_icon_wrapper">
      <span class="crm-status-icon success" style="display: none;" id="add-communication-added"/>
    </div>
  </div>
</div>

{literal}
<script type="text/javascript" language="javascript">
  /**
   * Validates the contents of required input fields for adding a communication,
   * and enables/disables the submit button as appropriate.
   *
   * @returns {boolean} True if required input fields valid, false if not.
   */
  function validateAddCommunication() {
    var commDate          = cj('#add-communication-date').val();
    var commHour          = parseInt(cj('#add-communication-hour').val());
    var commMinute        = parseInt(cj('#add-communication-minute').val());
    var commType          = parseInt(cj('#add-communication-type').val());
    var commIsFromContact = parseInt(cj('input[name=add-communication-direction]:checked').val());
    var commSubject       = cj('#add-communication-subject').val();

    if (
      !isNaN(Date.parse(commDate)) &&
      !isNaN(commHour) && commHour >= 0 && commHour <= 23 &&
      !isNaN(commMinute) && commMinute >= 0 && commMinute <= 59 &&
      (commType == 3 || commType == 2 || commType == 4) &&
      (commIsFromContact == 0 || commIsFromContact == 1) &&
      commSubject.trim().length > 0
    ) {
      cj('#add-communication-submit-disabled').hide();
      cj('#add-communication-submit'         ).show();
      return true;
    }
    else {
      cj('#add-communication-submit-disabled').show();
      cj('#add-communication-submit'         ).hide();
      return false;
    }
  }

  cj(document).ready(function() {

    // Make the Date: field a jQuery datepicker
    cj('#add-communication-date').datepicker({
      dateFormat: cj.datepicker.ISO_8601,
      // Workaround for http://stackoverflow.com/questions/2193169/jquery-ui-datepicker-ie-reload-or-jumps-to-the-top-of-the-page
      onSelect:   function() {
        cj('.ui-datepicker a').removeAttr('href');
        cj(this).change();
      }
    }).datepicker('setDate', new Date());

    // Validate input as soon as it occurs. Which event may depend on the widget.
    cj('#add-communication input, #add-communication select').change(validateAddCommunication);
    cj('#add-communication input, #add-communication select').keyup(validateAddCommunication);

    cj('#add-communication-submit').click(function() {
      var commDate          = cj('#add-communication-date').val();
      var commHour          = parseInt(cj('#add-communication-hour').val());
      var commMinute        = parseInt(cj('#add-communication-minute').val());
      var commType          = parseInt(cj('#add-communication-type').val());
      var commIsFromContact = parseInt(cj('input[name=add-communication-direction]:checked').val());
      var commSubject       = cj('#add-communication-subject').val();
      var commDetails       = cj('#add-communication-details').val();
      var studentCid        = {/literal}{$cid}{literal};
      var teacherCid        = {/literal}{$loggedInUserCiviId}{literal};

      // Disable the button to prevent repeated submissions
      cj('#add-communication-submit-disabled').show();
      cj('#add-communication-submit'         ).hide();

      // Consider a direct communication from the alumnus to the teacher as inbound,
      // even though it didn't actually pass through Civi
      if (commIsFromContact) {
        switch (commType) {
          case 3: commType = 12; break; // Inbound Email
          case 4: commType = 46; break; // Inbound SMS
        }
      }

      // Record the communication
      CRM.api('Activity', 'create', {
        'version':            3,
        'activity_date_time': commDate + ' ' + commHour + ':' + commMinute,
        'activity_type_id':   commType,
        'source_contact_id':  commIsFromContact ? studentCid : teacherCid,
        'target_contact_id':  commIsFromContact ? teacherCid : studentCid,
        'subject':            commSubject,
        'details':            commDetails
      }, { success: function(actCreateResult) {
        // Clear the details and flash an indicator on success
        cj('#add-communication-date'   ).val('');
        cj('#add-communication-subject').val('');
        cj('#add-communication-details').val('');
        showSuccessIcon('#add-communication-added');
      }});
    });

    cj('#communicationsButton').click(function() {
      if (cj(this).attr('loaded') == "false") {
        var tabToShow = cj(this).attr('tabToShow');

        // Show buttons to e-mail the contact?
        if ('{/literal}{$summary.do_not_email}{literal}' == '0') {
          CRM.api('Email', 'get', {
            'version':    3,
            'sequential': 1,
            'contact_id': {/literal}{$cid}{literal},
            'on_hold':    0,
            'is_primary': 1
          }, { success: function(emailGetResult) {
            if (emailGetResult.count > 0) {
              // We have an e-mail address that isn't 'Do not email', isn't on hold, and is primary. Show the buttons.
              var primaryEmail = emailGetResult['values'][0]['email'];
              cj('#communications-button-mailto').attr('href', 'mailto:' + primaryEmail + '?bcc=civi@futurefirst.org.uk');
              cj('#communications-buttons').show();
              cj('.communications-button-email').show();
            }
          }});
        }

        // Show button to SMS the contact?
        if ('{/literal}{$summary.do_not_sms}{literal}' == '0') {
          CRM.api('Phone', 'get', {
            'version':       3,
            'sequential':    1,
            'contact_id':    {/literal}{$cid}{literal},
            'phone_type_id': 2 // Mobile
          }, { success: function(phoneGetResult) {
            if (phoneGetResult.count > 0) {
              // We have a mobile number for a contact that isn't 'Do not SMS'. Show the button.
              cj('#communications-buttons').show();
              cj('.communications-button-sms').show();
            }
          }});
        }

        CRM.api('Student', 'retrievecommunications', {
          'version':    3,
          'school_id':  {/literal}{$schoolId}{literal},
          'student_id': {/literal}{$cid}{literal}

        }, { success: function(data) {
          cj('#' + tabToShow).children('.loading').remove();
          if (data['values'].length == 0) {
            cj('#no-communications').show();
          }

          else {
            var tableRows = '';
            cj.each(data['values'], function(key, value) {
              var tableRow = '<tr>';
              tableRow += '<td>' + escapeHtml(value.activity_date_time) + '</td>';
              tableRow += '<td>' + escapeHtml(value.activity_type_name) + '</td>';

              // Subject
              tableRow += '<td>';
              if (value.type == 'email' && value.direction == 'outbox') {     // (Outbound) Email
                tableRow += '<a href=\"{/literal}{crmURL p='civicrm/show_alumni_teacher_inbox'}{literal}?mailid=' + value.id + '&commtype=email" title="Open in the Mailbox">';
              }
              else if (value.type == 'sms' && value.direction == 'outbox') {  // Outbound SMS
                tableRow += '<a href=\"{/literal}{crmURL p='civicrm/show_alumni_teacher_inbox'}{literal}?mailid=' + value.id + '&commtype=sms" title="Open in the Mailbox">';
              }
              else if (value.type == 'email' && value.direction == 'inbox') { // Inbound Email
                tableRow += '<a href=\"{/literal}{crmURL p='civicrm/show_alumni_teacher_inbox'}{literal}?mailid=' + value.id + '&fromid=' + value.from_cid + '&commtype=email" title="Open in the Mailbox">';
              }
              else if (value.type == 'sms' && value.direction == 'inbox') {   // Inbound SMS
                tableRow += '<a href=\"{/literal}{crmURL p='civicrm/show_alumni_teacher_inbox'}{literal}?mailid=' + value.id + '&fromid=' + value.from_cid + '&commtype=sms" title="Open in the Mailbox">';
              }
              if (value.subject == '') {
                tableRow += '<em>(no subject)</em>';
              }
              else {
                tableRow += escapeHtml(value.subject);
              }
              if (value.type == 'email' || value.type == 'sms') {
                tableRow += '</a>';
              }
              tableRow += '</td>';

              // From
              // (Not including View/Edit links on the contact names,
              // as not all of them will be students we can edit from here)
              tableRow += '<td>' + escapeHtml(value.from_name) + '</td>';

              // To
              tableRow += '<td>';
              cj.each(value.to_contacts, function(tckey, tcvalue) {
                tableRow += escapeHtml(tcvalue) + ', ';
              });
              // Remove the final comma if there is one
              if (cj.makeArray(value.to_contacts).length > 0) {
                tableRow = tableRow.slice(0, -2);
              }
              // If there are more contacts that we haven't named
              if (value.to_more > 0) {
                tableRow += '<br/>(and ' + value.to_more.toLocaleString() + ' other';
                if (value.to_more > 1) {
                  tableRow += 's';
                }
                tableRow += ')';
              }
              tableRow += '</td>';

              // Actions
              /*tableRow += '<td>';
              if (value.type == 'email' && value.direction == 'inbox') { // Inbound Email
                tableRow += '<a href=\"{/literal}{crmURL p='civicrm/sendemail' q='cid='}{$cid}{literal}" title="E-mail this contact through the Dashboard mailer.">Send email</a>';
              }
              if (value.type == 'sms' && value.direction == 'inbox') {   // Inbound SMS
                tableRow += '<a href=\"{/literal}{crmURL p='civicrm/activity/sms/add'   q='selectedChild=activity&atype=4'}&cid={$cid}{literal}" title="SMS this contact through the Dashboard mailer.">Send SMS</a>';
              }
              tableRow += '</td>';*/
              tableRow += '</tr>\n';
              tableRows += tableRow;
            });
            cj('#communications-table tbody').append(tableRows);

            // Columns in the communications table
            var COL_DATE    = 0;
            var COL_TYPE    = 1;
            var COL_SUBJECT = 2;
            var COL_FROM    = 3;
            var COL_TO      = 4;
            var COL_ACTIONS = 5;
            cj('#communications-table').dataTable({
              'aoColumnDefs': [
                {'bSortable': true,  'aTargets': [COL_DATE]},
                {'bSortable': true,  'aTargets': [COL_TYPE]},
                {'bSortable': true,  'aTargets': [COL_SUBJECT]},
                {'bSortable': false, 'aTargets': ['_all']}
              ],
              'aaSorting':    [[COL_DATE, 'desc']]
              //'bFilter':      false,
              //'bInfo':        false,
              //'bPaginate':    false,
            }).before('<br/>').show();
          }
        }});
      }
      cj(this).attr('loaded', 'true'); // unset the callback when first clicked
      return false;
    });

  });
</script>
{/literal}
