class Gallery extends Spine.Model
  @configure "Gallery", "name", 'author', "description"

  @extend Spine.Model.Ajax
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender

  @selectAttributes: ["name", 'author', "description"]

  @url: ->
    '' + base_url + 'galleries'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @joinTables: ['GalleriesAlbum']

  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  query_: =>
    console.log 'Galleries::query'
    albums = window[@constructor.joinTables].select (record) =>
      console.log @.id + ' / ' + record.gallery_id
      record.gallery_id is @.id
    console.log albums
    albums

  select_: (query) ->
    window[@constructor.joinTables].select (record) =>
      console.log @.id + ' / ' + record.gallery_id
      record.gallery_id is @.id