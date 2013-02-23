Spine      = require('spine')
Model      = Spine.Model
$          = Spine.$
SpineError = require('models/spine_error')
User       = require('models/user')

class LoginView extends Spine.Controller

  elements:
    'button'              : 'logoutEl'

  events:
    'click button'        : 'logout'
    
  constructor: ->
    super
    
  template: (item) ->
    $('#loginTemplate').tmpl item
    
  logout: ->
    User.redirect 'logout'
    
  render: (item) ->
    @html @template item

module?.exports = LoginView