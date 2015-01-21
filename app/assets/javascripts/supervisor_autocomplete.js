var supervisor_autocomplete = function() {
  var supervisor_provider = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/employees?q=%QUERY'
  });
  supervisor_provider.initialize();
  $('.typeahead-supervisor').typeahead(null, {
    name: 'supervisor',
    displayKey: 'value',
    source: supervisor_provider.ttAdapter(),
    templates: {
      empty: ['<div class="empty-message">',
        $.i18n._('notice_supervisor_not_found'), '</div>'
      ].join('\n'),
      suggestion: Handlebars.compile(['<p class="element-data">{{value}}</p>', '<p class="academy-unit">{{academy_unit}}</p>'].join(''))
    }
  }).on('typeahead:selected typeahead:autocompleted', function(event, datum) {
    set_supervisor_input($(event.target), datum.id);
  }).on('keyup', function(event) {
    if ($('.tt-suggestion').length === 0) {
      set_supervisor_input($(event.target), "");
    }
  });
  $('.typeahead.input-sm').siblings('input.tt-hint').addClass('hint-small');
  $('.typeahead.input-lg').siblings('input.tt-hint').addClass('hint-large');
};
var set_supervisor_input = function(context, value) {
  context.closest("div").find(".twitter-typeahead").next().val(value);
};
$(document).ready(function() {
  supervisor_autocomplete();
});