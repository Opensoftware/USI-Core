$(document).ready(function() {
    $(window).listHistory();

    $("select, input[type='radio']", ".filter-form").loader({
        trigger_on_event: "change"
    });
    $("button[type='submit']", ".filter-form").loader();
    $("button.refresh-btn", ".filter-form").cleaner();
    $('div.content')
    .per_page_paginator({bindMethod: 'live', selector: 'div.content-footnote .per-page a'})
    .page_paginator({bindMethod: 'live', selector: 'div.content-footnote .pagination a'});
});