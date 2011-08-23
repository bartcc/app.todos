jQuery(function($){
  
  window.Tasks = Spine.Controller.create({
    tag: "li",
    
    proxied: ["render", "remove"],
    
    events: {
      "change   input[type=checkbox]" :"toggle",
      "click    .destroy"             :"destroy",
      "dblclick .view"                :"edit",
      "keypress input[type=text]"     :"blurOnEnter",
      "blur     input[type=text]"     :"close"
    },
    
    elements: {
      "input[type=text]"              :"input",
      ".item"                         :"wrapper"
    },
        
    init: function(){
      this.item.bind("update",  this.proxy(this.render));
      this.item.bind("destroy", this.proxy(this.remove));
    },
        
    render: function(){
      this.item.reload();
      var isEqual = _.isEqual(this.item.savedAttributes, this.item.attributes());
      var element = $("#taskTemplate").tmpl(this.item);
      this.el.prop('id', 'todo-'+this.item.id).addClass('hover');
      this.el.html(element).toggleClass('unsaved', !isEqual);
      this.refreshElements();
      return this;
    },
    
    toggle: function(){
      this.item.done = !this.item.done;
      this.item.save();
    },
        
    destroy: function(){
      this.item.remove();
    },
    
    edit: function(){
      this.wrapper.addClass("editing");
      this.input.focus();
    },
        
    blurOnEnter: function(e) {
      if (e.keyCode == 13) e.target.blur();
    },
        
    close: function(){
      this.wrapper.removeClass("editing");
      this.item.updateAttributes({
        name: this.input.val()
      });
    },
        
    remove: function(){
      this.el.remove();
    }
  });
    
  
});