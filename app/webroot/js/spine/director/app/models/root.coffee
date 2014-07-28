Spine             = require("spine")
$                 = Spine.$
Model             = Spine.Model
Filter            = require("plugins/filter")
Extender          = require("plugins/model_extender")

class Root extends Spine.Model

  @configure "Root", 'id'

  @extend Extender
  
module?.exports = Model.Root = Root

