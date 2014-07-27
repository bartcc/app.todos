Array.prototype.toID = ->
  res = []
  for item in @
    id = if typeof item is 'object' then item.id else if typeof item is 'string' then item
    res.push id
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
  
Array.prototype.add = (id) ->
  @toggleSelected(id, true)
  @
  
Array.prototype.toggleSelected = (id, addonly) ->
  return @ unless id
  unless id in @
    @unshift id
  else unless addonly
    index = @indexOf(id)
    @splice(index, 1) unless index is -1
  @
  
Array.prototype.contains = (string) ->
  for value in @
    Regex = new RegExp(value)
    return true if Regex.test(string)