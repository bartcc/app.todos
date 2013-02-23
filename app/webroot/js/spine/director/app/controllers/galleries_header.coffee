Spine = require("spine")
$      = Spine.$

class GalleriesHeader extends Spine.Controller
  
  constructor: ->
    super

  render: ->
    @html @template
      count: @count()
    
  count: ->
    Gallery.all().length
  
    
module?.exports = GalleriesHeader