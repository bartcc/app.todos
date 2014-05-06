Spine = require("spine")
$     = Spine.$

Spine.Module.extend

  isProduction: (bool) ->
    if bool? then Spine.isProduction = bool else Spine.isProduction