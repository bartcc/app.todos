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
    console.log 'click'
    localStorage.hash = location.hash
    User.redirect 'logout'
    
  render: (item) ->
    @html @template item