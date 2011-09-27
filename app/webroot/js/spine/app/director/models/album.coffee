
class Album extends Spine.Model
  @configure "Album", "name", 'title', "description"

  @extend Spine.Model.Ajax
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender
  @extend Singleton.Extender

  @selectAttributes: ["name", 'title', "description"]
  @url: ->
    '' + base_url + @className.toLowerCase() + 's'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @joinTables: ['AlbumsImage']

  init: (instance) ->
    return unless instance
  
  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  select: (items) ->
    items.album_id is @.id

