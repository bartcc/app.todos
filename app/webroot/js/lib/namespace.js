var App = {};

App.NS = function(ns) {
  if(typeof ns !== 'string') return;
  var parent = this, packages, helper, i;
      
  packages = ns.match(/([\w-]+)(?=[\.,\b]*)/g); // converts to array
  helper = function(child) {
    return parent[child] = (parent[child] || Object.create({}))
  };
      
  for(i in packages) {
    parent = helper(packages[i]);
  }

  return parent;
};