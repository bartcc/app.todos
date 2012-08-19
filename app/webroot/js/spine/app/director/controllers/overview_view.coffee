Spine ?= require("spine")
$      = Spine.$

class OverviewView extends Spine.Controller

  elements:
    ".items"              : "items"
    
  events:
    "click .optClose"     : "close"

  template: (items) ->
    $("#overviewTemplate").tmpl items

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items
    
  constructor: ->
    super
    @el.data current: Recent
    @maxRecent = 16
    @bind('render:toolbar', @proxy @renderToolbar)
    Spine.bind('show:overview', @proxy @show)
    Recent.bind('success:recent', @proxy @render)
    Recent.bind('error:recent', @proxy @error)
    
  render: (items) ->
    recents = []
    for item in items
      recents.push item['Photo']
    @items.html @template recents
    @uri recents
    
  thumbSize: (width = 70, height = 70) ->
    width: width
    height: height
    
  # mode tells Spine::uri wheter to append (=> append) or replace (=> html) the cache
  uri: (items) ->
    console.log 'OverviewView::uri'
    
    Photo.uri @thumbSize(),
      (xhr, record) => @callback(xhr, items),
      items
  
  callback: (json, items) =>
    console.log 'PhotoList::callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    for item in items
      photo = item
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
    for controller in App.contentManager.controllers
      @previous = controller if controller.isActive()
      
    App.contentManager.change @
    @loadRecent()
    
  close: ->
    App.contentManager.change App.showView
    
  error: (xhr, statusText, error) ->
    console.log xhr
    @record.trigger('ajaxError', xhr, statusText, error)

module?.exports = OverviewView