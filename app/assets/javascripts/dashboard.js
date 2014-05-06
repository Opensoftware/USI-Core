//= require diamond/thesis_menu

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

  $("div.content-body").on("click", "input.mark-as-read", function() {
    $(this).bindReq({
      request: {
        type: "PATCH"
      },
      dataType: "json",
      custom: {
        success: function(response) {
          if(response.success) {
            $("#msg-"+response.message_id).css({
              opacity: 0.5
            });
          }
        }
      },
      context: $(this).closest("form")
    });
    $(this).bindReq("perform");
    return false;
  });

});