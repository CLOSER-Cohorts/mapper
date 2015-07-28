# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`

  jQuery.fn.extend({
    autoCompleteFromList: function (list) {
    
        var split = function(val) {
          return val.split(/,\s*/);
        }
        var extractLast = function(term) {
          return split(term).pop();
        }
      
      return jQuery(this).autocomplete({
        source: function(request, response) {
          var found = [];
          var lastTerm = extractLast(request.term);
          for (var i = 0; i < list.length; i++) {
            var pos = list[i].search(lastTerm);
            if (pos > -1) {
              found.push({pos: pos, var: list[i]});
            }
          }
          found.sort(function(a, b) {
            return a['pos'] - b['pos'];
          });
          var result = [];
          for (var i = 0; i < found.length; i++) {
            result.push(found[i]['var']);
          }
          response(result); 
        },
        search: function () {
          var lastTerm = extractLast(this.value);
          if (lastTerm.length < 1) {
            return false;
          }
        },
        focus: function(event, ui) {
          var terms = this.value.split(',');
          terms.pop();
          terms.push(ui.item.value);
          this.value = terms.join(',');
          return false;
        },
        select: function(event, ui) {
          var terms = this.value.split(',');
          terms.pop();
          terms.push(ui.item.value);
          this.value = terms.join(',');
          return false;
        }
      });
    },
    newKeyDown: function (selector, url, payload_name, list) {
        var checkList = function(me, list) {
          var names = me.value.replace(/(^,)|(,$)/g, "").split(',')
          var found = 0;
          for (var i = 0; i < names.length; i++) {
          for (var j = 0; j < list.length; j++) {
            if (names[i] == list[j])
              found++;
            }
          }
          if (names.length == found)
            me.style.color = "green";
          else
            me.style.color = "red";
        }
      var keyDownAction = function(e) {
        if (e.which == 13) {
          focus_id = this.id;
          var names = this.value.split(',');
          for (var i = 0; i < names.length; i++) {
            names[i] = names[i].trim();
          }
          var tmp = names;
          names = [];
          for (var i = 0; i < tmp.length; i++) {
            if (tmp[i].length > 0)
              names.push(tmp[i]);
          }
          this.value = null;
          
          offset = 0;
          start = url.indexOf('{');
          parsed_url = url.substring(offset,start);
          end = url.indexOf('}', start);
          parsed_url += jQuery(this).data(url.substring(start+1,end));
          parsed_url += url.substring(end+1);
          
          data = {};
          data[payload_name] = names;
          
          jQuery.ajax({
            type: "POST",
            url: parsed_url,
            data: data,
            success: function(response) {
              console.log(response);
              reloadTables();
            },
            error: function(response) {console.log(response);}
          });
        } else if (e.which == 8) {
          this.style.color = null;
        } else if (e.which == 9) {
          if (this.value.trim().length > 0 && this.value.trim().slice(-1) != ',') {
            this.value = this.value.trim() + ',';
            e.preventDefault();
            checkList(this, list);
          }
        } else if (e.which == 188) {
          checkList(this, list);
        }
      };
      this.on('keydown',selector,keyDownAction);
    }
  });

focus_id = null
var getFocusID = function() {
  jQuery(':focus').each(function() {
    focus_id = jQuery(this).attr('id');
  });
};

tables = [];

var reloadTables = function(activeCallback, totalCallback) {
  activeCallback = (typeof activeCallback === 'function') ? activeCallback : function() {};
  totalCallback = (typeof totalCallback === 'function') ? totalCallback : function() {};

  total = 0;
  end = function() {
    total++;
    if (total >= tables.length)
      totalCallback();
  };
  getFocusID();
  jQuery(':focus').blur();
  genericCallback = function(tab) {
    if (jQuery('#tabs').tabs('option','active') === tab) {
      activeCallback();
      jQuery('#'+focus_id).focus();
    }
    end();
  };
  for (var i = 0; i < tables.length; i++) {
    tables[i].ajax.reload( function() {
      genericCallback(i);
    }, false );
  }
};

