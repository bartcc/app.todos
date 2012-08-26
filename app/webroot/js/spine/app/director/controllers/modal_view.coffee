Spine ?= require("spine")
$      = Spine.$

class ModalView extends Spine.Controller
  
  elements:
    '.modal-header'       : 'header'
    '.modal-body'         : 'body'
    '.modal-footer'       : 'footer'
  
  events:
    'click .btnClose'     : 'close'
  
  template: (item) ->
    $('#modalTemplate').tmpl(item)
    
  constructor: ->
    super
    # initialize Flickr's Modal
    @el.modal
      show: false
      
    @defaults =
      header  : 'Default Header Text'
      body    : 'Default Body Text'
      footer  : 'Default Footer Text'
    
  render: ->
    console.log 'ModalView::render'
    
    @html @template @options
    @el
      
  show: (options) ->
    @options = $.extend @defaults, options
    el = @render().modal 'show'
    
  close: (e) ->
    @el.modal 'hide'
    
  
    
module?.exports = ModalView