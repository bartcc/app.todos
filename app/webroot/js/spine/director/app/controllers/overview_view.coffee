Spine   = require("spine")
$       = Spine.$
Recent  = require('models/recent')
Photo   = require('models/photo')

require("plugins/tmpl")

class OverviewView extends Spine.Controller

  elements:
    '.items'              : 'items'
    
  events:
    'click .optClose'     : 'close'
    'click .item'    : 'navi'

  template: (items) ->
    $("#overviewTemplate").tmpl items

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items
    
  constructor: ->
    super
    @el.data current: Recent
    @max = 16
    @bind('render:toolbar', @proxy @renderToolbar)
    Spine.bind('show:overview', @proxy @show)
    
  parse: (json) ->
    recents = []
    for item in json
      recents.push item['Photo']
    Recent.refresh(recents, {clear:true})
    @render Recent.all()
    
  render: (items) ->
    @items.html @template items
    @uri items
    
  thumbSize: (width = 70, height = 70) ->
    width: width
    height: height
    
  uri: (items) ->
    #test if items are known
    tests = []
    for itm in items
      tests.push itm if Photo.exists(itm.id)
      
    try
      Photo.uri @thumbSize(),
        (xhr, record) => @callback(xhr, tests),
        items
    catch e
      alert "New photos found. \n\nRestarting Application!"
      User.redirect 'director_app'
  
  callback: (json, items) =>
    console.log 'PhotoList::callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
        
    for item in items
      photo = item
      jsn = searchJSON photo.id
      ele = @items.children().forItem(photo)
      img = new Image
      img.element = ele
      if jsn
        img.src = jsn.src
      else
        img.src = '/img/nophoto.png'
      img.onload = @imageLoad
        
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
    
  loadRecent: ->
    Recent.loadRecent(@max, @proxy @parse)
    
  show: ->
    for controller in App.contentManager.controllers
      @previous = controller if controller.isActive()
      
    App.contentManager.change @
    @loadRecent()
    
  navi: (e) ->
    item = $(e.currentTarget).item()
    @navigate '/gallery', '/', item.id
    false
    
  close: -> window.history.back()
    
  error: (xhr, statusText, error) ->
    console.log xhr
    @record.trigger('ajaxError', xhr, statusText, error)

module?.exports = OverviewView