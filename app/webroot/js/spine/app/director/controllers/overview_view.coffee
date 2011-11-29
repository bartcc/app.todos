Spine ?= require("spine")
$      = Spine.$

class OverviewView extends Spine.Controller

  @extend Spine.Controller.Toolbars
  
  elements:
    ".items"              : "items"
    '.optClose'           : 'btnClose'
    
  events:
    "click .optClose"     : "close"

  template: (items) ->
    $("#overviewTemplate").tmpl items
#    $("#photosTemplate").tmpl items

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items
    
  constructor: ->
    super
    @maxRecent = 16
    @bind('render:toolbar', @proxy @renderToolbar)
    Spine.bind('overview', @proxy @show)
    Recent.bind('recent', @proxy @render)
    
  render: (items) ->
    recents = []
    for item in items
      recents.push item['Photo']
    @items.html @template recents
    @uri items
    
  previewSize: (width = 70, height = 70) ->
    width: width
    height: height
    
  # mode tells Spine::uri wheter to append (=> append) or replace (=> html) the cache
  uri: (items, mode = 'html') ->
    console.log 'PhotoList::uri'
    Photo.uri items, @previewSize(), mode, (xhr, record) => @callback items, xhr
  
  callback: (items, json) =>
    console.log 'PhotoList::callback'
    console.log items.length
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    for item in items
      photo = item['Photo']
      jsn = searchJSON photo.id
      ele = @items.children().forItem(photo, true)
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
    Recent.check(@maxRecent)
    
  show: ->
    for cont in App.contentManager.controllers
      @savedView = cont if cont.isActive()
      
    App.contentManager.change @
    @loadRecent()
    
  close: ->
    App.contentManager.change @savedView
    
  renderToolbar: ->

module?.exports = OverviewView