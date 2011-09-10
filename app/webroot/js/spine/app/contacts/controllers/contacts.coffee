$ = jQuery
class Contacts extends Spine.Controller

  elements:
    ".show"               : "showEl"
    ".edit"               : "editEl"
    ".show .content"      : "showContent"
    ".edit .content"      : "editContent"
    "#views"              : "views"
    ".draggable"          : "draggable"
    
  events:
    "click .optEdit"      : "edit"
    "click .optEmail"     : "email"
    "click .showAlbum"    : "toggleAlbum"
    "click .showUpload"   : "toggleUpload"
    "click .showGrid"     : "toggleGrid"
    "click .optDestroy"   : "destroy"
    "click .optSave"      : "save"
    "keydown"             : "saveOnEnter"

  constructor: ->
    super
    @editEl.hide()
    Contact.bind("change", @proxy @change)
    Spine.App.bind('save', @proxy @save)
    Spine.App.bind("change", @proxy @change)
    @bind("toggle:view", @proxy @toggleView)
    @create = @edit

    $(@views).queue("fx")
    
  change: (item, mode) ->
    if(!item.destroyed)
      @current = item
      @render()
      @[mode]?(item)

  render: ->
    @showContent.html $("#contactTemplate").tmpl @current
    @editContent.html $("#editContactTemplate").tmpl @current
    @focusFirstInput(@editEl)
    @
  
  focusFirstInput: (el) ->
    return unless el
    $('input', el).first().focus().select() if el.is(':visible')
    el

  show: (item) ->
    @showEl.show 0, @proxy ->
      @editEl.hide()

  
  edit: (item) ->
    @editEl.show 0, @proxy ->
      @showEl.hide()
      @focusFirstInput(@editEl)

  destroy: ->
    @current.destroy()

  email: ->
    return if ( !@current.email ) 
    window.location = "mailto:" + @current.email

  renderViewControl: (controller, controlEl) ->
    active = controller.isActive()

    $(".options .view").each ->
      if(@ == controlEl)
        $(@).toggleClass("active", active)
      else
        $(@).removeClass("active")

  animateView: ->
    hasActive = ->
      for controller in App.hmanager.controllers
        if controller.isActive()
          return App.hmanager.enableDrag()
      App.hmanager.disableDrag()

    assert = ->
      if hasActive() then App.hmanager.currentDim+"px" else "7px"

    $(@views).animate
      height: assert()
      400

  toggleAlbum: (e) ->
    @trigger("toggle:view", App.album, e.target)

  toggleUpload: (e) ->
    @trigger("toggle:view", App.upload, e.target)

  toggleGrid: (e) ->
    @trigger("toggle:view", App.grid, e.target)

  toggleView: (controller, control) ->
    isActive = controller.isActive()

    if(isActive)
      App.hmanager.trigger("change", false)
    else
      App.hmanager.trigger("change", controller)

    @renderViewControl controller, control
    @animateView()

  save: (el) ->
    atts = el.serializeForm?()
    atts = @editEl.serializeForm() unless atts
    @current.updateChangedAttributes(atts)
    @show()

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    Spine.App.trigger('save', @editEl)