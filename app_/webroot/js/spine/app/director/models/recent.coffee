class Recent extends Spine.Model

  @configure 'Recent', 'id'
  
  @extend Spine.Model.Local
  
  @check: (max) ->
    @fetch()
    @loadRecent(max)
    
  @logout: ->
    @destroyAll()
    @redirect 'logout'
  
  @redirect: (url) ->
    location.href = base_url + url
    
  init: (instance) ->
    return unless instance
    
  @loadRecent: (max = 100) ->
    $.ajax
      contentType: 'application/json'
      dataType: 'json'
      processData: false
      headers: {'X-Requested-With': 'XMLHttpRequest'}
      url: base_url + 'photos/recent/' + max
      type: 'GET'
      success: @proxy @success
      error: @proxy @error
  
  @success: (json) ->
    console.log 'Ajax::success'
    @trigger('success:recent', json)

  @error: (xhr) ->
    console.log 'Ajax::error'
    @logout()
    @redirect 'users/login'
      
Spine.Model.Recent = Recent