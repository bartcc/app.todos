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