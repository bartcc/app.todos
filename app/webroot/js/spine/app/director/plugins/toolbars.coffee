Controller = Spine.Controller

Controller.Toolbars =
  
  extended: ->
  
    Include =
      toolBarList: (item) ->
        list =
          Gallery:
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
          ,
          GalleryEdit:
            [
              name: 'Save and Close'
              klass: 'optSave default'
              disabled: -> !Gallery.record
            ,
              name: 'Delete Gallery'
              klass: 'optDestroy'
              disabled: -> !Gallery.record
            ]
          Album:
            [
              name: 'New Album'
              klass: 'optCreateAlbum'
            ,
              name: 'Delete Album'
              klass: 'optDestroyAlbum '
              disabled: -> !Gallery.selectionList().length
            ]
          ,
          Photos:
            [
              name: 'Delete Image'
              klass: 'optDestroyPhoto '
              disabled: -> !Album.selectionList().length
            ,
              name: '<div class="optThumbsize" style="width: 150px;"><span id="slider" style=""></span></div>'
              eval: -> App.showView.initSlider()
            ]
          ,
          Photo:
            [
              name: 'Delete Image'  
              klass: 'optDestroyPhoto '
              disabled: -> !Album.selectionList().length
            ]
          ,
          Upload:
            [
              name: 'Show Upload'
              klass: ''
            ]
          ,
          Slideshow:
            [
              name: 'Play'
              klass: ''
            ]
        list[item]
        
      lockToolbar: ->
        @locked = true
      
      unlockToolbar: ->
        @locked = false
        
      changeTool: (model) ->
        toolbar = @toolBarList(model?.className or model) unless @locked
        @currentToolbar = toolbar if toolbar

      changeToolbar: (nameOrModel, cb) ->
        @changeTool nameOrModel
        @currentToolbar.cb = cb if cb
        @_renderToolbar()

      renderToolbar: -> arguments[0]

      _renderToolbar: ->
        @renderToolbar()
        @currentToolbar?.cb?()
        
    Extend =
      init: ->
        console.log 'INIT STATIC'
      
    @include  Include
    @extend   Extend
