(function() {
  
  var exports = this;
  var v = { Version: '0.0.1' };
//  var v = function() { Version: '0.0.1' };
  
  
  var _ = Object.create(v);
  exports.prototype = _;
  
  exports.NS = function(ns) {
    if(typeof ns !== 'string') return;
    var parent = this, packages, helper, i;

    packages = ns.match(/([\w-]+)(?=[\.,\b]*)/g); // converts to array
    helper = function(child) {
      return parent[child] = (parent[child] || Object.create(_))
    };

    for(i in packages) {
      parent = helper(packages[i]);
    }
    
    return parent;
  };
  
  this.exports = exports;
  
}).call(this)

