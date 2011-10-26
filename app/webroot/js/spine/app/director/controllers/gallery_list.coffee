Spine ?= require("spine")
$      = Spine.$

class GalleryList extends Spine.Controller

  @extend Spine.Controller.Drag

  events:
    "dblclick .item"                          : "edit"
    "click .item"                             : "click",
    "click      .expander"                    : "expand"
    'dragstart          .sublist-item'        : 'dragstart'
    'dragenter          .sublist-item'        : 'dragenter'
    'dragover           .sublist-item'        : 'dragover'
    'dragleave          .sublist-item'        : 'dragleave'
    'drop               .sublist-item'        : 'drop'
    'dragend            .sublist-item'        : 'dragend'

  elements:
    '.item'                   : 'item'

  selectFirst: false
    
  constructor: ->
    super

  template: -> arguments[0]

  change: (item, mode, e) =>
    console.log 'GalleryList::change'
    
    cmdKey = e.metaKey || e.ctrlKey if e
    dblclick = e.type is 'dblclick' if e

    @children().removeClass("active")
    if (!cmdKey and item)
      @current = item unless mode is 'update'
      @children().forItem(@current).addClass("active")
    else
      @current = false

    Gallery.current(@current)

    Spine.trigger('change:selectedGallery', @current, mode)
    Spine.trigger('change:toolbar', 'Gallery')
  
  render: (items, item, mode) ->
    console.log 'GalleryList::render'
    unless item
      #inject counter
      for record in items
        record.count = Album.filter(record.id).length

      @items = items
      @html @template @items
    else if mode is 'update'
      old_content = $('.item-content', '#'+item.id)
      new_content = $('.item-content', @template item).html()
      old_content.html new_content
    else if mode is 'create'
      @append @template item
    else if mode is 'destroy'
      $('#sub-'+item.id).remove()
      $('#'+item.id).remove()

    @change item, mode
    if (!@current or @current.destroyed) and !(mode is 'update')
      unless @children(".active").length
        @children(":first").click()
      

  children: (sel) ->
    @el.children(sel)

  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.target).item()
    Spine.trigger('change:selected', item.constructor.className) unless @isCtrlClick(e)
    @change item, 'show', e

  edit: (e) ->
    console.log 'GalleryList::edit'
    item = $(e.target).item()
    @change item, 'edit', e

  expand: (e) ->
    gallery = $(e.target).parents('li').item()
    icon = $('.expander', '#'+gallery.id)
    content = $('#sub-'+gallery.id)
    icon.toggleClass('expand')
    if $('#'+gallery.id+' .expand').length
      Spine.trigger('render:subList', gallery.id)
      content.show()
    else
      content.hide()

    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = GalleryList