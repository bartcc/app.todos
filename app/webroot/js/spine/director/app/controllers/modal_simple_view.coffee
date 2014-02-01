Spine = require("spine")
$      = Spine.$

class ModalSimpleView extends Spine.Controller
  
  elements:
    '.modal-header'       : 'header'
    '.modal-body'         : 'body'
    '.modal-footer'       : 'footer'
  
  events:
    'click .btnClose'     : 'close'
    'keypress'            : 'keys'
    'hidden.bs.modal'     : 'hiddenmodal'
    'show.bs.modal'       : 'showmodal'
  
  template: (item) ->
    $('#modalSimpleTemplate').tmpl(item)
    
  constructor: ->
    super
      
    @el.modal
      show: false
      
    @defaults =
      header  : 'Default Header Text'
      body    : 'Default Body Text'
      footer  : 'Default Footer Text'
      
  hiddenmodal: ->
  
  showmodal: ->
      
  keys: (e) ->
    charCode = e.charCode
    keyCode = e.keyCode
    alert charCode
    
    switch charCode
      when 13
        @close()
        e.preventDefault()
      
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