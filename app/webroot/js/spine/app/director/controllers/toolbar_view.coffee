class ToolbarView extends Spine.Controller
  
  template: -> arguments[0]
  
  constructor: (instance) ->
    super
    @current      = []
    
  change: (list) ->
    if list?.length
      tools = @filterTools list
      content = new Array
      $.merge(content, itm.content) for itm in tools
      @current = content
      @current.cb = cb if typeof cb is 'function'
    @render @current 
    @current
    
  filterTools: (list) ->
    Toolbar.filter list
    
  refresh: (list = @current) ->
    @render list
    
  lock: ->
    @locked = true
    
  unlock: ->
    @locked = false
    
  clear: ->
    @render []
    
  render: (list=@current) ->
    return if @locked
    @html @template list
    @current?.cb?()
    
  current: ->
    @current