Spine ?= require("spine")
$      = Spine.$

class Spine.AlbumList extends Spine.Controller

  events:
    "click .item"      : "click"
    "dblclick .item"   : "preserveEditorOpen"
    
  selectFirst: true
    
  constructor: ->
    super
    @bind("change", @change)
    @record = Gallery.record
    
  template: -> arguments[0]
  
  change: (item, mode) =>
    console.log 'AlbumList::change'
    
    if item and !item.destroyed
      oldId = @current?.id
      newId = item.id
      changed = !(oldId is newId) or !(oldId)
      @current = item
      #@record.updateAttribute('selectedAlbumId', @current, {silent: true})
      @children().removeClass("active")
      @children().forItem(@current).addClass("active")
      
      Spine.App.trigger('change:selectedAlbum', @current, mode) if changed
  
  render: (items, selected) ->
    console.log 'AlbumList::render'
    selected = @record.selectedAlbumId unless selected
    @items = items
    @html @template @items
    @change(selected)
    @
  
  children: (sel) ->
    @el.children(sel)
    
  click: (e) ->
    console.log 'AlbumList::click'
    item = $(e.target).item()
    
    if App.hmanager.hasActive()
      @preserveEditorOpen('albums', e.target)

    @change item

  edit: (e) ->
    console.log 'AlbumList::edit'
    item = $(e.target).item()
    @change item, 'edit'

module?.exports = Spine.AlbumList