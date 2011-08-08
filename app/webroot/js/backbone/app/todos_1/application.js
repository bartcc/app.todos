jQuery(function() {
  
  App.Views.AppView = (function(NS) {
    var AppView = Backbone.View.extend({
      
      el: 'body',
      
      initialize: function() {
        NS.Main = new App.Views.MainView({
          el: $("#todoapp")
        });
        NS.Sidebar = new App.Views.SidebarView({
          el:  "#sidebar"
        });
      }
    })
    
    return new AppView;
    
  })(App.NS('Views'))
})