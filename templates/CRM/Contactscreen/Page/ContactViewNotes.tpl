<div class="contactScreenTabContents" id="notesTabContents" style="display: none">
  {* Table that contains the input form for a new note *}
   <table class="view-and-edit-table" id="add-new-note">
      <thead>
        <tr>
          <th>New note</th>        
          <th width="15%">Actions</th>
        </tr>
      </thead>
      <tr>
        <td><strong>Title  </strong><span><input correspondingDisabledButton="#add-new-note-button-placeholder" correspondingEnabledButton="#add-new-note-button" class="note-form" id="add-new-note-subject" type="text" placeholder=""></span></td>
        <td></td>
      </tr>
      <tr>
        <td><strong>Note </strong><span><input correspondingDisabledButton="#add-new-note-button-placeholder" correspondingEnabledButton="#add-new-note-button" class="note-form" size="55" id="add-new-note-text" type="text" placeholder=""></span></td>
        <td>
          <a href='#' style="background-color: #efefef ;" class="button" id="add-new-note-button-placeholder">  Add new </a>
          <a style="display: none" href="#" id="add-new-note-button" class="button" title="Click here to add a new note to this contact.">Add new</a></td>
      </tr>
    </table>
   <table class="view-and-edit-table" style="display: none" id='notesTable'>
     <thead>
       <tr>
         <th>Title</th>
         <th>Note</th>
         <th style="text-align:center;">Date</th>
         <th style="text-align:center;">Author</th>
         <th style="text-align:center;">Actions</th>
         <th></th>
       </tr>
     </thead>
     <tbody>
       
     </tbody>
   </table>
  <div  style="text-align: center;" class="loading"><span class="loading"><strong>Loading, please wait...</strong></span></div>
    
    <br><br>
   
