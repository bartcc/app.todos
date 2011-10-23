class User extends Spine.Model

  @configure 'User', 'id', 'username', 'name', 'groupname', 'sessionid'
  
  @extend Spine.Model.Local
  
  @ping: ->
    User.fetch()
    if user = User.first()
      user.confirm()
    else
      User.redirect base_url + 'users/login'
    
  @logout: ->
    User.destroyAll()
  
  @redirect: (url) ->
    window.location = url;

  confirm: ->
    $.ajax
      url: base_url + 'users/ping'
      data: JSON.stringify(@)
      type: 'POST'
      success: @success
      error: @error
  
  success: (json) =>
    console.log 'Ajax::success'
    User.trigger('pinger', @, json)

  error: (xhr) =>
    console.log 'Ajax::error'
    console.log xhr
    @constructor.logout()
    @constructor.redirect base_url + 'users/login'
      

Spine.Model.User = User