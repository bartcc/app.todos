exports.NS('Todos.Models').User = (function() {
    
  // Todo Model
  // ----------

  // Our basic **Todo** model has `content`, `order`, and `done` attributes.
  var User = Backbone.Model.extend({
    
    defaults: {
      username: "",
      password: "",
      session: ""
    },
    
    // Ensure that each todo created has `content`.
    initialize: function() {
      _.bindAll(this);
      
      this.action = 'login';
    },
    
    url: function() {
      return base_url + 'users/' + this.action;
    },
      
    parse: function(data) {
      if(data) return data.attributes || data;
    }
  },
  {
    //
  });
  
  return User;
  
})()