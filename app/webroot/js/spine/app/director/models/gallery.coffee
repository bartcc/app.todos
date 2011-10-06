
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

  @foreignModels: ->
    'Album':
      className: 'Album'
      joinTable: 'GalleriesAlbum'
      foreignKey: 'gallery_id'
      associationForeignKey: 'album_id'
      parent: 'Gallery'

  @joinTables: ->
    fModels = @foreignModels()
    joinTables = for key, value of fModels
      fModels[key]['joinTable']
    joinTables

  init: (instance) ->
    return unless instance
    newSelection = {}
    throw 'No instance ID' unless instance.id
    newSelection[instance.id] = []
    @constructor.selection.push(newSelection)
    
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

  select: (query) ->
    @id is @constructor.record.id

  searchSelect: (query) ->
    query = query.toLowerCase()
    atts = (@selectAttributes or @attributes).apply @
    for key, value of atts
      value = value.toLowerCase()
      unless (value?.indexOf(query) is -1)
        return true
    false
    

Spine.Model.Gallery = Gallery