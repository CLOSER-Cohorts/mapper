# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
` 

removeTopic = function(type, id) {
  jQuery.ajax({
    type: "POST",
    url: "/" + type.toLowerCase() + "s/" + id + "/set_topic.json",
    data: {topic_id: -1},
    success: function(response) {
	  console.log(response);
	  var dt = jQuery('#' + type + '-' + id);
	  dt.nextUntil('dt').remove();
	  dt.remove();
    },
    error: function(response) {console.log(response);}
    });
};

resolveConflict = function(fixed_points) {
  var items = [];
  for (var i = 0; i < fixed_points.length; i++) {
    if (fixed_points[i].type === "Question") {
      items.push("<dt id='" + fixed_points[i].type + "-" + fixed_points[i].obj.id + "'>" +  fixed_points[i].obj.qc +  "</dt>");
      items.push('<dd class="label">' + fixed_points[i].obj.literal + '</dd>');
    } else {
      items.push("<dt id='" + fixed_points[i].type + "-" + fixed_points[i].obj.id + "'>" +  fixed_points[i].obj.name+  "</dt>");
      items.push('<dd class="label">' + fixed_points[i].obj.label + '</dd>');
    }
    items.push('<dd class="topic">' + fixed_points[i].topic.name + 
      '<a href="javascript://" class="remove" onClick="removeTopic(\'' + 
      fixed_points[i].type + '\',\'' + fixed_points[i].obj.id + '\')" >Remove</a></dd>');
  }
  jQuery('<div />')
    .prop('title', 'Resolve Topic Conflict')
    .html('<dl class="conflict-resolution">' + items.join('') + '</dl>').dialog({
      minWidth: 400,
      close: function() {
        reloadTables();
      }
    });
};

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
          if (this.hasAttribute("data-x") && this.hasAttribute("data-y")) {
            data['x'] = this.dataset.x;
            data['y'] = this.dataset.y;
          }
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
  var end = function() {
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

var get_variable_names = function(id, variables, select_x, select_y) {
  var var_names = [];
	for (var j = 0; j < variables.length; j++) {
	  if (variables[j].x == select_x && variables[j].y == select_y) {
		var_names.push('<span class="nowrap">' + variables[j].name + 
		  '<a tabindex="-1" href="javascript://" class="remove remove-variable" id="remove-variable-' + 
		  id + '-' + variables[j].id + '" ></a></span>');
	  }
	}
	return var_names.join(', ');
};

var draw_add_variable_input = function(id, x, y) {
  var output = '';
  
  output += '<input data-id="' + id + '" ';
  if (typeof x === 'number')
    output += 'data-x="' + x.toString() + '" ';
  if (typeof y === 'number') {
    output += 'data-y="' + y.toString() + '" ';
    if (y < 1)
      output += 'disabled="disabled" ';
  }
  output += 'type="text" placeholder="Add Variables" ';
  output += 'class="new-variables';
  if (typeof x === 'number' && typeof y === 'number')
    output += ' grid-coordinate';
  output += '" />';
  
  return output;
};

var draw_subrow = function(d) {
  // 'd' is the original data object for the row
  var output = '';
  output += '<div><table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">';
  for (var y = 0; y <= d.max_y; y++) {
    output += '<tr class="row-' + y.toString() + '">';
    for (var x = 0; x <= d.max_x; x++) {
      output += '<td class="col-' + x.toString() + '">';
      var var_names = get_variable_names(d.id, d.orig_variables, x, y);
      output += (var_names.length > 0 ? var_names + '<br/>' : '');
      output += draw_add_variable_input(d.id, x, y);
      output +=  '</td>';
    }
    output += '</tr>';
  }
    return output + '</table></div>';
};

var ready = function() {

  var dataSrc = function ( json ) {
	$topic_selector = jQuery('#original-topic-selector');
	for (var i = 0; i < json.data.length; i++) {
	  if (json.data[i].itopic != null && json.data[i].itopic.id == -1) {
		json.data[i].topic = '<a style="color: red;" href="javascript://" onClick=\'resolveConflict(' + JSON.stringify(json.data[i].itopic.fixed_points) + ')\'>ERROR</a>';
	  } else {
		$selector = $topic_selector.clone();
		$selector.removeProp('id')
		$selector.attr('data-type', json.data[i].type).attr('data-id', json.data[i].id);
		console.log(json.data[i].itopic);
		if (json.data[i].itopic != null) {
		  $selector.children('option[value="' + json.data[i].itopic.id + '"]').attr('selected', 'selected');
		} else {
		  $selector.children().eq(1).attr('selected', 'selected');
		}
		if (json.data[i].ptopic != null) {
		  $selector
			.children('option[value="' + json.data[i].ptopic.id + '"]')
			  .append(' (inherited)');
		} else {
		  $selector
			.children().eq(1)
			  .append(' (inherited)');
		}
		json.data[i].topic = $selector.prop('outerHTML');	
	  }
	  json.data[i].variables = '';
	  if (json.data[i].orig_variables != null) {
	    json.data[i].variables = get_variable_names(json.data[i].id, json.data[i].orig_variables, null, null) + '<br/>';
	  }
	  if (typeof json.data[i].out_variables !== 'undefined') {
	    outputs = [];
	    for (var j = 0; j < json.data[i].out_variables.length; j++) {
	      outputs.push(json.data[i].out_variables[j].name);
	    }
	    json.data[i].outputs = '<span class="nowrap">' + outputs.join(', ') + '</span>'
	  }
	  json.data[i].variables += draw_add_variable_input(json.data[i].id);
	  json.data[i].actions = '<a tabindex="-1" class="destroy" data-confirm="Are you sure?"' +
	    'rel="nofollow" data-method="delete" href="/' + json.data[i].type + 's/' + json.data[i].id + '">Destroy</a>';
	}
	return json.data;
  }

  tables.push(jQuery('#questions').DataTable({
    ajax: {
      url: window.location.pathname + '/questions.json',
      dataSrc: dataSrc
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
    ajax: {
      url: window.location.pathname + '/variables.json',
      dataSrc: dataSrc
    },
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
      if (this.id === "questions") {
        jQuery(this).DataTable({retrieve: true}).rows().every(function() {
          if (this.data().max_x !== null && this.data().max_y !== null) {
            this.child( draw_subrow(this.data()) ).show();
          }
        });
      }
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
