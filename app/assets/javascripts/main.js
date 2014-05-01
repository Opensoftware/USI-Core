$(document).ready(function() {

    if (Modernizr.input.autocomplete) {
        $('input[type="password"]').attr('autocomplete', 'off');
    }

});
