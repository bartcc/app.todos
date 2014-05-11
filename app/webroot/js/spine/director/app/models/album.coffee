Spine             = require("spine")
$                 = Spine.$
Model             = Spine.Model
Model.Gallery     = require('models/gallery')
Model.Photo       = require('models/photo')
GalleriesAlbum    = require('models/galleries_album')
AlbumsPhoto       = require('models/albums_photo')
Clipboard         = require('models/clipboard')
Filter            = require("plugins/filter")
Extender          = require("plugins/model_extender")
AjaxRelations     = require("plugins/ajax_relations")
Uri               = require("plugins/uri")
Utils             = require("plugins/utils")

require("plugins/cache")
require("spine/lib/ajax")


class Album extends Spine.Model

  @configure "Album", 'id', 'title', 'description', 'count', 'user_id', 'invalid', 'active', 'selected'

  @extend Model.Cache
  @extend Model.Ajax
  @extend Uri
  @extend Utils
  @extend AjaxRelations
  @extend Filter
  @extend Extender

  @selectAttributes: ['title']
  
  @parent: 'Gallery'
  
  @previousID: false

  @url: '' + base_url + @className.toLowerCase() + 's'

  @fromJSON: (objects) ->
    super
    @createJoinTables objects
    key = @className
    json = @fromArray(objects, key) if @isArray(objects)# and objects[key]#test for READ or PUT !
    json

  @nameSort: (a, b) ->
    aa = (a or '').title?.toLowerCase()
    bb = (b or '').title?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @foreignModels: ->
    'Gallery':
      className             : 'Gallery'
      joinTable             : 'GalleriesAlbum'
      foreignKey            : 'album_id'
      associationForeignKey : 'gallery_id'
    'Photo':
      className             : 'Photo'
      joinTable             : 'AlbumsPhoto'
      foreignKey            : 'album_id'
      associationForeignKey : 'photo_id'
    
  @contains: (id=@record.id) ->
    return Photo.all() unless id
    @photos id
    
  @photos: (id, max) ->
    filterOptions =
      model: 'Album'
      key:'album_id'
      sorted: 'sortByOrder'
    ret = Photo.filterRelated(id, filterOptions)
    ret[0...max || ret.length]
    ret
    
  @inactive: ->
    @findAllByAttribute('active', false)
    
  @createJoin: (items=[], target, callback) ->
    @log 'createJoin'
    unless @isArray items
      items = [items]
    
    return unless items.length and target
    isValid = true
    cb = ->
      Gallery.trigger('change:collection', target)
      if typeof callback is 'function'
        callback.call(@)
    
    items = items.toID()
    ret = for item in items
      ga = new GalleriesAlbum
        gallery_id  : target.id
        album_id    : item
        order       : GalleriesAlbum.albums(target.id).length
      valid = ga.save
        validate: true
        ajax: false
      isValid = valid unless valid
      
    if isValid
      target.save(done: cb)
    else
      App.refreshAll()
    ret
    
  @destroyJoin: (items=[], target, cb) ->
    unless @isArray items
      items = [items]
    
    return unless items.length and target
    
    items = items.toID()
    for id in items
      gas = GalleriesAlbum.filter(id, key: 'album_id')
      ga = GalleriesAlbum.galleryAlbumExists(id, target.id)
      ga.destroy(done: cb) if ga
      
    Gallery.trigger('change:collection', target)
      
  @throwWarning: ->
  
  @gallerySelectionList: ->
    if Gallery.record and Album.record
      albumId = Gallery.selectionList()[0]
      return Album.selectionList(albumId)
    else# if Gallery.record and Gallery.selectionList().length
      return []
      
  @details: =>
    return @record.details() if @record
    $().extend @defaultDetails,
      iCount : Photo.count()
      sCount : Album.selectionList().length
      
  init: (instance) ->
    return unless id = instance.id
    s = new Object()
    s[id] = []
    @constructor.selection.push s
    
  selChange: (list) ->
  
  createJoin: (target) ->
    @constructor.createJoin [@id], target
  
  destroyJoin: (target) ->
    @constructor.destroyJoin [@id], target
        
  count: (inc = 0) =>
    @constructor.contains(@id).length + inc
  
  photos: (max) ->
    @constructor.photos @id, max
  
  details: =>
    $().extend @defaultDetails,
      iCount : @photos().length
      sCount : Album.selectionList().length
      album  : Album.record
      gallery: Gallery.record
    
  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result
  
  # loops over each record and make sure to set the copy property
  select: (joinTableItems) ->
    for record in joinTableItems
      return true if record.album_id is @id and (@['order'] = record.order)?
      
  select_: (joinTableItems) ->
    return true if @id in joinTableItems
      
  selectAlbum: (id) ->
    return true if @id is id
      
module?.exports = Model.Album = Album

