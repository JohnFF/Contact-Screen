<div class="contactScreenTabContents" id="mobilisationsTabContents" style="display: none">
  {* Button that redirect to the add new mobilisation feature *}
  <a href="{$base_url}/civicrm/mobilise?&cids[]={$cid}" class="button" title="Record a new mobilisation for this contact.">Add new mobilisation</a><br><br>
  <div style="text-align: center;" class="loading">
    <span class="loading">
      <strong>Loading, please wait...</strong>
    </span>
  </div>  
  
</div>

{literal}
<script type="text/javascript" language="javascript">
  
  cj('#mobilisationsButton').click(function() {
    if (cj(this).attr('loaded') == "false") {
      var tabToShow = cj(this).attr('tabToShow');
      CRM.api('Student', 'retrievemobilisations', {
        'version': 3,
        'sequential': 1,
        'iContactId' :{/literal}{$cid}{literal}
        },
        {success: function(data) {
            // If there are no moilisations to be shown set a message
          if(data['values'] === null ||  data['values'].length === 0 ){
            cj('#' + tabToShow).append("<strong>There are no mobilisations to be displayed</strong>");
          }
          else{
          // Using the String and not append because this is content that is created and the ID ussed on the append did not exist
          var tableString = "<table class=\"view-and-edit-table\" id='mobilisationsTable'><tr><th>Mobilisations</th><th width='20%'>Actions</th></tr>";                    
          cj.each(data['values'], function(key, value) {
             tableString = tableString + "<tr>";
             tableString = tableString + "<td>" + escapeHtml(value.displayString) + "</td><td>";
             if (value.event_id !== null) {
               // This is an event
               var editUrl   = CRM.url('civicrm/mobilise/update/participant',      { 'event_id': value.event_id, 'cids[]': {/literal}{$cid}{literal} });
               var deleteUrl = CRM.url('civicrm/mobilise/del', { 'action': 'delete', 'event_id': value.event_id, 'cid':    {/literal}{$cid}{literal} });
               tableString = tableString + "<a href='" + editUrl + "' title='Edit participation.'>Edit</a> ";
               tableString = tableString + "| <a href='" + deleteUrl + "' title='Delete participation. Please note this does not delete the mobilisation itself.'>Delete</a>";
             }
             tableString = tableString + "</td></tr>";
          });
          tableString = tableString + "</table>"; 
          cj('#' + tabToShow).append(tableString);
        }
        // Remove the loading message
        cj('#' + tabToShow).children('.loading').remove();
        }
        });
    }
   cj(this).attr('loaded', 'true'); // unset the callback when first clicked
   return false;     
  });
  
</script>
{/literal}
