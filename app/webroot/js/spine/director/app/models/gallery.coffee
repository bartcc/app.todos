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

  @configure 'Gallery', 'id', 'cid', 'name', "description", 'user_id'

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
    
  @contains: (id=@record.id) ->
    return Album.all() unless id
    @albums id
    
  @albums: (id) ->
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
    Album.filterRelated(id, filterOptions)

  @activePhotos: (albums=[]) =>
    phos = []
    for alb in albums
      if album = Album.exists(alb)
        photos = album.photos() or []
        phos.push pho for pho in photos
    phos
  
  @details: =>
    return @record.details() if @record
    albums = Album.all()
    imagesCount = 0
    for album in albums
      imagesCount += album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    
    $().extend @defaultDetails,
      gCount: Gallery.count()
      iCount: imagesCount
      aCount: albums.length
      sCount: Gallery.selectionList().length
      author: User.first().name
    
  
  activePhotos: () ->
    albums = @constructor.selectionList(@id)
    @constructor.activePhotos(albums)
    
  init: (instance) ->
    return unless id = instance.id
    s = new Object()
    s[id] = []
    @constructor.selection.push s
    
  details: =>
    albums = Gallery.albums(@id)
    activePhotos = @activePhotos
    imagesCount = 0
    for album in albums
      imagesCount += album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    $().extend @defaultDetails,
      iCount: imagesCount
      aCount: albums.length
      pCount: => activePhotos.call(@).length
      sCount: Gallery.selectionList().length
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