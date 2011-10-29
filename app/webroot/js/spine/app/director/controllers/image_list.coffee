Spine ?= require("spine")
$      = Spine.$

class ImageList extends Spine.Controller
  

  events:
    'click .item'             : "click"    
    'dblclick .item'          : 'dblclick'
    'click .optCreate'        : 'create'
    
  selectFirst: true
    
  constructor: ->
    super
    @record = Gallery.record
    Spine.bind('exposeSelection', @proxy @exposeSelection)
    
  template: -> arguments[0]
  
  change: ->
    console.log 'ImageList::change'
  
  render: (items) ->
    console.log 'ImageList::render'
  
module?.exports = ImageList