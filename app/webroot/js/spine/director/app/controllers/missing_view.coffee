Spine       = require("spine")
$           = Spine.$

class MissingView extends Spine.Controller

  events:
    'click .relocate'   : 'relocate'
  
  template: (item) ->
    $("#missingViewTemplate").tmpl()
    
  constructor: ->
    super
    Spine.bind('show:missingView', @proxy @render)

  activated: ->

  render: (item) ->
    @log 'render'
    @html @template()
    
  relocate: (e) ->
    e.preventDefault()
    @navigate '/overview'
    
module?.exports = MissingView