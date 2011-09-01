jQuery(function($){
  
  window.Contacts = Spine.Controller.create({
    elements: {
      ".show"               : "showEl",
      ".edit"               : "editEl",
      ".show .content"      : "showContent",
      ".edit .content"      : "editContent",
      '#views'              : 'views'
    },
    
    events: {
      "click .optEdit"      : "edit",
      "click .optEmail"     : "email",
      "click .showAlbum"    : "toggleAlbum",
      "click .showUpload"   : "toggleUpload",
      "click .showGrid"     : "toggleGrid",
      "click .optDestroy"   : "destroy",
      "click .optSave"      : "save",
      'keydown'             : 'saveOnEnter'
    },
    
    init: function(){
      this.editEl.hide();

      Contact.bind("change", this.proxy(this.change));
      Spine.App.bind("show:contact", this.proxy(this.show));
      Spine.App.bind("edit:contact", this.proxy(this.edit));
      this.bind('toggle:view', this.proxy(this.toggleView));
      $(this.views).queue('fx');
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
          this.$('input').first().focus().select();
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
    
    renderViewControl: function(controller, controlEl) {
      var active = controller.isActive();
      
      $('.options .view').each(function() {
        if(this == controlEl) {
          $(this).toggleClass('active', active);
        } else {
          $(this).removeClass('active');
        }
      })
    },
    
    animateView: function() {
      var hasActive = (function() {
        var cont, _i, _len, _ref;
        _ref = App.manager.controllers;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cont = _ref[_i];
          if(cont.isActive())
            return true
        }
        return false;
      })
      
      $(this.views).animate({height: hasActive() ? '140px' : '0px'}, 100);
    },
    
    toggleAlbum: function(e) {
      this.trigger('toggle:view', App.album, e.target)
    },
    
    toggleUpload: function(e) {
      this.trigger('toggle:view', App.upload, e.target)
    },
    
    toggleGrid: function(e) {
      this.trigger('toggle:view', App.grid, e.target)
    },
    
    toggleView: function(controller, control) {
      var isActive;
      isActive = controller.isActive();
      
      if(isActive) {
        App.manager.trigger('change', false);
      } else {
        App.manager.trigger('change', controller);
      }
      
      
      this.renderViewControl(controller, control);
      this.animateView();
    },
    
    save: function(){
      var atts = this.editEl.serializeForm(),
          currentAtts = this.current.attributes();
      
      if(!_.isEqual(currentAtts, atts)) {
        this.current.updateAttributes(atts);
      }
      this.show();
    },
    
    saveOnEnter: function(e) {
      if(e.keyCode != 13) return;
      this.save();
    }
  });
  
})