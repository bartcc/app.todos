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
          Gallery2:
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
          Photo:
            [
              name: 'Show Images'
              klass: 'optShowPhotos'
            ,
              name: 'New Image'
              klass: 'optCreatePhoto'
            ,
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
          Grid:
            [
              name: 'Show Grid'
              klass: ''
            ,
              name: 'Edit Grid'
              klass: ''
            ]
        list[item]
        
      selectTool: (model) ->
        console.log 'Toolbars::selectTool'
        @currentToolbar = @toolBarList(model?.className or model)

      changeToolbar: (nameOrModel) ->
        toolbar = @selectTool nameOrModel
        @trigger('render:toolbar', toolbar)
        
        
        
        
    Extend = {}
      
    @include  Include
    @extend   Extend
