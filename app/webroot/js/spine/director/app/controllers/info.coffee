Spine  = require("spine")
$      = Spine.$

class Info extends Spine.Controller
  
  constructor: ->
    super
    @el.removeClass('in')
    
  render: (item) ->
    @html @template item
    @el
  
  up: (e) ->
    clearTimeout @timer
    bye = => @bye()
    @timer = setTimeout(bye, 2000)
    unless @current
      el = $(e.currentTarget)
      @current = el.item()
      @render(@current).addClass('in')
        
    @position(e)
    
  bye: ->
    return unless @current
    @el.removeClass('in')
    @current = null
    
  position: (e) =>
    info_h=@el.innerHeight()
    info_w=@el.innerWidth()
    w=$(window).width()
    h=$(window).height()
    t=$(window).scrollTop()
    x_offset = -10
    y_offset = 20
    posx=e.pageX+x_offset
    posy=e.pageY+y_offset
    maxx=posx+info_w
    minx=posx-info_w
    maxy=posy+info_h
    if(maxx>=w)
      posx=e.pageX-(info_w)-x_offset
    if(maxy>=(h+t))
      posy=e.pageY-(info_h)-y_offset
    @el.css
      top:posy+'px'
      left:posx+'px'

module?.exports = Info