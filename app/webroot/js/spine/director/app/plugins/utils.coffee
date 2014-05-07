# jQuery.tmpl.js utilities

$ = jQuery ? require("jqueryify")

$.fn.deselect = (sel) ->
  $(@).children(sel).removeClass('active hot')
  
$.extend jQuery.tmpl.tag,
  "for": 
    _default: {$2: "var i=1;i<=1;i++"},
    open: 'for ($2){',
    close: '};'
  
$.fn.isFormElement = (o=[]) ->
  str = Object::toString.call(o[0])
  formElements = ['[object HTMLInputElement]','[object HTMLTextAreaElement]']
  formElements.indexOf(str) isnt -1

$.fn.state = (state) ->
  d = 'disabled'
  @each ->
    $this = $(@)
    $this.html( $this.data()[state] )
    if state is 'loading'
      return $this.addClass(d).attr(d,d)
    else
      return $this.removeClass(d).removeAttr(d)
    
$.fn.unparam = (value) ->
  # Object that holds names => values.
  params = {}
  # Get query string pieces (separated by &)
  pieces = value.split('&')

  for piece in pieces
    pair = piece.split('=', 2)
    params[decodeURIComponent(pair[0])] = if pair.length is 2 then decodeURIComponent(pair[1].replace(/\+|false/g, '')) else true
  params

