Spine           = require("spine")
$               = Spine.$
Album           = require('models/album')
Extender        = require('plugins/controller_extender')

require("plugins/tmpl")

class PhotoList extends Spine.Controller
  
  @extend Extender
  
  constructor: ->
    super
    
  rotate: ->
    
  back: (e) ->
    @navigate '/gallery', Gallery.record.id or '', Album.record?.id or ''
    
module?.exports = PhotoList