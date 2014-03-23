Spine                 = require("spine")
Spine                 = require("spine")
$                     = Spine.$
Model                 = Spine.Model
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

  @selectAttributes: ['name']
  
  @url: '' + base_url + 'galleries'

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

  @activePhotos: (id) =>
    phos = []
    albs =[]
    list = @selectionList(id)
    return phos unless list
    albs.push itm for itm in list
    for alb in albs
      if album = Album.exists(alb)
        photos = album.photos() or []
        phos.push pho for pho in photos
    phos
  
  activePhotos: ->
    @constructor.activePhotos @id
    
  init: (instance) ->
    return unless id = instance.id
    s = new Object()
    s[id] = []
    @constructor.selection.push s
    
  details: =>
    albums = Gallery.albums(@id)
    imagesCount = 0
    for album in albums
      imagesCount += album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    
    $().extend @defaultDetails,
      iCount: imagesCount
      aCount: albums.length
      sCount: @activePhotos().length
      author: User.first().name
    
  count: (inc = 0) ->
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
    Album.filterRelated(@id, filterOptions).length + inc
    
  albums: ->
    @constructor.albums @id
    
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
    for record in joinTableItems
      return true if record.gallery_id is @id
    
module?.exports = Model.Gallery = Gallery