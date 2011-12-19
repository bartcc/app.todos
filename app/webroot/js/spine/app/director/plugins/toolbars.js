var Controller;
Controller = Spine.Controller;
Controller.Toolbars = {
  extended: function() {
    var Extend, Include;
    Include = {
      toolBarList: function(item) {
        var list;
        list = {
          Gallery: [
            {
              name: 'Edit Gallery',
              klass: 'optEditGallery',
              disabled: function() {
                return !Gallery.record;
              }
            }, {
              name: 'New Gallery',
              klass: 'optCreateGallery'
            }, {
              name: 'Delete Gallery',
              klass: 'optDestroyGallery',
              disabled: function() {
                return !Gallery.record;
              }
            }
          ],
          GalleryEdit: [
            {
              name: 'Save and Close',
              klass: 'optSave default',
              disabled: function() {
                return !Gallery.record;
              }
            }, {
              name: 'Delete Gallery',
              klass: 'optDestroy',
              disabled: function() {
                return !Gallery.record;
              }
            }
          ],
          Album: [
            {
              name: 'New Album',
              klass: 'optCreateAlbum'
            }, {
              name: 'Delete Album',
              klass: 'optDestroyAlbum ',
              disabled: function() {
                return !Gallery.selectionList().length;
              }
            }
          ],
          Photos: [
            {
              name: 'Delete Image',
              klass: 'optDestroyPhoto ',
              disabled: function() {
                return !Album.selectionList().length;
              }
            }, {
              name: 'Thumbnail',
              klass: 'optThumbsize',
              html: '<div class="optThumbsize"><span id="slider" style="display: none;"></span></div>'
            }
          ],
          Photo: [
            {
              name: 'Delete Image',
              klass: 'optDestroyPhoto ',
              disabled: function() {
                return !Album.selectionList().length;
              }
            }
          ],
          Upload: [
            {
              name: 'Show Upload',
              klass: ''
            }
          ],
          Slideshow: [
            {
              name: 'Play',
              klass: ''
            }
          ]
        };
        return list[item];
      },
      lockToolbar: function() {
        return this.locked = true;
      },
      unlockToolbar: function() {
        return this.locked = false;
      },
      selectTool: function(model) {
        console.log('Toolbars::selectTool');
        if (!this.locked) {
          return this.currentToolbar = this.toolBarList((model != null ? model.className : void 0) || model);
        }
      },
      changeToolbar: function(nameOrModel) {
        var toolbar;
        toolbar = this.selectTool(nameOrModel);
        if (toolbar) {
          return this.trigger('render:toolbar', toolbar);
        }
      }
    };
    Extend = {};
    this.include(Include);
    return this.extend(Extend);
  }
};