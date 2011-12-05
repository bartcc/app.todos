Spine ?= require("spine")
$      = Spine.$

class Preview extends Spine.Controller
  
  events:
    'dragstart'  : 'byebye'
  
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

  byebye: ->
    alert 'byebye'
  
  position: (e) =>
    preview_h=@el.innerHeight()
    preview_w=@el.innerWidth()
    w=$(window).width()
    h=$(window).height()
    t=$(window).scrollTop()
    posx=e.pageX+10
    posy=e.pageY
    maxx=posx+preview_w
    minx=posx-preview_w
    maxy=posy+preview_h
    if(maxx>=w)
      posx=e.pageX-(preview_w+10)
    if(maxy>=(h+t))
      posy=e.pageY-(preview_h)
    @el.css
      top:posy+'px'
      left:posx+'px'
      display:'block'

module?.exports = Preview