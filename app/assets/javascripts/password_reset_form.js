$(document).ready(function() {
  $( "form.password-reset-form" ).validate({
    rules: {
      "user[password]": {
        required: true,
        minlength: 8
      },
      "user[password_confirmation]": {
        required: true,
        minlength: 8
      }
    }
  });
});