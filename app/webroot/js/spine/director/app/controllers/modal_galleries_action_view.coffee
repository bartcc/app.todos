Spine = require("spine")
$      = Spine.$

class ModalGalleriesActionView extends Spine.Controller
  
  elements:
    '.modal-header'       : 'header'
    '.modal-body'         : 'body'
    '.modal-footer'       : 'footer'
  
  events:
    'click .btnAlt'       : 'close'
    'click .btnOk'        : 'yes'
  
  template: (item) ->
    $('#modalGalleriesActionTemplate').tmpl(item)
    
  constructor: ->
    super
    @el.modal
      show: false
      
    @defaults =
      header  : 'Default Header Text'
      body    : 'Default Body Text'
      footer  : 'Default Footer Text'
      
    $('.nav-tabs').button()
    
  render: ->
    console.log 'ModalGalleriesActionView::render'
    
    @html @template @options
    @el
      
  show: (options) ->
    @options = $.extend @defaults, options
    el = @render().modal 'show'
    
  yes: (e) ->
#    @el.modal 'hide'
    
  close: (e) ->
#    @el.modal 'hide'
    
  
    
module?.exports = ModalGalleriesActionView