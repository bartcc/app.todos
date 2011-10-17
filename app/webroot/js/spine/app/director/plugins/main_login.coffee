class MainLogin extends Spine.Controller

  constructor: (form, displayField = '._flash') ->
    super
    @displayField = $('._flash')
    @passwordField = $('#UserPassword')
    
  submit: =>
    $.ajax
      data: @el.serialize()
      type: 'POST'
      success: @success
      error: @error
      complete: @complete
      
  complete: (xhr) =>
    json = xhr.responseText
    @passwordField.val('').focus()
    
  success: (json) =>
    console.log 'success'
    console.log json
    #json = $.parseJSON(xhr)
    redirect_url = base_url + 'director_app'
    @displayField.html json.flash
    delayedFunc = -> 
      window.location = redirect_url
    @delay delayedFunc, 2000
#      new Effect.Shake 'loginform'
#        duration: 0.2
#        distance: 20

  error: (xhr) =>
    json = $.parseJSON(xhr.responseText)
    oldMessage = @displayField.html()
    delayedFunc = -> @displayField.html oldMessage
    
    @displayField.html json.flash
    @delay delayedFunc, 2000
    