Spine                 = require("spine")
Spine                 = require("spine")
$                     = Spine.$
Model                 = Spine.Model
#Album           = require('models/album')
User                  = require('models/user')
Photo                 = require('models/photo')
GalleriesAlbum        = require('models/galleries_album')
AlbumsPhoto           = require('models/albums_photo')

Filter                = require("plugins/filter")
AjaxRelations         = require("plugins/ajax_relations")
Uri                   = require("plugins/uri")
Extender              = require("plugins/model_extender")
require("spine/lib/ajax")

class Gallery extends Spine.Model

  @configure 'Gallery', 'id', 'name', "description", 'user_id'

  @extend Filter
  @extend Model.Ajax
  @extend AjaxRelations
  @extend Extender
  @extend Uri

  @selectAttributes: ['name', 'author']
  
  @url: ->
    '' + base_url + 'galleries'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @foreignModels: ->
    'Album':
      className             : 'Album'
      joinTable             : 'GalleriesAlbum'
      foreignKey            : 'gallery_id'
      associationForeignKey : 'album_id'
    
  @contains: (id) ->
    GalleriesAlbum.filter(id, key: 'gallery_id').length
    
  @albums: (id) ->
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
    Album.filterRelated(id, filterOptions)

  init: (instance) ->
    return unless instance.id
    newSelection = {}
    newSelection[instance.id] = []
    @constructor.selection.push(newSelection)
    
  details: =>
    albums = Gallery.albums(@id)
    imagesCount = 0
    for album in albums
      imagesCount += album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    
    iCount: imagesCount
    aCount: albums.length
    author: User.first().name
    
  count: (inc = 0) ->
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
    Album.filterRelated(@id, filterOptions).length + inc
    
  updateAttributes: (atts, options={}) ->
    @load(atts)
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

  select: (joinTableItems) ->
#    ga = Spine.Model[options.joinTable].filter(id, options)
    for record in joinTableItems
      return true if record.gallery_id is @id
#    @id is @constructor.record.id

  searchSelect: (query) ->
    query = query.toLowerCase()
    atts = @selectAttributes.apply @
    for key, value of atts
      value = value.toLowerCase()
      unless (value?.indexOf(query) is -1)
        return true
    false
    
module?.exports = Model.Gallery = Gallery