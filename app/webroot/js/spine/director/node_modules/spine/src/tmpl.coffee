# jQuery.tmpl.js utilities

$ = jQuery ? require("jqueryify")

$.fn.item = (keep) ->
  item = $(@).tmplItem().data
  unless keep
    return item.reload?()
  else return item

$.fn.forItem = (item, keep) ->
  @filter ->
    compare = $(@).item(keep)
    item.eql?(compare) or item is compare

$.fn.serializeForm = ->
  result = {}
  $.each $(@).find('input,textarea').serializeArray(), (i, item) ->
    result[item.name] = item.value
  result