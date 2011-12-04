var $;
$ = typeof jQuery !== "undefined" && jQuery !== null ? jQuery : require("jqueryify");
$.fn.deselect = function(sel) {
  $(this).children(sel).removeClass('active');
  return $(this).children('.clone').remove();
};