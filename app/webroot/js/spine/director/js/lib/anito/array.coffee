Array.prototype.toID = ->
  res = []
  for item in @
    res.push item.id if typeof item.id is 'string'
  res
  
Array.prototype.last = ->
  lastIndex = @.length-1
  @[lastIndex]
