Spine = require("spine")
$     = Spine.$
Model = Spine.Model
require('spine/lib/local');

class SpineError extends Spine.Model

  @configure 'SpineError', 'record', 'xhr', 'statusText', 'error'
  
  @extend Model.Local

  init: ->

module?.exports = SpineError