var $;
$ = typeof jQuery !== "undefined" && jQuery !== null ? jQuery : require("jqueryify");
$.fn.deselect = function(sel) {
  return $(this).children(sel).removeClass('active');
};