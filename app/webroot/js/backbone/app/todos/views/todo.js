jQuery(function () {

    exports.NS('Todos.Views').TodoView = (function () {

        var TodoView = Backbone.View.extend({

            //... is a list tag.
            tagName: "li",

            // Cache the template function for a single item.
            template: _.template($('#item-template').html()),

            // The DOM events specific to an item.
            events: {
                "click .check": "toggleDone",
                "dblclick .display": "edit",
                "click a.destroy": "clear",
                "blur input[type=text]": "close",
                "keypress input[type=text]": "updateOnEnter"
            },

            // The TodoView listens for changes to its model, re-rendering. Since there's
            // a one-to-one correspondence between a **Todo** and a **TodoView** in this
            // app, we set a direct reference on the model for convenience.
            initialize: function () {
                _.bindAll(this, 'render', 'close');

                this.model.bind('change', this.render);
                this.model.view = this;
            },

            // Re-render the contents of the todo item.
            render: function () {
                var isEqual = _.isEqual(this.model.savedAttributes, this.model.attributes);
                $(this.el).html(this.template(this.model.toJSON())).toggleClass('orphan', !isEqual);
                $(this.el).prop('id', 'todo-' + this.model.get('id')).addClass('hover');
                this.setContent();
                return this;
            },

            // To avoid XSS (not that it would be harmful in this particular app),
            // we use `jQuery.text` to set the contents of the todo item.
            setContent: function () {
                var patt = /(^.*\s+)((?:http|https):\/\/)?([www]?[a-z0-9\/\?=_#&%~-]+(\.[a-z0-9\/\?=_#&%~-]+)+)(.*)/,
                        test, anchorEl, content, res, href, anchorContent;

                content = this.model.get('content');
                test = patt.test(content);
                res = content.match(patt);

                if (res) {
                    href = res[2] ? res[2] + res[3] : "http://" + res[3];

                    anchorEl = $('<a></a>').attr({
                        'href': href,
                        'target': '_blank'
                    }).addClass('editor');
                    
                    content = anchorEl.html(res[3]);
                    anchorContent = res[1] + res[3] + res[5];

                    this.$('.todo-content').append(res[1]).append(content).append(res[5]);

                } else {

                    this.$('.todo-content').text(content);

                }

                this.$('.todo-input').val(anchorContent || content);
            },

            // Toggle the `"done"` state of the model.
            toggleDone: function () {
                this.model.toggle();
            },

            // Switch this view into `"editing"` mode, displaying the input field.
            edit: function () {
                this.$('.item').addClass("editing");
                this.$('input[type=text]').focus();
            },

            // Close the `"editing"` mode, saving changes to the todo.
            close: function () {
                this.model.save({
                    content: this.$('input[type=text]').val()
                });
                this.$('.item').removeClass("editing");
            },

            // If you hit `enter`, we're through editing the item.
            updateOnEnter: function (e) {
                if (e.keyCode == 13)
                    this.close();
            },

            // Remove this view from the DOM.
            remove: function () {
                $(this.el).remove();
            },

            // Remove the item, destroy the model.
            clear: function () {
                this.model.clear();
            }
        })

        return TodoView;

    })()

})