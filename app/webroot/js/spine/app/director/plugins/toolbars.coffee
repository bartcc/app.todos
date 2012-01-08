Controller = Spine.Controller

Controller.Toolbars =
  
  extended: ->
  
    Include =
      toolBarList: (items) ->
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
              style: 'width: 190px; position: relative;'
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
              name: 'Slideshow'
              klass: 'optSlideshow'
              disabled: -> !Album.record
            ,
              name: 'Fullscreen'
              klass: 'optFullscreen'
            ]
          ,
          Back:
            [
              name: 'Back'
              klass: 'optPrevious'
            ]
        arr = []
        for item in items
          itm = list[item?.constructor.className or item]
          console.log item
          console.log itm
          arr.push it for it in itm
        arr
        
      lockToolbar: ->
        @locked = true
      
      unlockToolbar: ->
        @locked = false
        
      renderToolbar: -> arguments[0]
      
      tboptions:
        cb: -> arguments[0]
        el: 'toolbarEl'
      
      changeToolbar: (nameOrModel, opts) ->
        options = $.extend({}, @tboptions, opts)
        @callback = options.cb
        @element  = options.el
        
        if nameOrModel
          unless Album.isArray(nameOrModel)
            nameOrModel = [nameOrModel]
          
          @changeTool nameOrModel 
        
        if @currentToolbar
          cb = @callback
          @currentToolbar.cb = cb if typeof cb is 'function'
          @_renderToolbar()

      _renderToolbar: ->
        @trigger('render:toolbar', @element)
        @currentToolbar?.cb?()
        
      changeTool: (nameOrModel) ->
        toolbar = @toolBarList(nameOrModel) unless @locked
        console.log toolbar
        @currentToolbar = toolbar if toolbar
        
    Extend = {}
      
    @include  Include
    @extend   Extend
