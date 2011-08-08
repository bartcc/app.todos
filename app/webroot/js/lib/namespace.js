var App = { name: 'SuperApp' };

App.NS = function(ns) {
  if(typeof ns === 'string' && ns !== '') {
    var ex = ns.match(/([\w-]+)(?=[\.,\b]*)/g), parent = this, helper;
    
    helper = function(c) { return parent[c] = (parent[c] || Object.create({})) };

    for(var i in ex) parent = helper(ex[i]);

    return parent;
  }
};