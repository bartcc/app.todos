class ToolbarView extends Spine.Controller
  
  template: (items) ->
    $('#toolsTemplate').tmpl items
  
  constructor: (instance) ->
    super
    @current = []
    
  elements:
    'li' :  'items'
    
  events:
    'click'   : 'click'
    
  click: (e) ->
    @lastcontrol = $(e.target) #.addClass('active')
    
  change: (list = []) ->
    if list.length
      tools = Toolbar.filter list
#      console.log tools
      content = new Array
      $.merge(content, itm.content) for itm in tools
#      console.log content
        
      @current = content
      @current.cb = itm if typeof itm is 'function' for itm in list
      
    @render()
    
  filterTools: (list) ->
    Toolbar.select list
    
  sort: (a, b) ->
    
    
  refresh: ->
    @change()
  
  click_: (e) ->
    @refresh()
    console.log 'click'
    e.preventDefault()
    
  lock: ->
    @locked = true
    
  unlock: ->
    @locked = false
    
  clear: ->
    @current = []
    @render()
    
  render: (list=@current) ->
    return if @locked
    @trigger 'before:refresh', @
    @html @template list
    @current?.cb?()
    @trigger 'refresh', @, @lastcontrol
