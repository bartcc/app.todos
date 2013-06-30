Spine = require("spine")
$      = Spine.$

class GalleriesHeader extends Spine.Controller
  
  constructor: ->
    super
    Gallery.bind('change', @proxy @render)

  render: ->
    console.log 'GalleryHeader::render'
    @html @template
      count: @count()
    
  count: ->
    Gallery.all().length
  
    
module?.exports = GalleriesHeader