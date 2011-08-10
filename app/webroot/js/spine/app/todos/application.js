jQuery(function($){
  window.App = Spine.Controller.create({
    el: $("body"),
    
    elements: {
      "#sidebar"    : "sidebarEl",
      "#tasks"      : "taskEl"
    },
    
    init: function(){
      this.sidebar = Sidebar.init({
        el: this.sidebarEl
      });
      this.task = Tasks.init({
        el: this.taskEl
      });
      
      Contact.fetch();
    }
  }).init();
});