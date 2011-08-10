(function() {
  
  var exports = this;
  var ctor = { Version: '0.0.1' };
  _.extend(ctor, Backbone.Events);
  
  exports.prototype = ctor;
  
  exports.NS = function(ns) {
    if(typeof ns !== 'string') return;
    var parent = this, packages, helper, i;

    packages = ns.match(/([\w-]+)(?=[\.,\b]*)/g); // converts to array
    helper = function(child) {
      return parent[child] = (parent[child] || Object.create(ctor));
    };

    for(i in packages) {
      parent = helper(packages[i]);
    }
    
    return parent;
  };
  
  this.exports = exports;
  
}).call(this)

