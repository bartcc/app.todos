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
        return this.currentToolBar = this.toolBarList((model != null ? model.className : void 0) || model);
      },
      changeToolbar: function(model) {
        var toolbar;
        toolbar = this.selectTool(model);
        return this.trigger('render:toolbar', toolbar);
      }
    };
    Extend = {};
    this.include(Include);
    return this.extend(Extend);
  }
};