class Gallerie extends Spine.Model
  @configure "Gallerie", "name", 'author', "description"

  @extend Spine.Model.Ajax
  @extend Spine.Model.Filter

  @selectAttributes: ["name", 'author', "description"]

  @url: ->
    '' + base_url + @className.toLowerCase() + 's'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @fromJSON: (objects) ->
    @__super__.constructor.fromJSON.call @, objects.json

  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  #prevents an update if model hasn't changed
  updateChangedAttributes: (atts) ->
    origAtts = @attributes()
    for key, value of atts
      unless origAtts[key] is value
        invalid = yes
        @[key] = value

    @save() if invalid