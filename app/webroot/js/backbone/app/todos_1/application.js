jQuery(function() {
  
  exports.NS('App.Views').App = (function(NS) {
    
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
      parent: function() {
        return this;
      }
    })
    
    return new App;
    
  })(exports.NS('App.Views'))
  
})







//jQuery(function() {
//  
//  exports.NS('_').App = (function(NS) {
//    var App = Backbone.View.extend({
//      
//      el: 'body',
//      
//      initialize: function() {
//        console.log('inititalize App ')
//        this.main = new NS.MainView({
//          el: $("#main")
//        });
//        this.sidebar = new NS.SidebarView({
//          el:  "#sidebar"
//        });
//      }
//    },
//    {
//      parent: function() {
//        return this;
//      }
//    })
//    
//    return new App;
//    
//  })(exports.NS('App.Views'))
//})