var ready = function() {
  tables.push(jQuery('#questions').DataTable({
    ajax: {
      url: window.location.pathname + '/questions.json',
      dataSrc: function ( json ) {
        $topic_selector = jQuery('#original-topic-selector');
        for (var i = 0; i < json.data.length; i++) {
          $selector = $topic_selector.clone();
          $selector.removeProp('id')
          $selector.attr('data-type', 'question').attr('data-id', json.data[i].id);
          if (json.data[i].itopic != null) {
            $selector.children('option[value="' + json.data[i].itopic.id + '"]').attr('selected', 'selected');
          } else {
            $selector.children().eq(1).attr('selected', 'selected');
          }
          if (json.data[i].ptopic != null)
            $selector
              .children('option[value="' + json.data[i].ptopic.id + '"]')
                .append(' (inherited)');
          else
            $selector
              .children().eq(1)
                .append(' (inherited)');
          json.data[i].topic = $selector.prop('outerHTML');
        }
        return json.data;
      }
    },
    columns: [
      {data: 'id'},
      {data: 'qc'},
      {data: 'literal'},
      {data: 'variables'},
      {data: 'topic'},
      {data: 'actions'}
    ]
  }));
  
  tables.push(jQuery('#variables').DataTable({
    ajax: window.location.pathname + '/variables.json',
    columns: [
      {data: 'id'},
      {data: 'name'},
      {data: 'var_type'},
      {data: 'label'},
      {data: 'outputs'},
      {data: 'sources'},
      {data: 'topic'},
      {data: 'actions'}
    ]
  }));
  
  tables.push(jQuery('#sequences').DataTable({
    ajax: window.location.pathname + '/sequences.json',
    columns: [
      {data: 'id'},
      {data: 'name'},
      {data: 'topic'},
      {data: 'actions'}
    ]
  }));
  
  for (var i = 0; i < tables.length; i++) {
    tables[i].on('xhr.dt', function() {
      getFocusID();
      jQuery(':focus').blur();
    });
    tables[i].on('draw.dt', function() {
      reloadNewMap();
      jQuery('#'+focus_id).focus();
    });
  }

  jQuery('.dialog').dialog({
    autoOpen: false
  });

  jQuery('#tabs').tabs();
  
  jQuery('#questions').newKeyDown(
    'input.new-variables',
    "/questions/{id}/add_variable.json",
    "variable_names",
    variables
  );
  
  jQuery('#variables').newKeyDown(
    'input.new-questions',
    "/variables/{id}/add_question.json",
    "qcs",
    questions
  );
  
  jQuery('#variables').newKeyDown(
    'input.new-variables',
    "/variables/{id}/add_variable.json",
    "variable_names",
    variables
  );
  
  jQuery('#questions,#variables,#sequences').on('change','select.topic-selector',function() {
    type = jQuery(this).data('type');
    id = jQuery(this).data('id');
    data = {topic_id: this.value}
    jQuery.ajax({
      type: "POST",
      url: "/" + type + "s/" + id + "/set_topic.json",
      data: data,
      beforeSend: function() {
        //jQuery('select.topic-selector').prop('disabled', true);
      },
      success: function(response) {
        console.log(response);
        reloadTables();
      },
      error: function(response) {console.log(response);}
    });
  });
  
  jQuery('#questions').on('click', '.remove-variable', function() {
    var id_bits = this.id.split('-');
    var variable_id = parseInt(id_bits.pop());
    var q_id = parseInt(id_bits.pop());
    jQuery.ajax({
      type: "POST",
      url: "/questions/" + q_id + "/remove_variable.json",
      data: {variable_id: variable_id},
      success: function(response) {
        reloadTables();
      },
      error: function(response) {console.log(response);}
    });
  });
  
  jQuery('#variables').on('click','.remove-question',function() {
    var id_bits = this.id.split('-');
    var question_id = parseInt(id_bits.pop());
    var v_id = parseInt(id_bits.pop());
    jQuery.ajax({
      type: "POST",
      url: "/variables/" + v_id + "/remove_question.json",
      data: {question_id: question_id},
      success: function(response) {
        reloadTables();
      },
      error: function(response) {console.log(response);}
    });
  });
  
  jQuery('#variables').on('click', '.remove-variable', function() {
    var id_bits = this.id.split('-');
    var variable_id = parseInt(id_bits.pop());
    var v_id = parseInt(id_bits.pop());
    jQuery.ajax({
      type: "POST",
      url: "/variables/" + v_id + "/remove_variable.json",
      data: {variable_id: variable_id},
      success: function(response) {
        reloadTables();
      },
      error: function(response) {console.log(response);}
    });
  });

};

jQuery(document).ready(ready);
jQuery(document).on('page:load', ready);

var reloadNewMap = function() {

  jQuery('.new-variables').autoCompleteFromList(variables);

  jQuery('.new-questions').autoCompleteFromList(questions.concat(variables));
  
}
`
