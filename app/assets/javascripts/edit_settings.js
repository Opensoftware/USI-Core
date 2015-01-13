$(document).ready(function() {
  $(".datetime").datetimepicker({
    format: 'dd.mm.yyyy hh:ii',
    autoclose: true,
    minuteStep: 15,
    language: 'pl'
  });
  $("button.revert-to-open").click(function() {
    var that = $(this);
    $(this).yesnoDialogRemote({
      topic: $.i18n._('confirmation_theses_revert_to_open'),
      confirmation_action: function() {
        this.footer.find("button.btn-confirmation").click(function() {
          that.closest("form").prop("action", that.data("url")).submit();
        });
      }
    });
    $(this).yesnoDialogRemote("show");
    return false;
  });
});