</div>
{literal}
<script type="text/javascript" language="javascript">

  function buildNewNoteRow(noteData) {
    // if no date...
    return "\
      <tr class='note-row' id='note_row_" + noteData.id +"'>\n\
        <td id=\"note-" + noteData.id + "\" class=\"crm-entity " + noteData.id + "\">\n\
          <span corresponding_success_icon=\"#note_" + noteData.id + "_row_icon\" id=\"note-" + noteData.id + "\" class=\"crmf-subject crm-editable show_update_success\">" + escapeHtml(noteData.subject) + "</span>\n\
        </td>\n\
        <td id=\"note-" + noteData.id + "\" class=\"crm-entity " + noteData.id + "\">\n\
          <span corresponding_success_icon=\"#note_" + noteData.id + "_row_icon\" id=\"note-" + noteData.id + "\" class=\"crmf-note crm-editable show_update_success\">" + escapeHtml(noteData.note) + "</span>\n\
        </td>\n\
        <td style=\"text-align:center;\">" + noteData.modified_date + "</td>\n\
        <td style=\"text-align:center;\">" + noteData.author_id + "</td>\n\
        <td style=\"text-align:center;\">\n\
          <a title=\"Delete this note.\" href=\"#\" class=\"delete-note-button delete-button\" note_id=\"" + noteData.id + "\">Delete</a>\n\
        </td>\n\
        <td class=\"view_screen_icon_wrapper\">\n\
          <span id=\"note_" + noteData.id + "_row_icon\" class=\"crm-status-icon success\" style=\"display: none\"></span>\n\
        </td>\n\
      </tr>";
  };

  // Enable the add new note button
  function validateInputNote() {
    // hardcoded ids because there's only one new note field atm
    var note_subject =  cj('#add-new-note-subject').val();
    var note_text = cj('#add-new-note-text').val();

    // Is the form empty?
    if (note_subject === '' || note_text === '') {
      // If so place the placeholder button again 
      cj(cj(this).attr('correspondingDisabledButton')).show();
      cj(cj(this).attr('correspondingEnabledButton')).hide();
      return false;
    }                    

    // otherwise show the enabled button
    cj(cj(this).attr('correspondingEnabledButton')).show();
    cj(cj(this).attr('correspondingDisabledButton')).hide();
    return false;
  }

  cj(document).ready(function() {
    // Prevent placeholder button from doing anything
    // We are using a button class to maitain the visual consistency
    cj('#add-new-note-button-placeholder').click(function() {
      return false;
    });

    // listener for the new note form
    cj('.note-form').keyup(validateInputNote);

    // Set listerer for the note delete button
    cj('#notesTable').delegate('.delete-note-button', 'click', function() {
      // Ask for user confirmation
      if (!confirm("Do you want to permanently delete this note?")){
        return false;
      }
      var note_id = cj(this).attr('note_id');

      // Call the API to remove it from the database
      CRM.api('Note', 'delete', {
        'id': note_id
      }, { success: function(data) {
        // If successful, remove it from the form
        cj('#note_row_' + note_id).remove();
        // If no more rows show message
        var rowCount = cj('.note-row').length;
        if (rowCount === 0) {
          cj('#notesTable').after("<strong id='empty-table'>There are no notes to be displayed.</strong>");                
        }
      }});

      // Prevent jumping to top of page
      return false;
    });

    // Listener for the 'Add new' button
    cj('#add-new-note-button').click(function() {
      // Get the field's values
      var new_note_subject = cj('#add-new-note-subject').val();
      var new_note_text = cj('#add-new-note-text').val();
      var autor_name = "{/literal}{$loggedInUserName}{literal}";
      CRM.api('Note', 'create', {
        'sequential': 1,
        'entity_id':  {/literal}{$cid}{literal},
        'note':       new_note_text,
        'subject':    new_note_subject,
        'contact_id': {/literal}{$loggedInUserCiviId}{literal}
      },
      { success: function(data) {
        var noteRows = '';
        cj.each(data['values'], function(key, value) {
          // HACK to show the correct date because the API returns a string that JS can't deal with
          // This is a note that has just been created
          var modified = new Date();
          var faux_modified_date = modified.getFullYear() + '-' + (("0" + (modified.getMonth() + 1)).slice(-2)) + '-' + modified.getDate();
          // Set values on the object and call the function to add the new row;
          value['modified_date'] = faux_modified_date;          
          value['author_id'] = autor_name;
          noteRows += buildNewNoteRow(value);
        });

        cj('#notesTable tbody').append(noteRows);
        cj('span.crm-editable').crmEditable();
        // Remove the message that says there are no messages
        cj('#empty-table').remove();
        // Clear the text on the input boxes
        cj('#add-new-note-subject').val(null);
        cj('#add-new-note-text').val(null);
        cj('#add-new-note-button').hide();
        cj('#add-new-note-button-placeholder').show();
      }});

      return false;
    });

    cj('#notesButton').click(function() {
      if (cj(this).attr('loaded') == "false") {
        var tabToShow = cj(this).attr('tabToShow');                
        CRM.api('Student', 'retrievenotes', {
          'version':       3,
          'sequential':    1,
          'iContactId':    {/literal}{$cid}{literal},
          'iLoggedInUser': {/literal}{$loggedInUserCiviId}{literal}
        },
        { success: function(data) {
          // If there are no notes show a message.
          if (data['values'].length === 0) {
            cj('#notesTable').after("<strong id='empty-table'>There are no notes to be displayed.</strong>");
          }
          else {
            // Create a table of notes
            var noteRows = '';
            cj.each(data['values'], function(aKey, noteDataValues) {
              // Add a new row to the table.
              noteRows += buildNewNoteRow(noteDataValues);
            });
            cj('#notesTable tbody').append(noteRows);
            // Make the fields editable
            cj('span.crm-editable').crmEditable();
          }
          cj('#' + tabToShow).children('.loading').remove();
          cj('#notesTable').show();
        }});
      }
      cj(this).attr('loaded', 'true'); // unset the callback when first clicked
      return false;
    });

  });
</script>
{/literal}
