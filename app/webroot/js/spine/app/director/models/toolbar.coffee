class Toolbar extends Spine.Model


  @configure 'Toolbar', 'id', 'name', 'content'
  
  @extend Spine.Model.Filter
  
  @load: ->
    @refresh(@tools(), clear:true)
  
  @tools: ->
    val for key, val of @data
    
  @dropdownGroups:
    group0:
      name: 'View'
      content:
        [
          name: 'All Albums'
          klass: 'optShowAllAlbums'
        ,
          name: 'All Photos'
          klass: 'optShowAllPhotos '
        ,
          devider: true
        ,
          name: 'Overview'
          klass: 'optOverview '
        ,
          name: 'Slides View'
          klass: 'optShowSlideshow '
          disabled: -> !App.showView.activePhotos.call @
        ,
          devider: true
        ,
          name: 'Invert Selection | Cmd + A'
          klass: 'optSelectAll'
        ,
          name: 'Toggle Fullscreen'
          klass: 'optFullScreen'
        ,
          devider: true
        ,
          name: 'Toggle Sidebar | Tab'
          klass: 'optSidebar'
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
          name: 'Edit'
          icon: 'pencil'
          klass: 'optGallery'
          disabled: -> !Gallery.record
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
          disabled: -> !Gallery.record
        ]
    group2:
      name: 'Album'
      content:
        [
          name: 'New'
          icon: 'asterisk'
          klass: 'optCreateAlbum'
        ,
          name: 'Zoom'
          icon: 'zoom-in'
          klass: 'optZoom'
          disabled: -> Gallery.selectionList().length isnt 1
        ,
          name: 'Edit'
          icon: 'pencil'
          klass: 'optAlbum'
          disabled: -> !Gallery.selectionList().length
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
          name: -> 'Start Slideshow | Space'
          icon: 'play-circle'
          klass: 'optSlideshowPlay'
          dataToggle: 'modal-gallery'
          disabled: -> !App.showView.activePhotos.call @
        ,
          name: -> 'Slideshow Autostart'
          icon: -> if App.showView.slideshowAutoStart then 'ok' else ''
          klass: 'optSlideshowAutoStart'
          disabled: -> false
        ]
    group3:
      name: 'Photo'
      content:
        [
          name: 'Upload'
          icon: 'upload'
          klass: 'optUpload'
        ,
          name: 'Edit'
          icon: 'pencil'
          klass: 'optPhoto'
          disabled: -> !Album.selectionList().length
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
          name: -> ''
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          disabled_: -> false #!App.showView.slideshowable()
          disabled: -> !App.showView.activePhotos.call @
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
          dataToggle: 'button'
          outerstyle: ''
        ,
          name: -> ''
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          disabled: -> (Gallery.selectionList().length isnt 1) or !(Album.record and Album.record.contains())
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
          dataToggle: 'button'
          outerstyle: ''
        ,
          name: -> ''
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          disabled: -> (Gallery.selectionList().length isnt 1) or !(Album.record and Album.record.contains())
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
    
Spine.Model.Toolbar = Toolbar