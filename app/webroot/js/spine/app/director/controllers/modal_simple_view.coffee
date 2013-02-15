Spine ?= require("spine")
$      = Spine.$

class ModalSimpleView extends Spine.Controller
  
  elements:
    '.modal-header'       : 'header'
    '.modal-body'         : 'body'
    '.modal-footer'       : 'footer'
  
  events:
    'click .btnClose'     : 'close'
  
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
      
  render: ->
    console.log 'ModalView::render'
    
    @html @template @options
    @el
      
  show: (options) ->
    @options = $.extend @defaults, options
    el = @render().modal 'show'
    
  close: (e) ->
    @el.modal 'hide'
    App.showView.showPrevious()
    
module?.exports = ModalSimpleView