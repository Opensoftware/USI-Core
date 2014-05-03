$(document).ready(function() {

  $("a.context-filter").click(function() {

    $(this).bindReq({
      request: {
        type: "GET"
      },
      dataType: "script",
      custom: {
        success: function(response) {
          $(".context-filter-dropdown").dropdown("toggle");
        }
      },
      context: $(this).closest("form")
    });
    $(this).bindReq("perform");
    return false;
  });

});