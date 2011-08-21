jQuery(function() {
  
  exports.NS('Todos.Views').App = (function(NS) {
    
    var App = Backbone.View.extend({
      
      el: 'body',
      
      initialize: function() {
        this.Main = new NS.MainView({
          el: $("#main")
        });
        this.Login = new NS.LoginView({
          el:  "#login"
        });
        this.Logout = new NS.LogoutView({
          el:  "#logout"
        });
        this.Sidebar = new NS.SidebarView({
          el:  "#sidebar"
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