jQuery(function($){
  
  window.Contacts = Spine.Controller.create({
    elements: {
      ".show"               : "showEl",
      ".edit"               : "editEl",
      ".show .content"      : "showContent",
      ".edit .content"      : "editContent"
    },
    
    events: {
      "click .optEdit"      : "edit",
      "click .optEmail"     : "email",
      "click .optDestroy"   : "destroy",
      "click .optSave"      : "save"
    },
    
    init: function(){
      this.editEl.hide();

      Contact.bind("change", this.proxy(this.change));
      Spine.App.bind("show:contact", this.proxy(this.show));
      Spine.App.bind("edit:contact", this.proxy(this.edit));
    },
    
    change: function(item){
      if(!item.destroyed) {
        this.current = item;
        this.render();
      }
    },
    
    render: function(){
      this.showContent.html($("#contactTemplate").tmpl(this.current));
      this.editContent.html($("#editContactTemplate").tmpl(this.current));
    },
    
    show: function(item){
      if (item) this.change(item);
      this.showEl.show();
      this.editEl.hide();
    },
    
    edit: function(){
      this.editEl.show(0, $.proxy(function() {
          this.showEl.hide();
      }, this));
    },
    
    destroy: function(){
      //if (confirm("Are you sure?"))
        this.current.destroy();
    },
    
    email: function(){
      if ( !this.current.email ) return;
      window.location = "mailto:" + this.current.email;
    },
    
    save: function(){
      var atts = this.editEl.serializeForm(),
          currentAtts = this.current.attributes();
      
      if(!_.isEqual(currentAtts, atts)) {
        this.current.updateAttributes(atts);
      }
      this.show();
    }
  });
  
})