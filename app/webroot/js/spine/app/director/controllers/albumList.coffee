Spine ?= require("spine")
$      = Spine.$

class Spine.AlbumList extends Spine.Controller
  
  elements:
    '.optCreate'         : 'btnCreateAlbum'

  events:
    "click .item"             : "click"
    "dblclick .item"          : "dblclick"
    'click .optCreate'        : 'create'
    
  selectFirst: true
    
  constructor: ->
    super
    @bind("change", @change)
    @record = Gallery.record
    Spine.bind('createAlbum', @proxy @create)
    Spine.bind('destroyAlbum', @proxy @destroy)
    
  template: -> arguments[0]
  
  change: ->
    console.log 'AlbumList::change'
    
    list = Gallery.selectionList()
    console.log list
    @children().removeClass("active")
    if list
      for id in list
        item = Album.find(id) if Album.exists(id)
        @children().forItem(item).addClass("active") if item

      selected = Album.find(list[0]) if Album.exists(list[0])
      if selected and !selected.destroyed
        item = selected

    Spine.trigger('change:selectedAlbum', item)
      
      
  
  render: (items, newAlbum) ->
    console.log 'AlbumList::render'
    if items.length
      @html @template items
    else
      @html 'This Gallery has no Albums&nbsp;<button class="optCreate">New Album</button>'
      @refreshElements()

    newAlbum.addRemoveSelection(Gallery) if newAlbum
    @change()
    @
  
  children: (sel) ->
    @el.children(sel)
    
  newAttributes: ->
    title: 'New Title'
    name: 'New Album'

  create: ->
    console.log 'AlbumList::create'
    @preserveEditorOpen('album', App.albumsShowView.btnAlbum)
    album = new Album(@newAttributes())
    album.save()

  destroy: ->
    console.log 'AlbumList::destroy'
    list = Gallery.selectionList().slice()
    if Gallery.record
      for id in list
        album = Album.find(id)
        Gallery.removeFromSelection(id)
        Spine.trigger('destroy:albumJoin', album)
        #ga = GalleriesAlbum.findByAttribute('album_id', id)
        #console.log ga
        #ga.destroy()
        #console.log 'GalleriesAlbum.length after destroy:'
        console.log 'Saving Gallery'
        Gallery.record.save()
    else
      for id in list
        alb = Album.find(id) if Album.exists(id)
        Gallery.removeFromSelection(id)
        alb.destroy() if alb

  click: (e) ->
    console.log 'AlbumList::click'
    item = $(e.target).item()
    
    if App.hmanager.hasActive()
      @preserveEditorOpen('album', App.albumsShowView.btnAlbum)
    
    item.addRemoveSelection(Gallery, @isCtrlClick(e))
    @change item 

  dblclick: (e) ->
    @preserveEditorOpen('album', App.albumsShowView.btnAlbum)

  edit: (e) ->
    console.log 'AlbumList::edit'
    item = $(e.target).item()
    @change item

module?.exports = Spine.AlbumList