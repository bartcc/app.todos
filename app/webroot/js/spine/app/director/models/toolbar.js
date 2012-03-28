var Toolbar;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
Toolbar = (function() {
  __extends(Toolbar, Spine.Model);
  function Toolbar() {
    Toolbar.__super__.constructor.apply(this, arguments);
  }
  Toolbar.configure('Toolbar', 'id', 'name', 'content');
  Toolbar.extend(Spine.Model.Filter);
  Toolbar.load = function() {
    return this.refresh(this.tools(), {
      clear: true
    });
  };
  Toolbar.tools = function() {
    var key, list, val, _ref;
    list = [];
    _ref = this.data;
    for (key in _ref) {
      val = _ref[key];
      list.push(val);
    }
    return list;
  };
  Toolbar.dropdownGroups = {
    group0: {
      name: 'View',
      content: [
        {
          name: 'All Albums',
          klass: 'optAllAlbums'
        }, {
          name: 'All Photos',
          klass: 'optAllPhotos '
        }, {
          devider: true
        }, {
          name: 'Overview',
          klass: 'optOverview '
        }, {
          name: 'Invert Selection (Cmd + A)',
          klass: 'optSelectAll'
        }, {
          name: 'Toggle Fullscreen',
          klass: 'optFullScreen'
        }
      ]
    },
    group1: {
      name: 'Gallery',
      content: [
        {
          name: 'New',
          icon: 'asterisk',
          klass: 'optCreateGallery'
        }, {
          name: 'Edit (Large View)',
          icon: 'pencil',
          klass: 'optEditGallery',
          disabled: function() {
            return !Gallery.record;
          }
        }, {
          name: 'Edit',
          icon: 'pencil',
          klass: 'optGallery',
          disabled: function() {
            return !Gallery.record;
          }
        }, {
          name: 'Destroy',
          icon: 'trash',
          klass: 'optDestroyGallery',
          disabled: function() {
            return !Gallery.record;
          }
        }
      ]
    },
    group2: {
      name: 'Album',
      content: [
        {
          name: 'New',
          icon: 'asterisk',
          klass: 'optCreateAlbum'
        }, {
          name: 'Edit',
          icon: 'pencil',
          klass: 'optAlbum',
          disabled: function() {
            return !Gallery.selectionList().length;
          }
        }, {
          name: function() {
            var len, type;
            len = '(' + Gallery.selectionList().length + ')';
            type = Gallery.record ? 'Remove' : 'Destroy';
            return type + ' ' + len;
          },
          icon: 'trash',
          klass: 'optDestroyAlbum',
          disabled: function() {
            return !Gallery.selectionList().length;
          }
        }
      ]
    },
    group3: {
      name: 'Photo',
      content: [
        {
          name: 'Edit',
          icon: 'pencil',
          klass: 'optPhoto',
          disabled: function() {
            return !Album.selectionList().length;
          }
        }, {
          name: function() {
            var len, type;
            len = '(' + Album.selectionList().length + ')';
            type = Album.record ? 'Remove' : 'Destroy';
            return type + ' ' + len;
          },
          icon: 'trash',
          klass: 'optDestroyPhoto ',
          disabled: function() {
            return !Album.selectionList().length;
          }
        }, {
          devider: true
        }, {
          name: 'Upload',
          icon: 'upload',
          klass: 'optUpload'
        }, {
          name: 'Auto Upload',
          icon: function() {
            if (App.showView.isQuickUpload()) {
              return 'ok';
            } else {
              return '';
            }
          },
          klass: 'optQuickUpload'
        }
      ]
    }
  };
  Toolbar.data = {
    group0: {
      name: 'Default',
      content: [
        {
          dropdown: true,
          itemGroup: Toolbar.dropdownGroups.group0
        }, {
          dropdown: true,
          itemGroup: Toolbar.dropdownGroups.group1
        }, {
          dropdown: true,
          itemGroup: Toolbar.dropdownGroups.group2
        }, {
          dropdown: true,
          itemGroup: Toolbar.dropdownGroups.group3
        }
      ]
    },
    group1: {
      name: 'Gallery',
      content: [
        {
          name: 'Edit',
          icon: 'pencil',
          klass: 'optEditGallery',
          disabled: function() {
            return !Gallery.record;
          }
        }, {
          name: 'New',
          icon: 'asterisk',
          klass: 'optCreateGallery'
        }, {
          name: 'Destroy',
          icon: 'trash',
          klass: 'optDestroyGallery',
          disabled: function() {
            return !Gallery.record;
          }
        }, {
          dropdown: true,
          itemGroup: Toolbar.dropdownGroups.group0
        }
      ]
    },
    group2: {
      name: 'GalleryEdit',
      content: [
        {
          name: 'Save and Close',
          klass: 'optSave default',
          disabled: function() {
            return !Gallery.record;
          }
        }
      ]
    },
    group3: {
      name: 'Album',
      content: [
        {
          name: 'New',
          icon: 'asterisk',
          klass: 'optCreateAlbum'
        }, {
          name: function() {
            var len, type;
            len = '(' + Gallery.selectionList().length + ')';
            type = Gallery.record ? 'Remove' : 'Destroy';
            return type + ' ' + len;
          },
          icon: 'trash',
          klass: 'optDestroyAlbum ',
          disabled: function() {
            return !Gallery.selectionList().length;
          }
        }
      ]
    },
    group4: {
      name: 'Photos',
      content: [
        {
          name: function() {
            var len, type;
            len = '(' + Album.selectionList().length + ')';
            type = Album.record ? 'Remove' : 'Destroy';
            return type + ' ' + len;
          },
          klass: 'optDestroyPhoto',
          outerstyle: 'float: right;',
          disabled: function() {
            return !Album.selectionList().length;
          }
        }
      ]
    },
    group5: {
      name: 'Photo',
      content: [
        {
          name: function() {
            var len, type;
            len = '(' + Album.selectionList().length + ')';
            type = Album.record ? 'Remove' : 'Destroy';
            return type + ' ' + len;
          },
          klass: 'optDestroyPhoto ',
          disabled: function() {
            return !Album.selectionList().length;
          }
        }
      ]
    },
    group6: {
      name: 'Upload',
      content: [
        {
          name: 'Show Upload',
          icon: 'upload',
          klass: ''
        }
      ]
    },
    group7: {
      name: 'Slideshow',
      content: [
        {
          name: function() {
            return 'Slideshow';
          },
          klass: 'optSlideshow',
          icon: 'play',
          iconcolor: 'white',
          disabled: function() {
            return !Gallery.selectionList().length;
          }
        }
      ]
    },
    group71: {
      name: 'Play',
      content: [
        {
          name: function() {
            return 'Play';
          },
          klass: 'optSlideshow',
          icon: 'play',
          iconcolor: 'white',
          disabled: function() {
            return !Gallery.selectionList().length;
          }
        }
      ]
    },
    group8: {
      name: 'Back',
      locked: true,
      content: [
        {
          name: 'x',
          klass: 'optPrevious',
          innerklass: 'chromeless',
          outerstyle: 'float: right;',
          innerstyle: 'left: -8px; top: 8px;'
        }
      ]
    },
    group81: {
      name: 'Chromeless',
      locked: true,
      content: [
        {
          name: 'Chromless',
          klass: function() {
            return 'optFullScreen' + (App.showView.slideshowView.fullScreenEnabled() ? ' active' : '');
          },
          dataToggle: 'button',
          outerstyle: ''
        }
      ]
    },
    group9: {
      name: 'Slider',
      content: [
        {
          name: '<span class="slider" style=""></span>',
          klass: 'optThumbsize ',
          type: 'div',
          innerstyle: 'width: 190px; position: relative;'
        }
      ]
    }
  };
  Toolbar.prototype.init = function(ins) {};
  Toolbar.prototype.select = function(list) {
    var _ref;
    return _ref = this.name, __indexOf.call(list, _ref) >= 0;
  };
  return Toolbar;
})();
Spine.Model.Toolbar = Toolbar;
