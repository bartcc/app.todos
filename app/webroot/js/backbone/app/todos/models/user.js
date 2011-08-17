jQuery(function() {

  exports.NS('Todos.Models').User = (function() {

    // Todo Model
    // ----------

    // Our basic **Todo** model has `content`, `order`, and `done` attributes.
    var User = Backbone.Model.extend({

      defaults: {
        name    : '',
        username: '',
        password: '',
        session : ''
      },
      
      defaultAction: 'login',
      
      // Ensure that each todo created has `content`.
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