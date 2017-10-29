jQuery(function () {

    exports.NS('Todos.Views').TodoView = (function () {

        var TodoView = Backbone.View.extend({

            //... is a list tag.
            tagName: "li",

            // Cache the template function for a single item.
            template: _.template($('#item-template').html()),

            // The DOM events specific to an item.
            events: {
                "click .item" : "blur",
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
                var patt = /(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?/g;
                var anchorEl, content, regex_content, res, href, anchorContent, matches = [], part, protocol = "http://", anchorText;
                
                content = this.model.get('content');
                
                res = content.match(patt);
                regex_content = content;
                
                if (res) {
                    while ((matches = patt.exec(regex_content)) !== null) {
                        
                        href = matches[1] ? matches[0] :  protocol + matches[0];
//                        href = matches[0].indexOf(protocol) !== -1 ? matches[0] :  protocol + matches[0];
                        
                        anchorEl = $('<a></a>').attr({
                            'href': href,
                            'target': '_blank',
                            'title' : 'Open ' + matches[0] + ' in new Tab'
                        })
                        
                        part=content.split(matches[0]);
                        
                        content=part.slice(1).join(matches[0]); // handle next part of content by readding matches on multiple occurences
                        
                        anchorText = (matches[2]+'.'+matches[3]) // we don't wanna see the protocol in our anchor html
                        
                        anchorContent = anchorEl.html(anchorText)
                        
                        this.$('.todo-content').append(part[0]).append(anchorContent);
                        
                    }
                    
                    this.$('.todo-content').append(content); // add rest of the content
                    
                } else {

                    this.$('.todo-content').text(content);

                }
                
                this.$('.todo-input').val(regex_content);
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
            },
            
            blur: function (e) {
                $(e.target).attr('tabindex', 0).focus();
            }
        })

        return TodoView;

    })()

})