class ToolbarItem extends Spine.Controller
  
  constructor: (@name, @klass) ->
    console.log @name
    console.log @klass
    return
    @html = @name.addClass @klass