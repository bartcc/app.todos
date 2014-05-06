Spine = require("spine")
$      = Spine.$

class ModalActionView extends Spine.Controller
  
  elements:
    '.modal-header'       : 'header'
    '.modal-body'         : 'body'
    '.modal-footer'       : 'footer'
  
  events:
    'click .btnAlt'       : 'close'
    'click .btnOk'        : 'yes'
  
  template: (item) ->
    $('#modalActionTemplate').tmpl(item)
    
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
    @log 'render'
    
    @html @template @options
    @el
      
  show: (options) ->
    @options = $.extend @defaults, options
    el = @render().modal 'show'
    
  yes: (e) ->
#    @el.modal 'hide'
    
  close: (e) ->
#    @el.modal 'hide'
    
  
    
module?.exports = ModalActionView