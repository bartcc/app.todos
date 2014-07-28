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
  @extend Uri
  @extend Extender

  @selectAttributes: ['name']
  
  @parent: 'Root'
  
  @url: '' + base_url + 'galleries'

  @fromJSON: (objects) ->
    @log 'fromJSON'
    @log @className
    super
    @createJoinTables objects
    key = @className
    json = @fromArray(objects, key) if @isArray(objects)# and objects[key]#test for READ or PUT !
    json

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
      model: 'Gallery'
      key:'gallery_id'
    Album.filterRelated(id, filterOptions)

  @activePhotos: (id) ->
    albums = @selectionList(id)
    phos = []
    for alb in albums
      if album = Album.find(alb)
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
    
  
  init: (instance) ->
    return unless id = instance.id
    s = new Object()
    s[id] = []
    @constructor.selection.push s
    
  activePhotos: ->
    @constructor.activePhotos(@id)
    
  details: =>
    albums = Gallery.albums(@id)
    imagesCount = 0
    for album in albums
      imagesCount += album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    $().extend @defaultDetails,
      name: @name
      iCount: imagesCount
      aCount: albums.length
      pCount: @activePhotos().length
      sCount: Gallery.selectionList().length
      author: User.first().name
    
  count_: (inc = 0) ->
    filterOptions =
      model: 'Gallery'
      key:'gallery_id'
    Album.filterRelated(@id, filterOptions).length + inc
    
  count: (inc = 0) ->
    @constructor.contains(@id).length + inc
    
  albums: ->
    @constructor.albums @id
    
  updateAttributes: (atts, options={}) ->
    @load(atts)
    @save()
  
  updateAttribute: (name, value, options={}) ->
    @[name] = value
    @save()

  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  select: (joinTableItems) ->
    for record in joinTableItems
      return true if record.gallery_id is @id
    
  select_: (joinTableItems) ->
    return true if @id in joinTableItems
    
module?.exports = Model.Gallery = Gallery