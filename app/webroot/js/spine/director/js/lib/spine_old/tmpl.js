var $;
$ = typeof jQuery !== "undefined" && jQuery !== null ? jQuery : require("jqueryify");
$.fn.item = function(keep) {
  var item;
  item = $(this).tmplItem().data;
  if (!keep) {
    return typeof item.reload === "function" ? item.reload() : void 0;
  } else {
    return item;
  }
};
$.fn.forItem = function(item, keep) {
  return this.filter(function() {
    var compare;
    compare = $(this).item(keep);
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
