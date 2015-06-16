# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
`
jQuery(document).ready(function() {

  jQuery('#questions').dynatable({
    features: {
      paginate: true
    },
    dataset: {
      ajax: true,
      ajaxUrl: window.location.pathname + '/questions.json',
      ajaxOnLoad: true,
      records: []
    },
  }).bind('dynatable:afterUpdate', function() {
    reloadNewMap();
  });

  jQuery('.dialog').dialog({
    autoOpen: false
  });

});

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
        jQuery('#questions').data('dynatable').process();
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
  jQuery('.new-variables').off('keydown');
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
  jQuery('.new-variables').keydown(function(e){
    if (e.which == 13) {
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
      jQuery.ajax({
        type: "POST",
        url: "/questions/" + q_id + "/add_variable.json",
        data: {variable_names: variable_names},
        success: function(response) {
          jQuery('#questions').data('dynatable').process();
        },
        error: function(response) {console.log(response);}
      });
    } else if (e.which == 8) {
      this.style.color = null;
    } else if (e.which == 9) {
      if (this.value.trim().length > 0 && this.value.trim().slice(-1) != ',') {
        this.value = this.value.trim() + ',';
        e.preventDefault();
      }
    } else if (e.which == 188) {
      var variable_names = this.value.replace(/(^,)|(,$)/g, "").split(',')
      var var_names_found = 0;
      for (var i = 0; i < variable_names.length; i++) {
        for (var j = 0; j < variables.length; j++) {
          if (variable_names[i] == variables[j])
            var_names_found++;
        }
      }
      if (variable_names.length == var_names_found)
        this.style.color = "green";
      else
        this.style.color = "red";
    }

  });
}
`
