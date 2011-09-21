
class Album extends Spine.Model
  @configure "Album", "name", 'title', "description"

  @extend Spine.Model.Ajax
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender

  @selectAttributes: ["name", 'title', "description"]

  @url: ->
    '' + base_url + @className.toLowerCase() + 's'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @joinTables: ['AlbumsImage']

  @parentJoinTable: 'GalleriesAlbum'

  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  query_: =>
    console.log 'Album::query'
    albums = window[@constructor.joinTables].select (record) =>
      console.log @.id + ' / ' + record.gallery_id
      record.gallery_id is @.id
    console.log albums
    albums

  select: (items) ->
    #@constructor.exists(item.id) for item in items
    items.album_id is @.id