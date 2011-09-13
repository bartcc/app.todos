jQuery(function($){

    window.Sidebar = Spine.Controller.create({
        // Create initance variables:
        //  this.items //=> <ul></ul>
        //  this.input //=> <input />
        elements: {
            ".items": "items",
            "input":  "input"
        },
  
        // Attach event delegation
        events: {
            "click button": "create",
            "keyup input":  "filter",
            "click input":  "filter"
        },
  
        // Ensure these functions are called with the current
        // scope as they're used in event callbacks
        proxied: ["render"],
  
        // Render template
        template: function(items){
            return($("#imagesTemplate").tmpl(items));
        },
  
        init: function(){
            this.list = Spine.List.init({
                el: this.items,
                template: this.template
            });
    
            this.list.bind("change", this.proxy(function(item){
                this.App.trigger("show:images", item);
            }));
            this.App.bind("show:images edit:images", this.list.change);
    
            // Re-render whenever imagess are populated or changed
            Image.bind("refresh change", this.render);
        },

        filter: function(){
            this.query = this.input.val();
            this.render();
        },
  
        render: function(){
            // Filter items by query
            var items = Image.filter(this.query);
            // Filter by first name
            items = items.sort(Image.nameSort);
            this.list.render(items);
        },
    
        // Called when 'Create' button is clicked
        create: function(e){
            e.preventDefault();
            var item = Image.create({id: Spine.guid()});
            this.App.trigger("edit:images", item);
        }
    });
  
});