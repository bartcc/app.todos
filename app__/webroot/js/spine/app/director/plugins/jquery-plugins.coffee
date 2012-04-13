$ = jQuery ? require("jqueryify")

$.fn.deselect = (sel) ->
  $(@).children(sel).removeClass('active')
  
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
    