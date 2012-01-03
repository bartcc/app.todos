Spine ?= require("spine")
$      = Spine.$

class Info extends Spine.Controller
  
  constructor: ->
    super
    
  render: (item) ->
    @html @template item
    @el
  
  up: (e) ->
    unless @current
      el = $(e.currentTarget)
      @current = el.item()
      @render(@current).show()
    @position(e)
    
  bye: ->
    return unless @current
    @el.hide()
    @current = null

  position: (e) =>
    info_h=@el.innerHeight()
    info_w=@el.innerWidth()
    w=$(window).width()
    h=$(window).height()
    t=$(window).scrollTop()
    posx=e.pageX+10
    posy=e.pageY
    maxx=posx+info_w
    minx=posx-info_w
    maxy=posy+info_h
    if(maxx>=w)
      posx=e.pageX-(info_w+10)
    if(maxy>=(h+t))
      posy=e.pageY-(info_h)
    @el.css
      top:posy+'px'
      left:posx+'px'
      display:'block'

module?.exports = Info