jQuery(function() {
  
  exports.NS('Todos.Views').App = (function(NS) {
    
    var App = Backbone.View.extend({
      
      el: 'body',
      
      initialize: function() {
        this.Main = new NS.MainView({
          el: $("#main")
        });
        this.Sidebar = new NS.SidebarView({
          el:  "#sidebar"
        });
        
      }
    },
    {
      // Class
    })
    
    return new App;
    
  })(exports.NS('Todos.Views'))
  
})