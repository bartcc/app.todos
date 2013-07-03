$ = jQuery ? require("jqueryify")

$.fn.deselect = (sel) ->
  $(@).children(sel).removeClass('active')
  

$.extend jQuery.tmpl.tag,
  "for": 
    _default: {$2: "var i=1;i<=1;i++"},
    open: 'for ($2){',
    close: '};'
  

############
# intelligent buttons
############
# <button class="btn" data-active="active..." data-loading="loading..." data-complete="completed...">active...</button>
# $.fn.state = function(state) {
#  var d = 'disabled'
#  return this.each(function () {
#    var $this = $(this)
#    $this.html( $this.data()[state] )
#    state == 'loading' ? $this.addClass(d).attr(d,d) : $this.removeClass(d).removeAttr(d)
#  })
#}
#$('.btn').state('loading')
############
$.fn.state = (state) ->
  d = 'disabled'
  @each ->
    $this = $(@)
    $this.html( $this.data()[state] )
    if state is 'loading'
      return $this.addClass(d).attr(d,d)
    else
      return $this.removeClass(d).removeAttr(d)
  
$.Timer_ = (interval, calls, onend) ->
  count = 0
  payload = @
  startTime = new Date()
  
  callback = ->
    payload(startTime, count)
    
  end = ->
    if (onend)
      onend(startTime, count, calls)
      
  timer = ->
    count++
    if (count < calls && callback())
      window.setTimeout(timer, interval)
    else
      end()
      
  timer()
  
  
class Timer extends Object

  constructor: (interval, calls, onend) ->
    super
    
  start: ->
    d = new Date()
    @startTime = @now()
    @
  
  now: ->
    new Date().getTime()
  
  stop: =>
    now = @now()
    started : @startTime
    ended   : now
    s       : (now - @startTime)/1000
    ms      : (now - @startTime)
    