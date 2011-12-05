# jQuery.tmpl.js utilities

$ = jQuery ? require("jqueryify")

$.fn.deselect = (sel) ->
  $(@).children(sel).removeClass('active')
  