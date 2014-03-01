Spine = require("spine")
$      = Spine.$

class GalleriesHeader extends Spine.Controller
  
  constructor: ->
    super
    Gallery.bind('change', @proxy @render)

  render: ->
    return unless @isActive()
    console.log 'GalleryHeader::render'
    @html @template
      count: @count()
    
  count: ->
    Gallery.all().length
    
  activated: ->
    @render()
  
    
module?.exports = GalleriesHeader