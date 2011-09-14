class Tasks extends Spine.Controller
  
  tag: 'li'

  events:
    "change   input[type=checkbox]" :"toggle"
    "click    .destroy"             :"destroy"
    "dblclick .view"                :"edit"
    "keypress input[type=text]"     :"blurOnEnter"
    "blur     input[type=text]"     :"close"

  elements:
    "input[type=text]"              :"input"
    ".item"                         :"wrapper"
        
  constructor: ->
    super
    @item.bind("update",  @proxy(@render))
    @item.bind("destroy", @proxy(@remove))

  render: ->
    @item.reload()
    isEqual = _.isEqual(@item.savedAttributes, @item.attributes())
    element = $("#taskTemplate").tmpl(@item)
    @el.prop('id', 'todo-'+@item.id).addClass('hover')
    @el.html(element).toggleClass('unsaved', !isEqual)
    @refreshElements()
    @

  toggle: ->
    @item.done = !@item.done
    @item.save()

  destroy: ->
    @item.remove()

  edit: ->
    @wrapper.addClass("editing")
    @input.focus()

  blurOnEnter: (e) ->
    if (e.keyCode is 13) then e.target.blur()

  close: ->
    @wrapper.removeClass("editing")
    @item.updateAttributes
      name: @input.val()

  remove: ->
    @el.remove()