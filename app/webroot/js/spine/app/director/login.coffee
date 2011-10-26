class Login extends Spine.Controller

  elements:
    'form'              : 'form'
    '.flash'            : 'flashEl'
    '.info'             : 'infoEl'
    '#UserPassword'     : 'passwordEl'
    '#UserUsername'     : 'usernameEl'
    '#flashTemplate'    : 'flashTemplate'
    '#infoTemplate'     : 'infoTemplate'

  template: (el, item) ->
    el.tmpl(item)
    
  constructor: (form) ->
    super
    Error.fetch()
    lastError = Error.last() if Error.count()
    if lastError
      @render @flashEl, @flashTemplate, lastError 
      @render @infoEl, @infoTemplate, lastError if lastError.record
    Error.destroyAll()
    
  render: (el, tmpl, item) ->  
    el.html @template tmpl, item
    
  submit: =>
    $.ajax
      data: @form.serialize()
      type: 'POST'
      success: @success
      error: @error
      complete: @complete
      
  complete: (xhr) =>
    json = xhr.responseText
    @passwordEl.val('')
    @usernameEl.val('').focus()
    
  success: (json) =>
    User.fetch()
    User.destroyAll()
    user = new User @newAttributes(json)
    user.save()
    @render @flashEl, @flashTemplate, json
    delayedFunc = -> 
      User.redirect 'director_app'
    @delay delayedFunc, 500

  error: (xhr) =>
    json = $.parseJSON(xhr.responseText)
    @oldMessage = @flashEl.html() unless @oldMessage
    delayedFunc = -> @flashEl.html @oldMessage
    @render @flashEl, @flashTemplate, json
    @delay delayedFunc, 2000
    
  newAttributes: (json) ->
      id: json.id
      username: json.username
      name: json.name
      groupname: json.groupname
      sessionid: json.sessionid
    
$ ->
  window.Login = new Login el: $('body')