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
        [list]
        
      lockToolbar: ->
        @locked = true
      
      unlockToolbar: ->
        @locked = false
        
      selectTool: (model) ->
        console.log 'Toolbars::selectTool'
        return @currentToolbar = @toolBarList(model?.className or model)# unless @locked
        return

      changeToolbar: (nameOrModel) ->
        toolbar = @selectTool nameOrModel
        console.log toolbar
        @trigger('render:toolbar', toolbar) if toolbar
        
    Extend = {}
      
    @include  Include
    @extend   Extend
