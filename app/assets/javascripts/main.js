$(document).ready(function() {

  if (Modernizr.input.autocomplete) {
    $('input[type="password"]').attr('autocomplete', 'off');
  }

  $(".has-tooltip").tooltip({
    delay: {
      show: 700,
      hide: 100
    }
  });

  $("button.submit-form, input[type='submit'].submit-form").click(function() {
    $("div.content-body form").submit();
    return false;
  });

});

$.i18n.load(eval(current_language+"_translations"));

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
    if (element.parent('.input-group').length || element.prop('type') === 'checkbox' || element.prop('type') === 'radio') {
      error.insertAfter(element.parent());
    } else {
      error.insertAfter(element);
    }
  }
});

$.widget( "core.confirmable_action", {

  options: {
    topic: '',
    success_action: function(value) {}
  },

  _create: function() {
    var _that = this;
    $(this.element).click(function() {
      $(this).yesnoDialogRemote({
        topic: $.i18n._(_that.options.topic),
        confirmation_action: function() {
          var that = this;
          this.footer.find("button.btn-confirmation").click(function() {
            var context = $("div.content");
            var form = that.element.closest("form");
            var req = that.element.bindReq({
              context: context,
              serialized_data: [form.serialize(), $("form.theses-form, form.filter-form").serialize()].join("&"),
              request: {
                type: form.find("input[name='_method']").val(),
                url: form.attr("action")
              },
              custom: {
                success: function(response) {
                  $("div.modal").modal("hide");
                  if(response.success) {

                    $.each(response.objects, function(key, value) {
                      _that.options.success_action.call(that, this, key, value);
                    });
                    $("button.button-checkbox", "div.theses-list").trigger("checkbox-uncheck");
                  }
                }
              }
            });
            req.bindReq("perform");
          });
        }
      });
      $(this).yesnoDialogRemote("show");
    });
  }

});

$.widget( "core.loader", {

  options: {
    context: "form.filter-form",
    execute_on: "div.content",
    trigger_on_event: "click",
    bindMethod: "bind",
    action_params: {}
  },

  _init: function() {


    var _options = this.options;
    var that = this;
    if(_options.bindMethod == "bind") {
      $(this.element).bind(_options.trigger_on_event, function(e) {
        that.action.call(that, e);
        return false;
      });
    } else if(_options.bindMethod == "live") {
      $(this.element).on(_options.trigger_on_event, _options.selector, function(e) {
        that.action.call(that, e);
        return false;
      });
    }

  },

  action: function(event) {
    var context = $(this.options.context);
    var url = context.attr("action");
    var widgets = context.find(":input:not([name='utf8']):not([name='authenticity_token']):not([type='submit'])");
    var data = this.additional_data.call(this, event);
    if($.isFunction(this.options.action_params.url)) {
      url = this.options.action_params.url.call(this);
      delete this.options.action_params.url;
    }
    this.before_state_changed.call(this, context, event);

    this.perform.call(this, {
      context_selector: this.options.trigger_form_class,
      loader_executes_on: this.options.execute_on,
      url: url,
      dataType: this.options.action_params.dataType,
      type: this.options.action_params.type || "GET",
      widgets_to_refresh: widgets.serializeArray(),
      restore_state: this.options.restore_state || true,
      additional_data: data
    }, $("title").text(), this.url_builder.call(this, widgets, data));
  },

  perform: function(state, title, url) {
    History.pushState(state, title, url);
  },

  url_builder: function(widgets, data) {
    console.dir(widgets.serialize());
    return window.location.pathname+"?"+[widgets.serialize()].join("&");
  },
  additional_data: function() {
    return "";
  },
  before_state_changed:function() {}
});

$.widget( "core.cleaner", $.core.loader, {

  options: {
    before_state_changed: function(ctxt) {
      ctxt.find("select").val('');
    }
  },

  url_builder: function(widgets) {
    return window.location.pathname;
  }
});

$.widget( "core.destroyer", $.core.loader, {

  options: {
    action_params: {
      type: "DELETE",
      url: function() {
        return $(this.options.triggered_on).data("href");
      }
    }
  },

  perform: function(state, title, url) {
    History.replaceState(state, title, url);
  }

});

$.widget( "core.page_paginator", $.core.loader, {

  before_state_changed: function(ctxt, e) {
    $("input[name='page']", ctxt).val($(e.currentTarget).html());
  }
});

$.widget( "core.per_page_paginator", $.core.loader, {

  before_state_changed: function(ctxt, e) {
    $("input[name='per_page']", ctxt).val($(e.currentTarget).html());
    $("input[name='page']", ctxt).val(1);
  }

});
