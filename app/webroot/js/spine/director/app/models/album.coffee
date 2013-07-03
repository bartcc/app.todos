Spine             = require("spine")
$                 = Spine.$
Model             = Spine.Model
Gallery           = require('models/gallery')
Photo             = require('models/photo')
GalleriesAlbum    = require('models/galleries_album')
AlbumsPhoto       = require('models/albums_photo')
Filter            = require("plugins/filter")
Extender          = require("plugins/model_extender")
AjaxRelations     = require("plugins/ajax_relations")
Uri               = require("plugins/uri")
require("plugins/cache")
require("spine/lib/ajax")


class Album extends Spine.Model

  @configure "Album", 'title', 'description', 'count', 'user_id', 'order', 'invalid', 'active'

  @extend Model.Cache
  @extend Model.Ajax
  @extend Uri
  @extend AjaxRelations
  @extend Filter
  @extend Extender

  @selectAttributes: ['title']
  
  @parent: 'Gallery'
  
  @previousID: false

  @url: ->
    '' + base_url + @className.toLowerCase() + 's'

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
    
  @contains: (id) ->
    AlbumsPhoto.filter(id, key: 'album_id').length
    
  @photos: (id, max = Album.count()) ->
    filterOptions =
      key:'album_id'
      joinTable: 'AlbumsPhoto'
    Photo.filterRelated(id, filterOptions)[0...max]
    
  @inactive: ->
    @findAllByAttribute('active', false)
    
  @createJoin: (items, target) ->
    console.log items
    unless @isArray items
      items = [].push(items)

    return unless items.length
#    
    for item in items
      ga = new GalleriesAlbum
        gallery_id  : target.id
        album_id    : item.id
        order       : GalleriesAlbum.albums(target.id).length
      ga.save()
#    
#  @destroyJoin: (albums, target) ->
#    return unless target
#
#    filterOptions =
#      key:'gallery_id'
#      joinTable: 'GalleriesAlbum'
#      sorted: true
#
#    unless @isArray albums
#      records = []
#      records.push(albums)
#    else records = albums
#
#    albums = @toID(records)
#
#    gas = GalleriesAlbum.filter(target.id, filterOptions)
#    for ga in gas
#      unless albums.indexOf(ga.album_id) is -1
#        Gallery.removeFromSelection ga.album_id
#        ga.destroy()
#    
  init: (instance) ->
    return unless instance?.id
    s = new Object()
    s[instance.id] = []
    @constructor.selection.push s
    
  selChange: (list) ->
  
  createJoin: (target) ->
    ga = new GalleriesAlbum
      gallery_id  : target.id
      album_id    : @id
      order       : GalleriesAlbum.albums(target.id).length
    done = ->
    ga.save(done: done)
  
  destroyJoin: (target) ->
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
      
    albums = @constructor.toID([@]) #Album.toID(records)
    gas = GalleriesAlbum.filter(target.id, filterOptions)

    for ga in gas
      unless albums.indexOf(ga.album_id) is -1
        Gallery.removeFromSelection ga.album_id
        ga.destroy()
  
  contains: -> @constructor.contains @id
  
  photos: (max) ->
    @constructor.photos @id, max || @contains()
  
  details: =>
    iCount : @constructor.contains @id
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
      
  selectAlbum: (id) ->
    return true if @id is id
    false
      
module?.exports = Model.Album = Album

