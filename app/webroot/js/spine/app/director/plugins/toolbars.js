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
          Gallery2: [
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
          Photo: [
            {
              name: 'New Phot',
              klass: 'optCreatePhoto'
            }, {
              name: 'Delete Photo',
              klass: 'optDestroyPhoto '
            }
          ],
          Upload: [
            {
              name: 'Show Upload',
              klass: ''
            }
          ],
          Grid: [
            {
              name: 'Show Grid',
              klass: ''
            }, {
              name: 'Edit Grid',
              klass: ''
            }
          ]
        };
        return list[item];
      },
      selectTool: function(model) {
        console.log('Toolbars::selectTool');
        return this.currentToolbar = this.toolBarList((model != null ? model.className : void 0) || model);
      },
      changeToolbar: function(nameOrModel) {
        var toolbar;
        toolbar = this.selectTool(nameOrModel);
        return this.trigger('render:toolbar', toolbar);
      }
    };
    Extend = {};
    this.include(Include);
    return this.extend(Extend);
  }
};