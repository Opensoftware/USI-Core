$(document).ready(function() {
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
      empty: [
      '<div class="empty-message">',
      $.i18n._('notice_supervisor_not_found'),
      '</div>'
      ].join('\n'),
      suggestion: Handlebars.compile([
        '<p class="element-data">{{value}}</p>'
        ].join(''))
    }
  }).on('typeahead:selected', function(event, datum) {
    $(event.target).closest("div").children().last().val(datum.id);
  });
  $('.typeahead.input-sm').siblings('input.tt-hint').addClass('hint-small');
  $('.typeahead.input-lg').siblings('input.tt-hint').addClass('hint-large');

});