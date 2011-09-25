var $;
$ = typeof jQuery !== "undefined" && jQuery !== null ? jQuery : require("jqueryify");
$.fn.item = function() {
  var item;
  item = $(this).tmplItem().data;
  return typeof item.reload === "function" ? item.reload() : void 0;
};
$.fn.forItem = function(item) {
  return this.filter(function() {
    var compare;
    compare = $(this).item();
    return (typeof item.eql === "function" ? item.eql(compare) : void 0) || item === compare;
  });
};
$.fn.serializeForm = function() {
  var result;
  result = {};
  $.each($(this).find('input,textarea').serializeArray(), function(i, item) {
    return result[item.name] = item.value;
  });
  return result;
};