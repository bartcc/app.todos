jQuery(function() {

  exports.NS('Todos.Models').User = (function() {

    // User Model
    // ----------

    var User = Backbone.Model.extend({

      defaults: {
        id        : '',
        name      : '',
        username  : '',
        password  : '',
        sessionid : ''
      },
      
      validate: function(attrs) {
        if(!attrs.username || !attrs.password) {
          return false;
        }
      },
      
      defaultAction: 'login',
      
      initialize: function() {
        _.bindAll(this, 'action', 'url');
      },

      action: function(act) {
        var action = act || this.currAction || this.defaultAction;
        this.currAction = action;
        return action;
      },

      url: function() {
        return base_url + 'users/' + this.action();
      },

      parse: function(data) {
        if(data) return data.attributes || data;
      }
    },
    {
      //
    });

    return new User;

  })()

})