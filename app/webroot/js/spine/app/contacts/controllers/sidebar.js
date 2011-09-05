jQuery(function($){

  window.Sidebar = Spine.Controller.create({

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
  
    // Render template
    template: function(items){
      return($("#contactsTemplate").tmpl(items));
    },
    
    init: function(){
      
      Spine.App.list = this.list = Spine.List.init({
        el: this.items,
        template: this.template
      });
    
      this.list.bind("change", this.proxy(function(item){
        Spine.App.trigger("show:contact", item);
      }));
      Spine.App.bind("show:contact", this.list.proxy(this.list.change));
    
      // Re-render whenever contacts are populated or changed
      Contact.bind("refresh change", this.proxy(this.render));
    },

    filter: function(){
      this.query = this.input.val();
      this.render();
    },
  
    render: function(){
      // Filter items by query
      var items = Contact.filter(this.query);
      // Filter by first name
      items = items.sort(Contact.nameSort);
      this.list.render(items);
    },
    
    newAttributes: function() {
      return {
        first_name: '',
        last_name: ''
      }
    },
    
    // Called when 'Create' button is clicked
    create: function(e){
      e.preventDefault();
      var item = Contact.create(this.newAttributes());
      Spine.App.trigger("edit:contact", item);
    }
  });
  
});