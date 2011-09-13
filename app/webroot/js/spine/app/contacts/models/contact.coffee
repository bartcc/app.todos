class Contact extends Spine.Model
  @configure "Contact", "first_name", "last_name", "email",
    "mobile", "work", "address", "notes"

  @extend Spine.Model.Ajax
  @extend Spine.Model.Filter

  @extend
    selectAttributes: ["first_name", "last_name", "email",
      "mobile", "work", "address", "notes"]

    url: ->
      '' + base_url + @className.toLowerCase() + 's'

    nameSort: (a, b) ->
      aa = (a or '').first_name?.toLowerCase()
      bb = (b or '').first_name?.toLowerCase()
      return if aa == bb then 0 else if aa < bb then -1 else 1
      
    fromJSON: (objects) ->
      @__super__.constructor.fromJSON.call @, objects.json

  @include
    selectAttributes: ->
      result = {}
      result[attr] = @[attr] for attr in @constructor.selectAttributes
      result

    fullName: ->
      return unless @first_name + @last_name
      @first_name + ' ' + @last_name
    
    #prevents an update if model hasn't changed
    updateChangedAttributes: (atts) ->
      origAtts = @attributes()
      for key, value of atts
        unless origAtts[key] is value
          invalid = yes
          @[key] = value
      
      @save() if invalid