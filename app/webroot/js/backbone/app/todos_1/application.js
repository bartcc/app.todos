jQuery(function() {
  
  App.Views.AppView = (function(NS) {
    var AppView = Backbone.View.extend({
      
      el: 'body',
      
      initialize: function() {
        NS.Main = new NS.MainView({
          el: $("#todoapp")
        });
        NS.Sidebar = new NS.SidebarView({
          el:  "#sidebar"
        });
      }
    })
    
    return new AppView;
    
  })(App.NS('Views'))
})