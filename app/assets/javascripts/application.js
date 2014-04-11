// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-2.1.0.js
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.js
//= require modernizr.custom.24648.js
//= require jquery.busybox.js
//= require jquery.validate.js
//= require core.engine.js
//= require main

$.validator.setDefaults({
    errorElement: "span",
    errorClass: "help-block text-right",
    highlight: function (element, errorClass, validClass) {
        $(element).closest('.form-group').addClass('has-error');
    },
    unhighlight: function (element, errorClass, validClass) {
        $(element).closest('.form-group').removeClass('has-error');
    },
    errorPlacement: function (error, element) {
        if (element.parent('.input-group').length
           || element.prop('type') === 'checkbox'
           || element.prop('type') === 'radio')
        {
           error.insertAfter(element.parent());
        } else {
           error.insertAfter(element);
        }
    }
});
