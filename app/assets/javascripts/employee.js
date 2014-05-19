$(document).ready(function() {
  var validation_form = $( "form.employee-form" );
  var validation_handler = validation_form.validate();

  $("input.submit-form").click(function() {
    var context = $("form.employee-form");

    if(validation_handler.form()) {
      var form = $("<form method='post'/>");
      form.append($("form.employee-form").find("input[name='_method']"));
      form.prop("action", context.prop("action")+"?"+[$("form.new-thesis").serialize(), context.serialize()].join("&"));
      $("body").append(form);
      form.submit();
    }
    return false;
  });

});