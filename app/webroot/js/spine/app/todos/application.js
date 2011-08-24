jQuery(function($){
  window.App = Spine.Controller.create({
    el: $("body"),
    
    elements: {
      "#sidebar"    : "sidebarEl",
      "#tasks"      : "tasksEl"
    },
    
    init: function(){
      this.sidebar = Sidebar.init({
        el: this.sidebarEl
      });
      this.tasks = Main.init({
        el: this.tasksEl
      });
      
      Task.trigger('refresh:list');
    }
  }).init();
});