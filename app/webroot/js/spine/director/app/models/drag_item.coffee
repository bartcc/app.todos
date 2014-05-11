Spine = require("spine")
$     = Spine.$
Model = Spine.Model
require('spine/lib/local');

class SpineDragItem extends Spine.Model

  @configure 'SpineDragItem', 'el', 'els', 'target', 'source', 'originModel', 'originRecord', 'selection', 'selected', 'closest'
  
  @extend Model.Local

  init: ->

module?.exports = Model.SpineDragItem = SpineDragItem