Spine = require("spine")
$      = Spine.$

class ModalSimpleView extends Spine.Controller
  
  elements:
    '.modal-header'       : 'header'
    '.modal-body'         : 'body'
    '.modal-footer'       : 'footer'
  
  events:
    'click .btnClose'     : 'close'
#    'keyup'               : 'keyup'
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
    console.log 'ModalSimpleView:keyup'
    
    code = e.charCode or e.keyCode
    console.log code
        
    switch code
      when 32 # SPACE
        e.stopPropagation() 
      when 9 # TAB
        e.stopPropagation()
      when 27 # ESC
        e.stopPropagation()
      when 13 # RETURN
        alert code
        @close()
        e.stopPropagation()
    
  render: (options) ->
    console.log 'ModalView::render'
    
    @html @template options
    @el
      
  show: (options) ->
    opts = $.extend @defaults, options
    @render(opts).modal 'show'
    
  close: (e) ->
    @el.modal 'hide'
    
module?.exports = ModalSimpleView