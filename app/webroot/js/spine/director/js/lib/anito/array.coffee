Array.prototype.toID = ->
  res = []
  for item in @
    res.push item.id if typeof item.id is 'string'
  res
  
Array.prototype.last = ->
  lastIndex = @.length-1
  @[lastIndex]
  
Array.prototype.first = ->
  @[0]
  
  
Array.prototype.update = (value) ->
  throw new Error('passed value requires an array') unless Object::toString.call(value) is '[object Array]'
  @[0...@length] = value
  @

Array.prototype.addRemoveSelection = (id) ->
  @toggleSelected(id)
  @
  
Array.prototype.toggleSelected = (id) ->
  unless id in @
    @unshift id
  else
    index = @indexOf(id)
    @splice(index, 1) unless index is -1
  @
isFormElement = (value) ->
  Object::toString.call(value) is '[object Array]'