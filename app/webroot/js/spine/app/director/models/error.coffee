class Error extends Spine.Model

  @configure 'Error', 'record', 'xhr', 'statusText', 'error'
  
  @extend Spine.Model.Local
  
  init: ->

Spine.Model.Error = Error