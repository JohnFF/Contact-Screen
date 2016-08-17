<div class="contactScreenTabContents" id="customQuestionsAnswersTabContent" style="display: none">
  <div style="text-align: center;" class="loading">
    <span class="loading">
      <strong>Loading, please wait...</strong>
    </span>
  </div>
  <br>
</div>

{literal}
<script type="text/javascript" language="javascript">
  
  /* getActiveMultiSelectOptions
   * Get all the selected options that are from the same 
   * group as the updated element
   * @param {DOM object} updatedElement - element that has been changed
   * @returns {Array} multi_select_options - all the active options
   */
  function getActiveMultiSelectOptions(updatedElement){
    var multi_select_options = [];
    
    var option_group_id = updatedElement.attr('name');
    cj('.custom_'+option_group_id+':checked').each(function() {
        multi_select_options.push(cj(this).val());
     });
    
    return multi_select_options;
  }
  
  /**
   * createOptionsCustomQuestionString
   * Creates the html string for the custom question
   * options selectors (radio or checkbox)
   * @param {array} optionsList all possible answers for this custom question
   * @param {array| int} selectedOptions selected answers for this question
   * @param {string} html_type - html type of the custom question
   * @param {int} question_id - id of the custom question this options belongs to
   * @returns {string} - option_string - input string to be used on the custom
   *                                     questions options.
   */
  function createOptionsCustomQuestionString(optionsList, selectedOptions, html_type, question_id){
    var input_type;
    var option_string = "";
    switch (html_type){
      case "Multi-Select":
        input_type = "checkbox";
        break;
      case "Select":
        input_type = "radio";
        break;
      default:
        return option_string;
    }
    // Variable creation
    var choice;
    var checked = '';
    var OPTION_NOT_SELECTED = -1;
    cj.each(optionsList['values'], function(option_key, option_values) {
      choice = cj.inArray(option_values.value, selectedOptions);
      // See if we have a match
      if (choice !== OPTION_NOT_SELECTED || option_values.value == selectedOptions) {
        checked = "checked";
      }
      option_string = option_string + "<input corresponding_success_icon=\"#custom_question_" + question_id + "_row_icon\" class=\" show_update_success custom_question_option custom_option_group_id_" + option_values.option_group_id + "\" " + checked + " name=\"option_group_id_" + option_values.option_group_id + "\" type=\"" + input_type + "\" value=\"" + escapeHtml(option_values.value) + "\" >" + escapeHtml(option_values.label) + "<br>";
      checked = '';
    });
    
    return option_string;
  }
  
cj('#customQuestionsButton').click(function() {
  if (cj(this).attr('loaded') == "false") {
      var tabToShow = cj(this).attr('tabToShow');
      // Api call that retrieves the custom questions
      CRM.api('Student', 'retrievecustomquestionanswers', 
        {'version': 3,
         'sequential': 1,
         'iContactId': {/literal}{$cid}{literal},
         'schoolId': {/literal}{$schoolId}{literal},
         'iLoggedInUser': {/literal}{$loggedInUserCiviId}{literal},
         'magicword': 'sesame'},
        {success: function(data) {
            // The string creates the table that has the custom questions/answers
            // This is done in a string because just appending does not work if the element is just being created.
            var cqTableString = "<table class=\"view-and-edit-table\" id='customQuestionsTable'>\n\
                                  <tr>\n\
                                    <th>Question</th>\n\
                                    <th>Answer</th>\n\
                                  </tr>";
            cj.each(data['values'], function(key, value) {              
              cqTableString = cqTableString + "<tr>";
              cqTableString = cqTableString + "<td>" + escapeHtml(value.label) + "</td>";
              if ( value.html_type != "Text") {
                var question_options =  createOptionsCustomQuestionString(value.answer.custom_question_options, value.answer.selected_options, value.html_type, value.id);
                cqTableString = cqTableString + "<td question_id=\"" + value.id + "\">" + question_options + "</td>";
              } 
              else {
                cqTableString = cqTableString + "<td id=\"contact-{/literal}{$cid}{literal}\" class=\"crm-entity {/literal}{$cid}{literal}\"  question_id=\"" + value.id + "\"><span corresponding_success_icon=\"#custom_question_" + value.id + "_row_icon\" id=\"contact-{/literal}{$cid}{literal}\" class=\"crmf-custom_" + value.id + " crm-editable crm-editable-enabled show_update_success\">" + escapeHtml(value.answer) + "</span></td>";
              }
              
              cqTableString = cqTableString + "\
              <td class=\"view_screen_icon_wrapper\">\n\
                <span id=\"custom_question_" + value.id + "_row_icon\" class=\"crm-status-icon success\" style=\"display: none\"></span>\n\
              </td>";
              cqTableString = cqTableString + '</tr>';
            });
            cqTableString = cqTableString + "</table>";
            // Load the table
            cj('#' + tabToShow).append(cqTableString);
            // Make the spans editable.
            cj('span.crm-editable').crmEditable();            
            // Remove the loading message
            cj('#' + tabToShow).children('.loading').remove();
          }
        }
      );
  }
  cj(this).attr('loaded', 'true'); // unset the callback when first clicked
  return false;
 });
 
  /*
   * Listener for the changes on the custom question options.
   */
  cj('#customQuestionsAnswersTabContent').on('change', '.custom_question_option', function(){
    var question_values = cj(this).val();
    var question_type = cj(this).attr('type');
    var custom_question_id = "custom_" + cj(this).parent().attr('question_id');
    
    var update_custom_questions_api_params = {
      'version' : 3,
      'sequential' : 1,
      'id': {/literal}{$cid}{literal},
    }
    // If the question is a Select (=radio) update
    if ( question_type === "radio" ){
      update_custom_questions_api_params[custom_question_id] = question_values;
    }
    // If the question is a multi-select get all the active options
    else {
      update_custom_questions_api_params[custom_question_id] = getActiveMultiSelectOptions(cj(this));
    }
    CRM.api('Contact','create', update_custom_questions_api_params,
      { success: function(success_data) {
        
      }});
  });       
</script>
{/literal}
