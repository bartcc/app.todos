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
      name: 'Views'
      content:
        [
          name: 'All Galleries'
          klass: 'optAllGalleries'
        ,
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
        ]
    group1:
      name: 'Gallery'
      content:
        [
          name: 'New Gallery'
          klass: 'optCreateGallery'
        ,
          name: 'Edit Gallery (Exit View)'
          klass: 'optEditGallery'
          disabled: -> !Gallery.record
        ,
          name: 'Edit Gallery'
          klass: 'optGallery'
          disabled: -> !Gallery.record
        ,
          name: 'Delete Gallery'
          klass: 'optDestroyGallery'
          disabled: -> !Gallery.record
        ]
    group2:
      name: 'Album'
      content:
        [
          name: 'New Album'
          klass: 'optCreateAlbum'
        ,
          name: 'Edit Album'
          klass: 'optAlbum'
        ,
          name: 'Delete Album'
          klass: 'optDestroyAlbum'
          disabled: -> !Gallery.selectionList().length
        ]
    group3:
      name: 'Photo'
      content:
        [
          name: 'Edit Photo'
          klass: 'optPhoto'
          disabled: -> !Album.selectionList().length
        ,
          name: 'Delete Photo'
          klass: 'optDestroyPhoto '
          disabled: -> !Album.selectionList().length
        ,
          devider: true
        ,
          name: 'Upload'
          klass: 'optUpload'
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
          name: 'Edit Gallery'
          klass: 'optEditGallery'
          disabled: -> !Gallery.record
        ,
          name: 'New Gallery'
          klass: 'optCreateGallery'
        ,
          name: 'Delete Gallery'
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
        ,
          name: 'Delete Gallery'
          klass: 'optDestroy'
          disabled: -> !Gallery.record
        ]
    group3:
      name: 'Album'
      content:
        [
          name: 'New Album'
          klass: 'optCreateAlbum'
        ,
          name: 'Delete Album'
          klass: 'optDestroyAlbum '
          disabled: -> !Gallery.selectionList().length
        ]
    group4:
      name: 'Photos'
      content:
        [
          name: 'Delete Photo'
          klass: 'optDestroyPhoto'
          outerstyle: 'float: right;'
          disabled: -> !Album.selectionList().length
        ]
    group5:
      name: 'Photo'
      content:
        [
          name: 'Delete Image'  
          klass: 'optDestroyPhoto '
          disabled: -> !Album.selectionList().length
        ]
    group6:
      name: 'Upload'
      content:
        [
          name: 'Show Upload'
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