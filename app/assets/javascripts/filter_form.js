$(document).ready(function() {
    $(window).listHistory();
    $(".link-export").click(function() {
        $(this).attr("href", $.clear_query_params($(this).attr("href")) + window.location.search);
    });
    $("select, input[type='radio']", ".filter-form").loader({
        trigger_on_event: "change"
    });
    $("button[type='submit']", ".filter-form").loader();
    $("button.refresh-btn", ".filter-form").cleaner();
    $('div.content').per_page_paginator({
        bindMethod: 'live',
        selector: 'div.content-footnote .per-page a'
    }).page_paginator({
        bindMethod: 'live',
        selector: 'div.content-footnote .pagination a'
    });
});