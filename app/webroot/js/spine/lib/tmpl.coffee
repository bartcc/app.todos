# jQuery.tmpl.js utilities

$ = jQuery ? require("jqueryify")

$.fn.item = ->
  item = $(@).tmplItem().data
  item.reload?()

$.fn.forItem = (item) ->
  @filter ->
    compare = $(@).item()
    item.eql?(compare) or item is compare

$.fn.serializeForm = ->
  result = {}
  $.each $(@).find('input,textarea').serializeArray(), (i, item) ->
    result[item.name] = item.value
  result