Spine   = require("spine")
$       = Spine.$
Model   = Spine.Model
Filter  = require("plugins/filter")

require('spine/lib/local')

class Config extends Spine.Model

  @configure 'Config', 'id', 'key', 'value'
  
  @extend Model.Local
  @extend Filter
  
  init: (instance) ->
    
  select: (query) ->
    return true if @key is query
    false
    
module?.exports = Config