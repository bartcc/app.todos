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
    Spine.App.bind("show:contact", @proxy @show)
    Spine.App.bind("edit:contact", @proxy @editContact)
    @bind("toggle:view", @proxy @toggleView)

    $(@views).queue("fx")

  change: (item) ->
    if(!item.destroyed)
      @current = item
      @render()

  render: ->
    @showContent.html $("#contactTemplate").tmpl @current
    @editContent.html $("#editContactTemplate").tmpl @current

  show: (item) ->
    if (item) then @change item
    @showEl.show()
    @editEl.hide()

  edit: ->
    Spine.App.trigger("edit:contact")

  editContact: ->
    @editEl.show 0, @proxy ->
      @showEl.hide()
      $('input', @editEl).first().focus().select()
      

  destroy: ->
    #if (confirm("Are you sure?"))
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
          App.hmanager.enableDrag()
          return true
        else
          App.hmanager.disableDrag()
          return false
    asset = ->
      if hasActive() then App.hmanager.currentDim+"px" else "7px"

    $(@views).animate
      height: asset()
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

  save: ->
    atts = @editEl.serializeForm()
    @current.updateChangedAttributes(atts)
    @show()

  saveOnEnter: (e) ->
    return if(e.keyCode != 13)
    @save()