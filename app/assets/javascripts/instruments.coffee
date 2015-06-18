# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`
focus_id = null
var getFocusID = function() {
  jQuery(':focus').each(function() {
    focus_id = jQuery(this).attr('id');
  });
};
var reloadTables = function(activeCallback, totalCallback) {
  activeCallback = (typeof activeCallback === 'function') ? activeCallback : function() {};
  totalCallback = (typeof totalCallback === 'function') ? totalCallback : function() {};

  total = 0;
  end = function() {
    total++;
    if (total > 1)
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
  $questions.ajax.reload( function() {
    genericCallback(0);
  }, false );
  $variables.ajax.reload( function() {
    genericCallback(1);
  }, false );
};

var ready = function() {
  $questions = jQuery('#questions').DataTable({
    ajax: window.location.pathname + '/questions.json',
    columns: [
      {data: 'id'},
      {data: 'qc'},
      {data: 'literal'},
      {data: 'variables'},
      {data: 'actions'}
    ]
  });
  
  $questions.on('xhr.dt', function() {
    getFocusID();
    jQuery(':focus').blur();
  });
  $questions.on('draw.dt', function() {
    reloadNewMap();
    jQuery('#'+focus_id).focus();
  });
  
  $variables = jQuery('#variables').DataTable({
    ajax: window.location.pathname + '/variables.json',
    columns: [
      {data: 'id'},
      {data: 'name'},
      {data: 'label'},
      {data: 'questions'},
      {data: 'actions'}
    ]
  });
  
  $variables.on('xhr.dt', function() {
    getFocusID();
    jQuery(':focus').blur();
  });
  $variables.on('draw.dt', function() {
    reloadNewMap();
    jQuery('#'+focus_id).focus();
  });

  jQuery('.dialog').dialog({
    autoOpen: false
  });

  jQuery('#tabs').tabs();

};

jQuery(document).ready(ready);
jQuery(document).on('page:load', ready);

var reloadNewMap = function() {
  jQuery('.remove-variable').click(function() {
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
  jQuery('.remove-question').click(function() {
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
  var split = function(val) {
    return val.split(/,\s*/);
  }
  var extractLast = function(term) {
    return split(term).pop();
  }
  //jQuery('.new-variables').off('keydown');
  jQuery('.new-variables').autocomplete({
    source: function(request, response) {
      var found = [];
      var lastTerm = extractLast(request.term);
      for (var i = 0; i < variables.length; i++) {
        var pos = variables[i].search(lastTerm);
        if (pos > -1) {
          found.push({pos: pos, var: variables[i]});
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

  jQuery('.new-questions').autocomplete({
    source: function(request, response) {
      var found = [];
      var lastTerm = extractLast(request.term);
      for (var i = 0; i < questions.length; i++) {
        var pos = questions[i].search(lastTerm);
        if (pos > -1) {
          found.push({pos: pos, var: questions[i]});
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
  
  var checkVariables = function(me) {
    var variable_names = me.value.replace(/(^,)|(,$)/g, "").split(',')
    var var_names_found = 0;
    for (var i = 0; i < variable_names.length; i++) {
      for (var j = 0; j < variables.length; j++) {
        if (variable_names[i] == variables[j])
          var_names_found++;
      }
    }
    if (variable_names.length == var_names_found)
      me.style.color = "green";
    else
      me.style.color = "red";
  }
  
  var checkQuestions = function(me) {
    var question_names = me.value.replace(/(^,)|(,$)/g, "").split(',')
    var q_names_found = 0;
    for (var i = 0; i < question_names.length; i++) {
      for (var j = 0; j < questions.length; j++) {
        if (question_names[i] == questions[j])
          q_names_found++;
      }
    }
    if (question_names.length == q_names_found)
      me.style.color = "green";
    else
      me.style.color = "red";
  }
  
  jQuery('.new-variables').keydown(function(e){
    if (e.which == 13) {
      focus_id = this.id;
      var variable_names = this.value.split(',');
      for (var i = 0; i < variable_names.length; i++) {
        variable_names[i] = variable_names[i].trim();
      }
      var tmp = variable_names;
      variable_names = [];
      for (var i = 0; i < tmp.length; i++) {
        if (tmp[i].length > 0)
          variable_names.push(tmp[i]);
      }
      this.value = null;
      q_id = this.id.split('-')[2];
      var field_id = this.id
      jQuery.ajax({
        type: "POST",
        url: "/questions/" + q_id + "/add_variable.json",
        data: {variable_names: variable_names},
        success: function(response) {
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
        checkVariables(this);
      }
    } else if (e.which == 188) {
      checkVariables(this);
    }

  });
  
  jQuery('.new-questions').keydown(function(e){
    if (e.which == 13) {
      focus_id = this.id;
      var qcs = this.value.split(',');
      for (var i = 0; i < qcs.length; i++) {
        qcs[i] = qcs[i].trim();
      }
      var tmp = qcs;
      qcs = [];
      for (var i = 0; i < tmp.length; i++) {
        if (tmp[i].length > 0)
          qcs.push(tmp[i]);
      }
      this.value = null;
      v_id = this.id.split('-')[2];
      var field_id = this.id
      jQuery.ajax({
        type: "POST",
        url: "/variables/" + v_id + "/add_question.json",
        data: {qcs: qcs},
        success: function(response) {
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
        checkQuestions(this);
      }
    } else if (e.which == 188) {
      checkQuestions(this);
    }

  });
}
`
