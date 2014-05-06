Spine = require('spine')
$               = Spine.$
Controller      = Spine.Controller
Drag            = require("plugins/drag")
User            = require("models/user")
Album           = require('models/album')
Gallery         = require('models/gallery')
GalleriesAlbum  = require('models/galleries_album')
AlbumsPhoto     = require('models/albums_photo')
Info            = require('controllers/info')
AlbumsList      = require('controllers/albums_list')
User            = require('models/user')
Extender        = require("plugins/controller_extender")

require("plugins/tmpl")

class AlbumsAddView extends Spine.Controller

  @extend Extender

  events:
    'click .item'                            : 'click'
    'click .opt-AddExecute:not(.disabled)'   : 'add'
    'click .opt-SelectInv:not(.disabled)'       : 'selectInv'
    'click .opt-SelectAll:not(.disabled)'       : 'selectAll'
    'keyup'                                  : 'keyup'

  template: (items) ->
    $('#addTemplate').tmpl
      title: 'Add albums to your gallery'
      type: 'albums'
      disabled: true
      contains: !!items.length
      container: Gallery.record
    
  subTemplate: (items, options) ->
    $("#albumsTemplate").tmpl items, options
    
  footerTemplate: (selection) ->
    $('#footerTemplate').tmpl
      disabled: !selection.length
      contains: !!@items.length
    
  constructor: ->
    super
    @visible = false
    @modal = @el.modal
      show: @visible
      backdrop: true
    @list = new AlbumsList
      template: @subTemplate
      parent: @parent
    @modal.bind('show.bs.modal', @proxy @modalShow)
    @modal.bind('hide.bs.modal', @proxy @modalHide)
    Spine.bind('albums:add', @proxy @show)
      
  render: (items) ->
    @html @template @items = items
    @itemsEl = $('.items', @el)
    @list.el = @itemsEl
    @list.render items, 'add'
  
  renderFooter: (selection) ->
    @footer = $('.modal-footer', @el)
    @footer.html @footerTemplate selection
  
  show: ->
    list = GalleriesAlbum.albums(Gallery.record.id).toID()
    records = Album.filter list, func: 'idExcludeSelect'
    @render records
    @el.modal('show')
    
  hide: ->
    @el.modal('hide')
  
  modalShow: (e) ->
    @preservedList = Gallery.selectionList().slice(0)
    @selectionList = []
  
  modalHide: (e) ->
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    item = $(e.currentTarget).item()
    @select(item.id, @isCtrlClick(e))
    
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
    
    @selectionList = [] if exclusive
    
    for item in items
      @selectionList.addRemoveSelection(item)
      
    @renderFooter @selectionList
    @list.exposeSelection(Gallery.record, @selectionList)
    
  selectAll: (e) ->
    list = @select_()
    @select(list, true)
    e.preventDefault()
    
  selectInv: (e) ->
    list = @select_()
    @select(list)
    e.stopPropagation()
    
  select_: ->
    list = []
    root = @itemsEl
    items = $('.item', root)
    unless root and items.length
      return list
    items.each (index, el) ->
      item = $(@).item()
      list.unshift item.id
    list
      
  add: ->
    Spine.trigger('albums:copy', @selectionList, Gallery.record)
    @hide()
    
  keyup: (e) ->
    code = e.charCode or e.keyCode
    
    @log 'PhotosAddView:keyupCode: ' + code
    
    switch code
      when 65 #CTRL A
        if e.metaKey or e.ctrlKey
          @selectAll(e)
          e.stopPropagation()
          e.preventDefault()
      when 73 #CTRL I
        if e.metaKey or e.ctrlKey
          @selectInv(e)
          e.preventDefault()
          e.stopPropagation()
    
module.exports = AlbumsAddView