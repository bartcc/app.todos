Spine     = require("spine")
$         = Spine.$
Extender  = require('plugins/controller_extender')

class MainView extends Spine.Controller

  @extend Extender
  
  constructor: ->
    super
    @bind('active', @proxy @active)
    
  active: ->
    
 module?.exports = MainView