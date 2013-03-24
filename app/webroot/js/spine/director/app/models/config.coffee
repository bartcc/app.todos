Spine   = require("spine")
$       = Spine.$
Model   = Spine.Model
require('spine/lib/local')

class Config extends Spine.Model

  @configure 'Config', 'id', 'key', 'value'
  
  @extend Model.Local
  
  init: (instance) ->
    
module?.exports = Config