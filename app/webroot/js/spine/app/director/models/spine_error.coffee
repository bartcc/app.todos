class SpineError extends Spine.Model

  @configure 'SpineError', 'record', 'xhr', 'statusText', 'error'
  
  @extend Spine.Model.Local
  
  init: ->

Spine.Model.SpineError = SpineError