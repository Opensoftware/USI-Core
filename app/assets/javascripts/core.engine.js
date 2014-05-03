(function($){

  $.widget( "core.bindReq", {

    options: {
      request: {
        type: "POST"
      },
      dataType: "json",
      loader: "div.content",
      serialized_data: "",
      custom: {}
    },

    _create: function() {
      this.context_loader = $(this.options.loader).busyBox({
        spinner: '<img src="/assets/ajax-loader.gif" />',
        autoOpen: false
      });

    },
    perform: function() {
      var opts = this.options;
      var that = this;
      $.ajax($.extend({
        url: opts.request.url || opts.context.prop("action"),
        data: opts.serialized_data || opts.context.serialize(),
        dataType: opts.dataType,
        beforeSend: function() {
          that.context_loader.busyBox("open");
        },
        success: function(response) {
        },
        complete: function() {
          that.context_loader.busyBox("close");
        }
      }, opts.request, opts.custom));
    },

    _destroy: function() {
    }

  });

  $.widget( "core.modalDialog", {

    options: {
      width: "400px"
    },

    _create: function() {
      this.modal = $("<div id='modal-dialog-confirmation' tabindex='-1' role='dialog' data-backdrop='static' class='modal' ><div class='modal-dialog modal-dialog-centering'></div></div>");
      this.dialog = this.modal.find(".modal-dialog:last");
      this.dialog.append("<div class='modal-content'><div class='modal-header modal-header-no-border'></div><div class='modal-footer'></div></div>");

      this.dialog.css("width", this.options.width);
      this.header = this.dialog.find(".modal-header");
      this.footer = this.dialog.find(".modal-footer");

      this._header_content();
      this._footer_content();

    },

    show: function() {
      this.modal.modal("show");
    //            this.modal.modal("hide");
    //            $("#modal-dialog").modal("show");
    },
    hide: function() {},

    _footer_content: function() {},
    _header_content: function() {}


  });

  $.widget("core.yesnoDialogRemote", $.core.modalDialog, {

    options: {
      confirmation_action: function() {
        this.footer.find("button.btn-confirmation").destroyer({
          triggered_on: this.element
        });
      }
    },

    _footer_content: function() {
      this.footer.html("<a href='#' data-dismiss='modal' aria-hidden='true' class='btn secondary'>"+$.i18n._('button_no')+"</a><button type='button' class='btn btn-danger btn-confirmation'>"+$.i18n._('button_yes')+"</button>");
      this.options.confirmation_action.call(this);
    },
    _header_content: function() {
      this.header.html($("<h5 />").append(this.options.topic));
    }

  });

  $.widget("core.yesnoDialog", $.core.yesnoDialogRemote, {

    options: {
      confirmation_action: function() {
        var _t = this;
        this.footer.find("button.btn-confirmation").click(function() {
          $(_t.element).closest("form").submit();
        });

      }
    }

  });

})(jQuery);