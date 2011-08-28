jQuery ->
  Contact = Spine.Model.setup "Contact", "first_name", "last_name", "email",
    "mobile", "work", "address", "notes"
  
  Contact.extend Spine.Model.Ajax
  Contact.extend Spine.Model.Filter

  Contact.extend
    selectAttributes: ["first_name", "last_name", "email",
      "mobile", "work", "address", "notes"]

    url: ->
      '' + base_url + @.className.toLowerCase() + 's'

    nameSort: (a, b) ->
      aa = (a or '').first_name.toLowerCase()
      bb = (b or '').last_name.toLowerCase()
      return if aa == bb then 0 else if aa < bb then -1 else 1

  Contact.include
    selectAttributes: ->
      result = {}
      result[attr] = @[attr] for attr in @.constructor.selectAttributes
      result

    fullName: ->
      return unless @.first_name and @.last_name
      @.first_name + ' ' + @.last_name

  window.Contact = Contact