Spine         = require("spine")
$             = Spine.$
Model         = Spine.Model
Filter        = require("plugins/filter")
Gallery       = require('models/gallery')
Album         = require('models/album')
Clipboard     = require('models/clipboard')
AlbumsPhoto   = require('models/albums_photo')
Extender      = require("plugins/model_extender")
AjaxRelations = require("plugins/ajax_relations")
Uri           = require("plugins/uri")
Dev           = require("plugins/dev")
Cache         = require("plugins/cache")
require("spine/lib/ajax")

class Photo extends Spine.Model
  @configure "Photo", 'id', 'title', "description", 'filesize', 'captured', 'exposure', "iso", 'longitude', 'aperture', 'software', 'model', 'user_id', 'active', 'src', 'selected'

  @extend Cache
  @extend Model.Ajax
  @extend Uri
  @extend Dev
  @extend AjaxRelations
  @extend Filter
  @extend Extender

  @selectAttributes: ['title', "description", 'user_id']
  
  @parent: 'Album'
  
  @foreignModels: ->
    'Album':
      className             : 'Album'
      joinTable             : 'AlbumsPhoto'
      foreignKey            : 'photo_id'
      associationForeignKey : 'album_id'

  @url: '' + base_url + @className.toLowerCase() + 's'

  @fromJSON: (objects) ->
    @log 'fromJSON'
    @log @className
    super
    @createJoinTables objects
    key = @className
    json = @fromArray(objects, key) if @isArray(objects)# and objects[key]#test for READ or PUT !
    json

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1
  
  @defaults:
    width: 140
    height: 140
    square: 1
    quality: 70
  
  @success: (uri) =>
    @log 'success'
    Photo.trigger('uri', uri)
    
  @error: (json) =>
    Photo.trigger('ajaxError', json)
  
  @create: (atts) ->
    @__super__.constructor.create.call @, atts
  
  @refresh: (values, options = {}) ->
    @__super__.constructor.refresh.call @, values, options
    
  @trashed: ->
    res = []
    for item of @irecords
      res.push item unless AlbumsPhoto.find(item.id)
    res
    
  @inactive: ->
    @findAllByAttribute('active', false)
    
  
    
  @createJoin: (items=[], target, callback) ->
    unless @isArray items
      items = [items]

    return unless items.length
    isValid = true
    cb = ->
      Album.trigger('change:collection', target)
      if typeof callback is 'function'
        callback.call(@)
    
    items = items.toID()
    ret = for item in items
      ap = new AlbumsPhoto
        album_id    : target.id
        photo_id    : item.id or item
        order       : AlbumsPhoto.photos(target.id).length
      valid = ap.save
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
      aps = AlbumsPhoto.filter(id, key: 'photo_id')
      ap = AlbumsPhoto.albumPhotoExists(id, target.id)
      ap.destroy(done: cb) if ap
      
    Album.trigger('change:collection', target)
      
  @albums: (id) ->
    filterOptions =
      model: 'Photo'
      key:'photo_id'
      sorted: 'sortByOrder'
    Album.filterRelated(id, filterOptions)
  
  init: (instance) ->
    return unless instance?.id
    @constructor.initCache instance.id
  
  createJoin: (target) ->
    @constructor.createJoin [@id], target
  
  destroyJoin: (target) ->
    @constructor.destroyJoin [@id], target
        
  albums: ->
    @constructor.albums @id
        
  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  select: (joinTableItems) ->
    for record in joinTableItems
      return true if record.photo_id is @id and (@['order'] = record.order)?
      
  select_: (joinTableItems) ->
    return true if @id in joinTableItems
      
  selectPhoto: (id) ->
    return true if @id is id
      
  details: =>
    gallery : Model.Gallery.record
    album   : Model.Album.record
    photo   : Model.Photo.record
    author  : User.first().name

module?.exports = Model.Photo = Photo