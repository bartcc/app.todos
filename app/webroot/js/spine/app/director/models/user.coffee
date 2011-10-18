class User extends Spine.Model

  @configure 'User', 'id', 'username', 'name', 'groupname', 'sessionid'
  
  @extend Spine.Model.Local
  
  init: ->

Spine.Model.User = User