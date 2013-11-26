Spine   = require("spine")
$       = Spine.$
Model   = Spine.Model
require('spine/lib/local')

class User extends Spine.Model

  @configure 'User', 'id', 'username', 'name', 'groupname', 'sessionid', 'hash'
  
  @extend Model.Local
  
  @ping: ->
    @fetch()
    if user = @first()
      user.confirm()
    else
      @redirect 'users/login'
    
  @logout: ->
    @destroyAll()
    @redirect 'logout'
  
  @redirect: (url='', hash='') ->
    location.href = base_url + url + hash

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
    @constructor.trigger('pinger', @, $.parseJSON(json))

  error: (xhr) =>
    console.log 'Ajax::error'
    @constructor.logout()
    @constructor.redirect 'users/login'
      
module?.exports = User