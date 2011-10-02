
class Gallery extends Spine.Model
  @configure "Gallery", "name", 'author', "description"

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxExtender
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender

  @selectAttributes: ["name", 'author', "description"]
  
  @url: ->
    '' + base_url + 'galleries'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @joinTable: 'GalleriesAlbum'

  @foreignModel: 'Album'

  @foreignKey: 'gallery_id'

  @associationForeignKey: 'album_id'

  init: (instance) ->
    return unless instance
    empty = {}
    empty[instance.id] = []
    @constructor.selection.push(empty)
    
  updateAttributes: (atts, options={}) ->
    load(atts)
    Spine.Ajax.enabled = false if options.silent
    @save()
    Spine.Ajax.enabled = true
  
  updateAttribute: (name, value, options={}) ->
    @[name] = value
    Spine.Ajax.enabled = false if options.silent
    @save()
    Spine.Ajax.enabled = true

  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result
    

Spine.Model.Gallery = Gallery