Spine   = require("spine")
$       = Spine.$
Model   = Spine.Model
require('spine/lib/local')

class Clipboard extends Spine.Model

  @configure 'Clipboard', 'id', 'item', 'type', 'cut'
  
  @extend Model.Local
  
  init: (instance) ->
    return unless instance
    
module?.exports = Model.Clipboard = Clipboard