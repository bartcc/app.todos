Spine     = require("spine")
$         = Spine.$
Model     = Spine.Model
Gallery   = require('models/gallery')
Album     = require('models/album')
Filter    = require("plugins/filter")

class Toolbar extends Spine.Model


  @configure 'Toolbar', 'id', 'name', 'content'
  
  @extend Filter
  
  @load: ->
    @refresh(@tools(), clear:true)
  
  @tools: ->
    val for key, val of @data
    
  @dropdownGroups:
    group0:
      name: 'View'
      content:
        [
          name: 'Overview'
          klass: 'optOverview '
        ,
          name: 'Slides View'
          klass: 'optShowSlideshow '
          disabled: -> !Gallery.activePhotos().length
        ,
          devider: true
        ,
          name: 'Invert Selection     Cmd + A'
          klass: 'optSelectAll'
        ,
          devider: true
        ,
          name: 'Toggle Fullscreen'
          klass: 'optFullScreen'
          icon: 'fullscreen'
          iconcolor: 'black'
        ,
          name: 'Toggle Sidebar       Tab'
          klass: 'optSidebar'
        ,
          devider: true
        ,
          name: -> 'Albummasters'
          klass: 'optShowAlbumMasters'
          disabled: -> false
        ,
          name: -> 'Photomasters'
          klass: 'optShowPhotoMasters'
          disabled: -> false
        ,
          devider: true
        ,
          name: 'Modal Test'
          icon: 'th'
          iconcolor: 'black'
          klass: 'optShowModal'
        ]
    group1:
      name: 'Gallery'
      content:
        [
          name: 'New'
          icon: 'asterisk'
          klass: 'optCreateGallery'
        ,
          devider: true
        ,
          name: 'Edit'
          icon: 'pencil'
          klass: 'optGallery'
          disabled: ->
        ,
          name: 'Destroy'
          icon: 'trash'
          klass: 'optDestroyGallery'
          disabled: -> !Gallery.record
        ,
          devider: true
        ,
          name: 'Large Edit View'
          icon: 'pencil'
          klass: 'optEditGallery'
          disabled: ->
        ]
    group2:
      name: 'Album'
      content:
        [
          name: 'New'
          icon: 'asterisk'
          klass: 'optCreateAlbum'
        ,
          devider: true
        ,
          name: 'Edit'
          icon: 'pencil'
          klass: 'optAlbum'
          disabled: ->
        ,
          name: ->
            len = '('+Gallery.selectionList().length+')'
            type = if Gallery.record then 'Remove' else 'Destroy'
            return type+' '+len
          icon: 'trash'
          klass: 'optDestroyAlbum'
          disabled: -> !Gallery.selectionList().length
        ,
          devider: true
        ,
          name: -> 'Start Slideshow'
          icon: 'play'
          klass: 'optSlideshowPlay'
          dataToggle: 'modal-gallery'
          disabled: -> !Gallery.record.activePhotos?().length
        ]
    group3:
      name: 'Photo'
      content:
        [
          name: 'Upload'
          icon: 'upload'
          klass: 'optUpload'
        ,
          devider: true
        ,
          name: -> 'Copy Photos to New Album ('+Album.selectionList().length+')'
          icon: ''
          klass: 'optCreateAlbumFromSel'
          disabled: -> !Album.selectionList().length
        ,
          name: -> 'Move Photos to New Album ('+Album.selectionList().length+')'
          icon: ''
          klass: 'optCreateAlbumFromSelCut'
          disabled: -> !Album.selectionList().length
        ,
          devider: true
        ,
          name: 'Edit'
          icon: 'pencil'
          klass: 'optPhoto'
          disabled: ->
        ,
          name: ->
            len = '('+Album.selectionList().length+')'
            type = if Album.record then 'Remove' else 'Destroy'
            return type+' '+len
          icon: 'trash'
          klass: 'optDestroyPhoto '
          disabled: -> !Album.selectionList().length
        ,
          devider: true
        ,
          name: 'Auto Upload'
          icon: -> if App.showView.isQuickUpload() then 'ok' else ''
          klass: 'optQuickUpload'
          disabled: -> false
        ]
      
  @data:
    group01:
      name: 'Default'
      content:
        [
          dropdown: true
          itemGroup: @dropdownGroups.group0
        ,
          dropdown: true
          itemGroup: @dropdownGroups.group1
        ,
          dropdown: true
          itemGroup: @dropdownGroups.group2
        ,
          dropdown: true
          itemGroup: @dropdownGroups.group3
        ]
    group02:
      name: 'Gallery'
      content:
        [
          name: 'Edit'
          icon: 'pencil'
          klass: 'optEditGallery'
          disabled: -> !Gallery.record
        ,
          name: 'New'
          icon: 'asterisk'
          klass: 'optCreateGallery'
        ,
          name: 'Destroy'
          icon: 'trash'
          klass: 'optDestroyGallery'
          disabled: -> !Gallery.record
        ,
          dropdown: true
          itemGroup: @dropdownGroups.group0
        ]
    group03:
      name: 'GalleryEdit'
      content:
        [
          name: 'Save and Close'
          klass: 'optSave default'
          disabled: -> !Gallery.record
        ]
    group04:
      name: 'Album'
      content:
        [
          name: 'New'
          icon: 'asterisk'
          klass: 'optCreateAlbum'
        ,
          name: ->
            len = '('+Gallery.selectionList().length+')'
            type = if Gallery.record then 'Remove' else 'Destroy'
            return type+' '+len
          icon: 'trash'
          klass: 'optDestroyAlbum '
          disabled: -> !Gallery.selectionList().length
        ]
    group05:
      name: 'Photos'
      content:
        [
          name: ->
            len = '('+Album.selectionList().length+')'
            type = if Album.record then 'Remove' else 'Destroy'
            return type+' '+len
          klass: 'optDestroyPhoto'
          outerstyle: 'float: right;'
          disabled: -> !Album.selectionList().length
        ]
    group06:
      name: 'Photo'
      content:
        [
          name: ->
            len = '('+Album.selectionList().length+')'
            type = if Album.record then 'Remove' else 'Destroy'
            return type+' '+len
          klass: 'optDestroyPhoto '
          disabled: -> !Album.selectionList().length
        ]
    group07:
      name: 'Upload'
      content:
        [
          name: 'Show Upload'
          icon: 'upload'
          klass: ''
        ]
    group08:
      name: 'Slideshow'
      content:
        [
          name: ->
            len=Gallery.activePhotos().length
            "Slideshow: " + len + (if len>1 then " Images" else " Image") 
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          innerstyle: 'left: -8px; top: 8px; font-size: 0.9em; font-style: oblique;'
          disabled: ->
            !Gallery.activePhotos().length
        ]
    group10:
      name: 'Back'
      locked: true
      content:
        [
          name: ''
          klass: 'optPrevious'
          innerklass: 'chromeless'
          outerstyle: 'float: left;'
          innerstyle: 'left: -8px; top: 8px;'
        ]
    group11:
      name: 'Chromeless'
      locked: true
      content:
        [
          name: 'Chromeless'
          klass: -> 'optFullScreen' + if App.showView.slideshowView.fullScreenEnabled() then ' active' else ''
          icon: ''
          dataToggle: 'button'
          outerstyle: ''
        ,
          name: -> ''
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          disabled: -> !Gallery.activePhotos().length
        ]
    group12:
      name: 'Slider'
      content:
        [
          name: '<span class="slider" style=""></span>'
          klass: 'optThumbsize '
          type: 'div'
          innerstyle: 'width: 190px; position: relative;'
        ]
    group13:
      name: 'SlideshowPackage'
      content:
        [
          name: 'Chromeless'
          klass: -> 'optFullScreen' + if App.showView.slideshowView.fullScreenEnabled() then ' active' else ''
          icon: ''
          dataToggle: 'button'
          outerstyle: ''
        ,
          name: -> Gallery.activePhotos().length
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          disabled: -> !Gallery.activePhotos().length
        ,
          name: '<span class="slider" style=""></span>'
          klass: 'optThumbsize '
          type: 'div'
          innerstyle: 'width: 190px; position: relative;'
        ,
          name: ''
          klass: 'optPrevious'
          type: 'span'
          innerklass: 'icon-white icon-remove'
          outerstyle: 'float: right;'
          innerstyle: 'left: -8px; top: 8px; position:relative;'
        ]
        
  init: (ins) ->
    
  # for the filter
  select: (list) ->
    @name in list
    
module?.exports = Toolbar