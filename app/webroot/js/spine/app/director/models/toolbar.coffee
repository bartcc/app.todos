class Toolbar extends Spine.Model

  @configure 'Toolbar', 'id', 'name', 'content'
  
  @extend Spine.Model.Filter
  
  @load: ->
    @refresh(@tools(), clear:true)
  
  @tools: ->
    list = []
    list.push val for key, val of @data
    list
    
  @data:
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
          name: 'Delete Image'
          klass: 'optDestroyPhoto '
          disabled: -> !Album.selectionList().length
        ,
          klass: 'optThumbsize '
          name: '<span id="slider" style=""></span>'
          type: 'div'
          style: 'width: 190px; position: relative;'
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
          name: 'Slideshow'
          klass: 'optSlideshow'
          disabled: -> !Album.record
        ]
    group8:
      name: 'Back'
      locked: true
      content:
        [
          name: 'Autoplay Mode'
          klass: -> 'optSlideshowMode '  + if App.showView.slideshowView.slideshowMode() then ' active' else ''
        ,
          name: 'Chromless Mode'
          klass: -> 'optFullscreenMode '  + if App.showView.slideshowView.fullscreenMode() then ' active' else ''
        ,
          name: 'X'
          klass: 'optPrevious'
        ]
    
  init: (ins) ->
    
  select: (list) ->
    @name in list
    
Spine.Model.Toolbar = Toolbar