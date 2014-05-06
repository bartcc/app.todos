Spine = require("spine")
$      = Spine.$

class ModalSimpleView extends Spine.Controller
  
  elements:
    '.modal-header'       : 'header'
    '.modal-body'         : 'body'
    '.modal-footer'       : 'footer'
  
  events:
    'click .btnClose'     : 'close'
    'hidden.bs.modal'     : 'hiddenmodal'
    'show.bs.modal'       : 'showmodal'
  
  template: (item) ->
    $('#modalSimpleTemplate').tmpl(item)
    
  constructor: ->
    super
      
    @el.modal
      show: false
      keyboard: true
      
    @defaults =
      header  : 'Default Header Text'
      body    : 'Default Body Text'
      footer  : 'Default Footer Text'
      
  hiddenmodal: ->
  
  showmodal: ->
      
  keyup: (e) ->
    @log 'ModalSimpleView:keyup'
    
    code = e.charCode or e.keyCode
    @log code
        
    switch code
      when 32 # SPACE
        e.stopPropagation() 
      when 9 # TAB
        e.stopPropagation()
      when 27 # ESC
        e.stopPropagation()
      when 13 # RETURN
        @close()
        e.stopPropagation()
    
  render: (options) ->
    @log 'render'
    
    @html @template options
    @el
      
  show: (options) ->
    opts = $.extend @defaults, options
    @render(opts).modal 'show'
    
  close: (e) ->
    @el.modal 'hide'
    
module?.exports = ModalSimpleView