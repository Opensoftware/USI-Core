$(document).ready(function() {
  var students_provider = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/students?q=%QUERY'
  });
  students_provider.initialize();
  $('.typeahead-student').typeahead(null, {
    name: 'students',
    displayKey: 'value',
    source: students_provider.ttAdapter(),
    templates: {
      empty: ['<div class="empty-message">',
        $.i18n._('notice_students_not_found'), '</div>'
      ].join('\n'),
      suggestion: Handlebars.compile(['<p class="student-idx-number">{{index_number}}</p>', '<p class="element-data">{{value}}</p>', '<p class="student-studies">{{studies}}</p>'].join(''))
    }
  }).on('typeahead:selected typeahead:autocompleted', function(event, datum) {
    set_student_input($(event.target), datum.id);
  }).on('keyup', function(event) {
    if ($('.tt-suggestion').length === 0) {
      set_student_input($(event.target), "");
    }
  });
  $('.typeahead.input-sm').siblings('input.tt-hint').addClass('hint-small');
  $('.typeahead.input-lg').siblings('input.tt-hint').addClass('hint-large');
});
var set_student_input = function(context, value) {
  context.closest("div").find(".twitter-typeahead").next().val(value);
};