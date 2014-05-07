Spine       = require("spine")
$           = Spine.$

class SlideshowHeader extends Spine.Controller
  
  template: (item) ->

  constructor: ->
    super
    @bind('active', @proxy @active)

  render: ->
    
  active: ->
    @render()
    
module?.exports = SlideshowHeader