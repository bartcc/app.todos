class Main extends Spine.Controller
  
  events:
    'sortupdate .items'           : 'sortupdate'
    'click footer .clear'         : 'clear'
    'keypress #create-todo input' : 'create'
    'keyup #new-todo'             : 'showTooltip'

  elements:
    "footer .clear"           : 'clear'
    '.items'                  : 'items'
    '#create-todo input'      : 'input'
    '#create-todo .countVal'  : 'count'
    '#stats'                  : 'stats'

  statsTemplate: -> $.template(null, $('#stats-template').html())

  constructor: ->
    super
    Task.bind('create',  @proxy @addOne)
    Task.bind('refresh change', @proxy @renderCount)
    Task.bind('refresh change', @proxy @renderStats)
    Task.bind('refresh change',  @proxy @updateUnsaved)
    Task.bind('refresh:list', @proxy @refreshList)
    Task.bind('refresh', @proxy @addAll)
    @items.sortable()

  refreshList: ->
    Spine.App.trigger('render:refreshState', true)
    Spine.Ajax.enabled = false
    Task.destroyAll()
    Spine.Ajax.enabled = true
    Task.fetch()

  sortupdate: (e, ui) ->
    @items.children('li').each (index) ->
      task = Task.find($(@).attr('id').replace("todo-", ""))
      unless (task ?.order) is index
        task.order = index
        task.save()

  create: (e) ->
    return unless e.keyCode is 13
    task = new Task @newAttributes()
    task.save()
    @input.val("")
    false

  newAttributes: ->
    attr = {}
    $.extend attr, Task.defaults,
      name: @input.val() || undefined
      order: Task.nextOrder()
    return attr

  addOne: (task) ->
    view = new Tasks
      item: task
    el = view.render().el
    @items.append(el)

  addAll: ->
    Task.each @proxy @addOne
    Spine.App.trigger('render:refreshState', false)

  renderCount: ->
    active = Task.active().length
    @count.text(active + ' item' + (unless active is 1 then 's' else '') + ' left')

  renderStats: ->
    active = Task.active().length
    @stats.html($.tmpl @statsTemplate(),
      done: Task.done().length
    )

  updateUnsaved: (task) ->
    return unless Spine.Ajax.enabled
    if task ?.id
      Task.saveModelState(task.id);
    else
      Task.each (model) ->
        Task.saveModelState(model.id)

  clear: ->
    Task.destroyDone()
    Task.trigger('change:unsaved')

  # Lazily show the tooltip that tells you to press `enter` to save
  # a new todo item, after one second.
  showTooltip: (e) ->
    tooltip = @$(".ui-tooltip-top");
    val = @input.val()
    tooltip.fadeOut()
    if (@tooltipTimeout) then clearTimeout(@tooltipTimeout)
    return if (val == '' or val is @input.attr('placeholder'))
    show = ->
      tooltip.show().fadeIn()
    @tooltipTimeout = setTimeout(show, 1000)