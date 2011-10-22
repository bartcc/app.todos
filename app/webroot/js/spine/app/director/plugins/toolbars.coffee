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
        @currentToolBar = @toolBarList(model?.className or model)

      changeToolbar: (model) ->
        toolbar = @selectTool model
        @trigger('render:toolbar', toolbar)
        
        
        
        
    Extend = {}
      
    @include  Include
    @extend   Extend
