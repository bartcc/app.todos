class Toolbar extends Spine.Model

  @configure 'Toolbar', 'id', 'name', 'content'
  
  @extend Spine.Model.Filter
  
  @load: ->
    @refresh(@tools(), clear:true)
  
  @tools: ->
    list = []
    list.push val for key, val of @data
    list
    
  @dropdownGroups:
    group0:
      name: 'View'
      content:
        [
          name: 'All Albums'
          klass: 'optAllAlbums'
        ,
          name: 'All Photos'
          klass: 'optAllPhotos '
        ,
          devider: true
        ,
          name: 'Overview'
          klass: 'optOverview '
        ,
          name: 'Slides View'
          klass: 'optShowSlideshow '
          disabled: -> (Gallery.selectionList().length isnt 1) or !(Album.record and Album.record.contains())
        ,
          devider: true
        ,
          name: 'Invert Selection (Cmd + A)'
          klass: 'optSelectAll'
        ,
          name: 'Toggle Fullscreen'
          klass: 'optFullScreen'
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
          name: 'Edit (Large View)'
          icon: 'pencil'
          klass: 'optEditGallery'
          disabled: -> !Gallery.record
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
        ]
    group2:
      name: 'Album'
      content:
        [
          name: 'New'
          icon: 'asterisk'
          klass: 'optCreateAlbum'
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
          name: -> 'Start Slideshow'
          icon: 'play-circle'
          klass: 'optSlideshowPlay'
          dataToggle: 'modal-gallery'
          disabled: -> (!Gallery.selectionList().length) or !(Album.record and Album.record.contains())
        ]
    group3:
      name: 'Photo'
      content:
        [
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
          name: 'Upload'
          icon: 'upload'
          klass: 'optUpload'
        ,
          name: 'Auto Upload'
          icon: -> if App.showView.isQuickUpload() then 'ok' else ''
          klass: 'optQuickUpload'
        ]
      
  @data:
    group0:
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
    group1:
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
    group2:
      name: 'GalleryEdit'
      content:
        [
          name: 'Save and Close'
          klass: 'optSave default'
          disabled: -> !Gallery.record
        ]
    group3:
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
    group4:
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
    group5:
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
    group6:
      name: 'Upload'
      content:
        [
          name: 'Show Upload'
          icon: 'upload'
          klass: ''
        ]
    group7:
      name: 'Slideshow'
      content:
        [
          name: -> ''
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          disabled: -> (Gallery.selectionList().length isnt 1) or !(Album.record and Album.record.contains())
        ]
    group71:
      name: 'Play'
      content:
        [
          name: -> 'Play'
          klass: 'optSlideshowPlay'
          icon: 'play'
          iconcolor: 'white'
          disabled: -> (Gallery.selectionList().length isnt 1) or !(Album.record and Album.record.contains())
        ]
    group8:
      name: 'Back'
      locked: true
      content:
        [
          name: 'x'
          klass: 'optPrevious'
          innerklass: 'chromeless'
          outerstyle: 'float: right;'
          innerstyle: 'left: -8px; top: 8px;'
        ]
    group81:
      name: 'Chromeless'
      locked: true
      content:
        [
          name: 'Chromless'
          klass: -> 'optFullScreen'  + if App.showView.slideshowView.fullScreenEnabled() then ' active' else ''
          dataToggle: 'button'
          outerstyle: ''
        ]
    group9:
      name: 'Slider'
      content:
        [
          name: '<span class="slider" style=""></span>'
          klass: 'optThumbsize '
          type: 'div'
          innerstyle: 'width: 190px; position: relative;'
        ]
        
  init: (ins) ->
    
  # for the filter
  select: (list) ->
    @name in list
    
Spine.Model.Toolbar = Toolbar