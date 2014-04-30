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
          klass: 'opt-Overview '
        ,
          name: 'Preview'
          klass: 'opt-SlideshowPreview '
          disabled: -> !Gallery.activePhotos().length
        ,
          devider: true
        ,
          name: 'Invert Selection'
          klass: 'opt-SelectInv'
          shortcut: 'ctrl+I'
        ,
          name: 'Select All'
          klass: 'opt-SelectAll'
          shortcut: 'ctrl+A'
        ,
          devider: true
        ,
          name: 'Toggle Fullscreen'
          klass: 'opt-FullScreen'
          icon: 'fullscreen'
          iconcolor: 'black'
        ,
          name: 'Toggle Sidebar'
          klass: 'opt-Sidebar'
          shortcut: '->|'
        ]
    group1:
      name: 'Gallery'
      content:
        [
          name: 'New'
          icon: 'asterisk'
          klass: 'opt-CreateGallery'
        ,
          devider: true
        ,
          name: 'Edit'
          icon: 'pencil'
          klass: 'opt-Gallery'
          disabled: ->
        ,
          name: 'Destroy'
          icon: 'trash'
          klass: 'opt-DestroyGallery'
          disabled: -> !Gallery.record
          shortcut: '<-'
        ]
    group2:
      name: 'Album'
      content:
        [
          name: 'New'
          icon: 'asterisk'
          klass: 'opt-CreateAlbum'
        ,
          name: 'Add from Masters'
          icon: 'plus'
          klass: 'opt-AddAlbums'
          disabled: -> !Gallery.record
        ,
          name: 'New Album from Selection'
          icon: 'certificate'
          klass: 'opt-CopyPhotosToAlbum'
          disabled: -> !!!Album.selectionList().length
        ,
          devider: true
        ,
          name: 'Edit'
          icon: 'pencil'
          klass: 'opt-Album'
          disabled: ->
        ,
          devider: true
        ,
          name: 'Empty Albums'
          icon: 'fire'
          klass: 'opt-EmptyAlbum'
          disabled: -> !!!Gallery.selectionList().length
        ,
          name: ->
            len = '('+Gallery.selectionList().length+')'
            type = if Gallery.record then 'Remove' else 'Destroy'
            return type+' '+len
          icon: 'trash'
          klass: 'opt-DestroyAlbum'
          disabled: -> !Gallery.selectionList().length
          shortcut: '<-'
        ,
          devider: true
        ,
          name: ->
            'Show Selection'
          icon: 'hand-right'
          klass: 'opt-ShowAlbumSelection '
          disabled: -> !Gallery.selectionList().length
        ,
          devider: true
        ,
          name: -> 'Library'
          klass: 'opt-ShowAllAlbums'
          icon: 'book'
          disabled: -> false
        ]
    group3:
      name: 'Photo'
      content:
        [
          name: 'Upload'
          icon: 'upload'
          klass: 'opt-Upload'
        ,
          name: 'Add from Masters'
          icon: 'plus'
          klass: 'opt-AddPhotos'
          disabled: -> !Album.record
        ,
          devider: true
        ,
          name: 'Edit'
          icon: 'pencil'
          klass: 'opt-Photo'
          disabled: ->
        ,
          name: ->
            if Album.record
              type = 'Remove'
            else
              type = 'Destroy'
            len = Album.selectionList().length
            return type+' ('+len+')'
          shortcut: '<-'
          icon: 'trash'
          klass: 'opt-DestroyPhoto '
          disabled: -> !!!Album.selectionList().length
        ,
          devider: true
        ,
          name: ->
            'Show Selection'
          icon: 'hand-right'
          klass: 'opt-ShowPhotoSelection '
          disabled: -> !!!Album.selectionList().length
        ,
          name: -> 'Library'
          klass: 'opt-ShowAllPhotos'
          icon: 'book'
          disabled: -> false
        ,
          devider: true
        ,
          name: 'Auto Upload'
          icon: -> if App.showView.isQuickUpload() then 'ok' else ''
          klass: 'opt-QuickUpload'
          disabled: -> false
        ]
    group4:
      name: -> 
        len = if record = Gallery.record then record.activePhotos().length else 0
        'Slideshow (' + len + ')'
      content:
        [
          name: -> 'Preview'
          klass: 'opt-SlideshowPreview'
          icon: 'picture'
          disabled: -> if record = Gallery.record then !record.activePhotos().length else true
        ,
          name: 'Start'
          klass: 'opt-SlideshowPlay'
          icon: 'play'
          dataToggle: 'modal-gallery'
          disabled: -> if record = Gallery.record then !record.activePhotos().length else true
        ]
      
  @data:
    package_00:
      name: 'Empty'
      content: []
    package_01:
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
        ,
          dropdown: true
          itemGroup: @dropdownGroups.group4
        ]
    package_02:
      name: 'Test'
      content:
        [
          name: ''
          icon: 'resize-full'
          klass: 'opt-SlideshowPhoto'
        ]
    package_09:
      name: 'Slideshow'
      content:
        [
          name: -> 'Start'
          icon: 'play'
          klass: 'opt-SlideshowPlay'
          innerklass: 'symbol'
          dataToggle: 'modal-gallery'
          disabled: -> if record = Gallery.record then !record.activePhotos().length else true
        ]
    package_10:
      name: 'Back'
      locked: true
      content:
        [
          name: ''
          klass: 'opt-Previous'
          type: 'span'
          icon: 'arrow-left'
          outerstyle: 'float: right;'
        ]
    package_11:
      name: 'Chromeless'
      locked: true
      content:
        [
          name: 'Chromeless'
          klass: -> 'opt-FullScreen' + if App.showView.slideshowView.fullScreenEnabled() then ' active' else ''
          icon: ''
          dataToggle: 'button'
          outerstyle: ''
        ,
          name: -> ''
          klass: 'opt-SlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          disabled: -> if record = Gallery.record then !record.activePhotos().length else true
        ]
    package_12:
      name: 'Slider'
      content:
        [
          name: '<span class="slider" style=""></span>'
          klass: 'opt-Thumbsize '
          type: 'div'
          innerstyle: 'width: 190px; position: relative;'
        ]
    package_13:
      name: 'SlideshowPackage'
      content:
        [
          name: '<span class="slider" style=""></span>'
          klass: 'opt-Thumbsize '
          type: 'div'
          innerstyle: 'width: 190px; position: relative;'
        ,
          name: 'Fullscreen'
          klass: -> 'opt-FullScreen' + if App.showView.slideshowView.fullScreenEnabled() then ' active' else ''
          icon: 'fullscreen'
          dataToggle: 'button'
          outerstyle: ''
        ,
          name: 'Start'
          klass: 'opt-SlideshowPlay'
          innerklass: 'symbol'
          icon: 'play'
          iconcolor: ''
          disabled: -> if record = Gallery.record then !record.activePhotos().length else true
        ]
    package_14:
      name: 'FlickrRecent'
      content:
        [
          name: ->
            details = App.flickrView.details('recent')
            'Recent Photos (' + details.from + '-' + details.to + ')'
          klass: 'opt'
          innerklass: 'symbol'
          icon: 'picture'
          type: 'span'
        ,
          name: ''
          klass: 'opt-Prev'
          icon: 'chevron-left'
          disabled: -> 
        ,
          name: ''
          klass: 'opt-Next'
          icon: 'chevron-right'
          disabled: -> 
        ]
    package_15:
      name: 'FlickrInter'
      content:
        [
          name: ->
            details = App.flickrView.details('inter')
            'Interesting Stuff (' + details.from + '-' + details.to + ')'
          icon: 'picture'
          klass: 'opt'
          type: 'span'
        ,
          name: ''
          klass: 'opt-Prev'
          icon: 'chevron-left'
          disabled: -> 
        ,
          name: ''
          klass: 'opt-Next'
          icon: 'chevron-right'
          disabled: -> 
        ]
    package_16:
      name: 'Close'
      content:
        [
          icon: 'arrow-left'
          klass: 'opt opt-Previous'
          type: 'span'
        ]
        
  init: (ins) ->
    
  # for the filter
  select: (list) ->
    @name in list
    
module?.exports = Toolbar