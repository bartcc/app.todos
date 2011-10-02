class Sidebar extends Spine.Controller
  
  events:
    'click #button-checkall button'                 :'markAllDone'
    'click #button-uncheckall button'               :'markAllUndone'
    'click #todo-controls #button-refresh button'   :'refreshList'
    'click #todo-controls #button-unsaved button'   :'saveUnsaved'

  buttonCheckallTemplate  : ->  $.template(null, $('#button-checkall-template').html())
  buttonUncheckallTemplate: ->  $.template(null, $('#button-uncheckall-template').html())
  buttonUnsavedTemplate   : ->  $.template(null, $('#button-unsaved-template').html())
  buttonRefreshTemplate   : ->  $.template(null, $('#button-refresh-template').html())

  constructor: ->
    super
    Spine.bind('render:refreshState', @proxy @renderRefreshState)
    Task.bind('refresh change', @proxy @renderControls)
    Task.bind('change:unsaved', @proxy @renderSaveState)

  refreshList: ->
    Task.trigger('refresh:list')

  saveToLocal: (xhr) ->

  markAllDone: (ev) ->
    Spine.Ajax.enabled = false
    Task.each (task) ->
      unless task.done
        task.done = true
        task.save()
        Task.trigger('change:unsaved', task)
    Spine.Ajax.enabled = true

  markAllUndone: (ev) ->
    Spine.Ajax.enabled = false
    Task.each (task) ->
      if task.done
        task.done = false
        task.save()
        Task.trigger('change:unsaved', task)
    Spine.Ajax.enabled = true

  renderControls: ->
    $('#todo-controls #button-checkall').html $.tmpl @buttonCheckallTemplate(),
      value:      'Mark all Done'
      remaining:  Task.active().length
    $('#todo-controls #button-uncheckall').html $.tmpl @buttonUncheckallTemplate(),
      value:      'Mark all Undone'
      done:       Task.done().length

  renderRefreshState: (isBusy) ->
    $('#todo-controls #button-refresh').html $.tmpl @buttonRefreshTemplate(),
      value:      'Refresh'
      busy:       isBusy

  renderSaveState: ->
    unsaved = Task.filterUnsaved()
    value = ->
      switch (unsaved.length)
        when 0 then val = 'Server is up to date'
        when 1 then val = 'Save ' + unsaved.length + ' local change'
        else val = 'Save ' + unsaved.length + ' local changes'
      val
    $('#todo-controls #button-unsaved').html $.tmpl @buttonUnsavedTemplate(),
      value:      value()
      unsaved:    unsaved.length

  saveUnsaved: ->
    UnsavedTask.save()