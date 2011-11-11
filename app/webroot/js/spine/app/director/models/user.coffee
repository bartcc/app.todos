class User extends Spine.Model

  @configure 'User', 'id', 'username', 'name', 'groupname', 'sessionid'
  
  @extend Spine.Model.Local
  
  @ping: ->
    User.fetch()
    if user = User.first()
      user.confirm()
    else
      User.redirect 'users/login'
    
  @logout: ->
    User.destroyAll()
    User.redirect 'logout'
  
  @redirect: (url) ->
    window.location.replace base_url + url

  init: (instance) ->
    return unless instance
    
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
    @constructor.logout()
    @constructor.redirect 'users/login'
      
Spine.Model.User = User