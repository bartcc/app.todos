var $, Toolbar;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Toolbar = (function() {
  __extends(Toolbar, Spine.Controller);
  function Toolbar() {
    this.list = new Array;
    this.list.push([
      new Spine.ToolbarItem({
        name: 'Edit Gallery',
        klass: 'optEditGallery',
        disabled: function() {
          return !Gallery.record;
        }
      }), new Spine.ToolbarItem({
        name: 'New Gallery',
        klass: 'optCreateGallery'
      }), new Spine.ToolbarItem({
        name: 'Delete Gallery',
        klass: 'optDestroyGallery',
        disabled: function() {
          return !Gallery.record;
        }
      })
    ]);
    this.list.push([
      new Spine.ToolbarItem({
        name: 'Save and Close',
        klass: 'optSave default',
        disabled: function() {
          return !Gallery.record;
        }
      }), new Spine.ToolbarItem({
        name: 'Delete Gallery',
        klass: 'optDestroy',
        disabled: function() {
          return !Gallery.record;
        }
      })
    ]);
    this.list.push([
      new Spine.ToolbarItem({
        name: 'New Album',
        klass: 'optCreateAlbum'
      }), new Spine.ToolbarItem({
        name: 'Delete Album',
        klass: 'optDestroyAlbum ',
        disabled: function() {
          return !Gallery.selectionList().length;
        }
      })
    ]);
    this.list.push([
      new Spine.ToolbarItem({
        name: 'Delete Image',
        klass: 'optDestroyPhoto ',
        disabled: function() {
          return !Album.selectionList().length;
        }
      }), new Spine.ToolbarItem({
        name: '<div class="optThumbsize" style="width: 150px;"><span id="slider" style=""></span></div>'
      })
    ]);
    this.list.push([
      new Spine.ToolbarItem({
        name: 'Delete Image',
        klass: 'optDestroyPhoto ',
        disabled: function() {
          return !Album.selectionList().length;
        }
      }, new Spine.ToolbarItem({
        name: 'Show Upload',
        klass: ''
      }))
    ]);
    this.list.push([
      new Spine.ToolbarItem({
        name: 'Play',
        klass: ''
      })
    ]);
    ({
      lockToolbar: function() {
        return this.locked = true;
      },
      unlockToolbar: function() {
        return this.locked = false;
      },
      selectTool: function(name) {
        console.log('Toolbars::selectTool');
        if (!this.locked) {
          return this.currentToolbar = this.toolBarList(name);
        }
      },
      change: function(name) {
        var toolbar;
        console.log('Toolbar::cjange');
        console.log(name);
        return;
        toolbar = this.selectTool(name);
        console.log(toolbar);
        if (toolbar) {
          return this.trigger('render:toolbar', toolbar);
        }
      }
    });
  }
  return Toolbar;
})();