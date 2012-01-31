var Controller;
Controller = Spine.Controller;
Controller.Toolbars = {
  extended: function() {
    var Extend, Include;
    Include = {
      toolBarList: function(items) {
        var arr, it, item, itm, list, _i, _j, _len, _len2;
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
              style: 'width: 190px; position: relative;'
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
              name: 'Slideshow',
              klass: 'optSlideshow',
              disabled: function() {
                return !Album.record;
              }
            }, {
              name: 'Fullscreen',
              klass: 'optFullscreen'
            }
          ],
          Back: [
            {
              name: 'Back',
              klass: 'optPrevious'
            }
          ]
        };
        arr = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          itm = list[(item != null ? item.constructor.className : void 0) || item];
          for (_j = 0, _len2 = itm.length; _j < _len2; _j++) {
            it = itm[_j];
            arr.push(it);
          }
        }
        return arr;
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
      tboptions: {
        cb: function() {
          return arguments[0];
        },
        el: 'toolbarEl'
      },
      changeToolbar: function(nameOrModel, opts) {
        var cb, options;
        options = $.extend({}, this.tboptions, opts);
        this.callback = options.cb;
        this.element = options.el;
        if (nameOrModel) {
          if (!Album.isArray(nameOrModel)) {
            nameOrModel = [nameOrModel];
          }
          this.changeTool(nameOrModel);
        }
        if (this.currentToolbar) {
          cb = this.callback;
          if (typeof cb === 'function') {
            this.currentToolbar.cb = cb;
          }
          return this._renderToolbar();
        }
      },
      _renderToolbar: function() {
        var _ref;
        this.trigger('render:toolbar', this.element);
        return (_ref = this.currentToolbar) != null ? typeof _ref.cb === "function" ? _ref.cb() : void 0 : void 0;
      },
      changeTool: function(nameOrModel) {
        var toolbar;
        if (!this.locked) {
          toolbar = this.toolBarList(nameOrModel);
        }
        console.log(toolbar);
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
