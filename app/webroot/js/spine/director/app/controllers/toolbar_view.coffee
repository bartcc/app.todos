Spine     = require("spine")
$         = Spine.$
Model     = Spine.Model
Toolbar   = Model.Toolbar   = require('models/toolbar')
Extender  = require('plugins/controller_extender')


class ToolbarView extends Spine.Controller
  
  @extend Extender
  
  template: (items) ->
    $('#toolsTemplate').tmpl items
  
  constructor: ->
    super
    @current = []
    
  elements:
    'li' :  'items'
    
  events:
    'click'   : 'click'
    
  click: (e) ->
    @lastcontrol = $(e.target)
    
  change: (list = []) ->
    if list.length
      tools = Toolbar.filter list
      content = new Array
      $.merge(content, itm.content) for itm in tools
        
      @current = content
      
      # check for callback
      lastItem = list.last()
      @current.cb = lastItem if typeof lastItem is 'function'
      
    @render()
    
  filterTools: (list) ->
    Toolbar.select list
    
  sort: (a, b) ->
    
    
  refresh: ->
    @change()
  
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

module?.exports = ToolbarView