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
              klass: 'optThumbsize ',
              name: '<span id="slider" style=""></span>',
              type: 'div',
              style: 'width: 190px;'
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
      renderToolbar: function() {
        return arguments[0];
      },
      changeToolbar: function(nameOrModel, cb, el) {
        this.changeTool(nameOrModel);
        if (this.currentToolbar) {
          if (cb) {
            this.currentToolbar.cb = cb;
          }
          return this._renderToolbar(el);
        }
      },
      _renderToolbar: function() {
        var _ref;
        if (!this.renderToolbar) {
          throw 'No renderToolbar method';
        }
        this.renderToolbar();
        return (_ref = this.currentToolbar) != null ? typeof _ref.cb === "function" ? _ref.cb() : void 0 : void 0;
      },
      changeTool: function(model) {
        var toolbar;
        if (!this.locked) {
          toolbar = this.toolBarList((model != null ? model.className : void 0) || model);
        }
        if (toolbar) {
          return this.currentToolbar = toolbar;
        }
      }
    };
    Extend = {};
    this.include(Include);
    return this.extend(Extend);
  }
};