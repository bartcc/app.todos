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
          name: 'Preview'
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
          name: ->
            len=Gallery.activePhotos().length
            'Start Slideshow (' + len + ')'
          icon: 'play'
          klass: 'optSlideshowPlay'
          dataToggle: 'modal-gallery'
          disabled: -> !Gallery.activePhotos?().length
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
          klass: 'optCreatePhotoFromSel'
          disabled: -> !Album.selectionList().length
        ,
          name: -> 'Move Photos to New Album ('+Album.selectionList().length+')'
          icon: ''
          klass: 'optCreatePhotoFromSelCut'
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
            "Preview (" + len + ')'#(if len==1 then " Image" else " Images") 
          klass: 'optOpenSlideshow'
          disabled: -> !Gallery.activePhotos().length
        ,
          name: -> ''
          icon: 'play'
          klass: 'optSlideshowPlay'
          dataToggle: 'modal-gallery'
          disabled: -> !Gallery.activePhotos().length
        ]
    group10:
      name: 'Back'
      locked: true
      content:
        [
          name: ''
          klass: 'optPrevious'
          type: 'span'
          innerklass: 'glyphicon glyphicon-white glyphicon-remove'
          outerstyle: 'float: right;'
          innerstyle: 'left: -8px; top: 8px; position:relative;'
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
          name: '<span class="slider" style=""></span>'
          klass: 'optThumbsize '
          type: 'div'
          innerstyle: 'width: 190px; position: relative;'
        ,
          name: ''
          klass: -> 'optFullScreen' + if App.showView.slideshowView.fullScreenEnabled() then ' active' else ''
          icon: 'fullscreen'
          dataToggle: 'button'
          outerstyle: ''
        ,
          name: ''
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: ''
          disabled: -> !Gallery.activePhotos().length
        ]
    group14:
      name: 'FlickrRecent'
      content:
        [
          name: ->
            details = App.flickrView.details('recent')
            console.log details
            'Recent Photos (' + details.from + '-' + details.to + ')'
          klass: 'opt'
          icon: 'picture'
          type: 'span'
        ,
          name: ''
          klass: 'optPrev'
          icon: 'chevron-left'
          disabled: -> 
        ,
          name: ''
          klass: 'optNext'
          icon: 'chevron-right'
          disabled: -> 
        ]
    group15:
      name: 'FlickrInter'
      content:
        [
          name: ->
            details = App.flickrView.details('inter')
            console.log details
            'Interesting Stuff (' + details.from + '-' + details.to + ')'
          icon: 'picture'
          klass: 'opt'
          type: 'span'
        ,
          name: ''
          klass: 'optPrev'
          icon: 'chevron-left'
          disabled: -> 
        ,
          name: ''
          klass: 'optNext'
          icon: 'chevron-right'
          disabled: -> 
        ]
        
  init: (ins) ->
    
  # for the filter
  select: (list) ->
    @name in list
    
module?.exports = Toolbar