jQuery(function() {
  
  exports.NS('Todos.Views').App = (function(NS) {
    
    var App = Backbone.View.extend({
      
      el: 'body',
      
      initialize: function() {
        var that = this;
        this.Main = new NS.MainView({
          el: $("#main"),
          App: that
        });
        this.Login = new NS.LoginView({
          el:  "#login",
          App: that
        });
        this.Logout = new NS.LogoutView({
          el:  "#logout",
          App: that
        });
        this.Sidebar = new NS.SidebarView({
          el:  "#sidebar",
          App: that
        });
        
        this.Sidebar.trigger('fetch');
      }
    },
    {
      // Class
    })
    
    return new App;
    
  })(exports.NS('Todos.Views'))
  
})