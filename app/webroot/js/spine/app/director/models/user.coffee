class User extends Spine.Model

  @configure 'User', 'id', 'username', 'name', 'groupname', 'sessionid'
  
  @extend Spine.Model.Local
  
  @ping: ->
    User.fetch()
    user = User.first()
    user.confirm()
    user
    

  @shred: ->
    User.destroyAll()

  @login: ->
    window.location = base_url + 'users/login'
  
  confirm: ->
    $.ajax
      url: base_url + 'users/ping'
      data: JSON.stringify(@)
      type: 'POST'
      success: @success
      error: @error
      
  complete: (xhr) ->
    console.log 'Ajax::complete'
    json = $.parseJSON(xhr.responseText)
    
  success: (json) =>
    console.log 'Ajax::success'
    User.trigger('pinger', @, json)

  error: (xhr) =>
    console.log 'Ajax::error'
    console.log xhr
    @constructor.shred()
    @constructor.login()
      
Spine.Model.User = User