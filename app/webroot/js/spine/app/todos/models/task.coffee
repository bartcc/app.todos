class Task extends Spine.Model
  @configure "Task", "name", "done", 'order'

  @extend(Spine.Model.Ajax)

  @defaults:
    name: 'Empty Todo...'
    done: false
  
  @fromJSON: (object) ->
    @__super__.constructor.fromJSON.call @, object.json
  
  # Return all active tasks.
  @active: ->
    return @select (item) ->
      !item.done
  
  # Return all done tasks.
  @done: ->
    @select (item) ->
      !!item.done
  
  @url: ->
    return '' + base_url + (@className.toLowerCase()) + 's'
  
  # Clear all done tasks.
  @destroyDone: ->
    $(@done()).each (i, rec) ->
      rec.remove()

  @nextOrder: ->
    if @last() then (parseInt(@last().order) + 1) else 0;
    
  @filterUnsaved: ->
    @select (task) ->
      isEqual = _.isEqual(task.savedAttributes, task.attributes())
      unless task.isScheduledForSave
        unless isEqual then UnsavedTask.addUnsaved(task) else UnsavedTask.removeUnsaved(task)
      !isEqual
  
  @comparator: ->
    @each (rec) ->
      rec.order
  
  @saveModelState: (id) ->
    return unless @exists(id)
    model = @find id
    saved = model.constructor.records[id].savedAttributes = model.attributes()
    Task.trigger('change:unsaved')
    saved
    
  init: ->
    
  remove: ->
    @destroy()
    Task.trigger('change:unsaved', @)

class UnsavedTask extends Spine.Model
  @configure "UnsavedTask", "name", "done", 'order'

  @addUnsaved: (saved) ->
    unless @exists saved.id
      @create saved.clone().attributes()
    
  @removeUnsaved: (saved) ->
    @destroy saved.id if @exists saved.id
      
    
  # save each todo who's id is in the list
  @save: ->
    @each (unsaved) ->
      if Task.exists unsaved.id
        saved = Task.find unsaved.id
        saved.save()
        Task.trigger('change:unsaved')