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
              klass: 'optThumbsize '
              name: '<span id="slider" style=""></span>'
              type: 'div'
              style: 'width: 190px;'
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
        
      renderToolbar: -> arguments[0]
      
      changeToolbar: (nameOrModel, cb, el) ->
        @changeTool nameOrModel
        if @currentToolbar
          @currentToolbar.cb = cb if cb
          @_renderToolbar el

      _renderToolbar: (el) ->
        throw('No renderToolbar method') unless @renderToolbar
        @renderToolbar el
        @currentToolbar?.cb?()
        
      changeTool: (model) ->
        toolbar = @toolBarList(model?.className or model) unless @locked
        @currentToolbar = toolbar if toolbar
        
    Extend = {}
      
    @include  Include
    @extend   Extend
