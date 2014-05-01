(function($){

    $.widget( "core.bindHistory", {

        options: {
            context: "form.filter-form",
            execute_on: "div.content"
        },

        _init: function() {
            var History = this.element[0].History;
            if ( History.enabled ) {
                this.setInitialState.call(this);
            }

            var that = this;
            $(this.element).bind("statechange", function() {
                var state = History.getState();
                that.stateChanged.call(that, state);
            });

        },

        setInitialState: function() {
        },

        stateChanged: function(state) {
        },

        beforeInitialState: function() {
        }

    });

    $.widget( "core.listHistory", $.core.bindHistory, {

        global_options: {
            dataType: "script"
        },

        default_state_options: {
            explicit_data_params: {},
            restore_state: true,
            url: ""
        },

        stateChanged: function(state) {
            var that = this;
            if(!state.data.restore_state) {
                return;
            }
            this.loader = $(state.data.loader_executes_on || this.options.execute_on).busyBox({
                spinner: '<img src="/assets/ajax-loader.gif" />',
                autoOpen: false,
                classes: this.global_options.busybox_class || "busybox"
            });
            $.ajax({
                url: state.data.url,
                dataType: state.data.dataType || that.global_options.dataType,
                data: $.param(state.data.widgets_to_refresh)+"&"+$.param(state.data.additional_data),
                type: state.data.type,
                beforeSend: function() {
                    $("div.modal").modal("hide");
                    that.loader.busyBox("open");
                },
                success: function(response) {
                    $.each(state.data.widgets_to_refresh, function(key, widget) {
                        var w = $(":input[name='"+widget.name+"']");
                        $.each(w, function() {
                            that._refresh_widget.call(that, $(this), widget);
                        });
                    });
                    that.success_callback.call(that, response);
                },
                complete: function() {
                    that.complete_callback.call(that);
                }
            });
        },

        setInitialState: function() {
            this.beforeInitialState.call(this);

            var context = $(this.options.context);
            History.replaceState($.extend(this.default_state_options, {
                widgets_to_refresh: context.find(":input:not([name='utf8']):not([name='authenticity_token']):not([type='submit'])").serializeArray()
            }), $("title").text(), window.location.href);
        },

        success_callback: function() {
        },
        complete_callback: function(){
            this.loader.busyBox("close");
        },
        _refresh_widget: function(w, widget) {
            var nodeName = w.prop("nodeName").toLowerCase();
            if(nodeName == "select") {
                var stored_idx = $("option[value='"+widget.value+"']", w).index();

                if(w.prop("selectedIndex") != stored_idx)
                    w[0].selectedIndex = stored_idx;
            } else if(nodeName == "input") {
                if(w.prop("type") == "checkbox") {
                } else if(w.prop("type") == "radio") {

                } else {
                    if(w.val() != widget.value)
                        w.val(widget.value);
                }
            }
        }
    });

})(jQuery);