class Recent extends Spine.Model

  @configure 'Recent', 'id'
  
  @extend Spine.Model.Local
  
  @check: (max) ->
    @fetch()
    @loadRecent(max)
    
  init: (instance) ->
    return unless instance
    
  @loadRecent: (max = 9) ->
    $.ajax
      contentType: 'application/json'
      dataType: 'json'
      processData: false
      headers: {'X-Requested-With': 'XMLHttpRequest'}
      url: base_url + 'photos/recent/' + max
      data: JSON.stringify(@)
      type: 'GET'
      success: @proxy @success
      error: @error
  
  @success: (json) ->
    console.log 'Ajax::success'
    @trigger('recent', json)

  @error: (xhr) =>
    console.log 'Ajax::error'
      
Spine.Model.Recent = Recent