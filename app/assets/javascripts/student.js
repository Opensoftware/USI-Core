$(document).ready(function() {
  var validation_form = $( "form.student-form" );
  var validation_handler = validation_form.validate();

  $("input.submit-form").click(function() {
    var context = $("form.student-form");

    if(validation_handler.form()) {
      var form = $("<form method='post'/>");
      form.append($("form.student-form").find("input[name='_method']"));
      form.prop("action", context.prop("action")+"?"+[$("form.new-thesis").serialize(), context.serialize()].join("&"));
      $("body").append(form);
      form.submit();
    }
    return false;
  });

});