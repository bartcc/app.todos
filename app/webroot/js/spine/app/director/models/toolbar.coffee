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
          name: 'Show Album Masters'
          klass: 'optAllAlbums'
        ,
          name: 'Show Photo Masters'
          klass: 'optAllPhotos '
        ,
          devider: true
        ,
          name: 'Overview'
          klass: 'optOverview '
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
          name: -> 'Start Slideshow'
          klass: 'optSlideshow'
          disabled: -> !Gallery.selectionList().length
        ]
    group8:
      name: 'Back'
      locked: true
      content:
        [
          name: 'X'
          klass: 'optPrevious'
          outerstyle: 'float: right;'
        ,
          name: 'Chromless'
          klass: -> 'optFullscreenMode '  + if App.showView.slideshowView.fullscreenMode() then ' active' else ''
          dataToggle: 'button'
          outerstyle: 'float: right;'
        ]
    group9:
      name: 'Slider'
      content:
        [
          name: '<span class="slider" style=""></span>'
          klass: 'optThumbsize '
          type: 'div'
          style: 'width: 190px; position: relative;'
        ]
        
  init: (ins) ->
    
  select: (list) ->
    @name in list
    
Spine.Model.Toolbar = Toolbar