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
          name: 'Show all Galleries',
          klass: 'optAllGalleries'
        }, {
          name: 'Show all Albums',
          klass: 'optAllAlbums'
        }, {
          name: 'Show all Photos',
          klass: 'optAllPhotos '
        }, {
          devider: true
        }, {
          name: 'Overview',
          klass: 'optOverview '
        }
      ]
    },
    group1: {
      name: 'Gallery',
      content: [
        {
          name: 'New',
          klass: 'optCreateGallery'
        }, {
          name: 'Edit (Large View)',
          klass: 'optEditGallery',
          disabled: function() {
            return !Gallery.record;
          }
        }, {
          name: 'Edit',
          klass: 'optGallery',
          disabled: function() {
            return !Gallery.record;
          }
        }, {
          name: 'Destroy (permanently)',
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
          klass: 'optCreateAlbum'
        }, {
          name: 'Edit',
          klass: 'optAlbum'
        }, {
          name: function() {
            if (Gallery.record) {
              return 'Delete';
            } else {
              return 'Destroy (permanently)';
            }
          },
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
          klass: 'optPhoto',
          disabled: function() {
            return !Album.selectionList().length;
          }
        }, {
          name: function() {
            if (Album.record) {
              return 'Delete';
            } else {
              return 'Destroy (permanently)';
            }
          },
          klass: 'optDestroyPhoto ',
          disabled: function() {
            return !Album.selectionList().length;
          }
        }, {
          devider: true
        }, {
          name: 'Upload',
          klass: 'optUpload'
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
          klass: 'optEditGallery',
          disabled: function() {
            return !Gallery.record;
          }
        }, {
          name: 'New',
          klass: 'optCreateGallery'
        }, {
          name: 'Destroy (permanently)',
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
          klass: 'optCreateAlbum'
        }, {
          name: function() {
            if (Gallery.record) {
              return 'Delete';
            } else {
              return 'Destroy';
            }
          },
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
            if (Album.record) {
              return 'Delete';
            } else {
              return 'Destroy';
            }
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
            if (Album.record) {
              return 'Delete';
            } else {
              return 'Destroy';
            }
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
          klass: ''
        }
      ]
    },
    group7: {
      name: 'Slideshow',
      content: [
        {
          name: function() {
            return 'Start Slideshow';
          },
          klass: 'optSlideshow',
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
          name: 'X',
          klass: 'optPrevious',
          outerstyle: 'float: right;'
        }, {
          name: 'Chromless',
          klass: function() {
            return 'optFullscreenMode ' + (App.showView.slideshowView.fullscreenMode() ? ' active' : '');
          },
          dataToggle: 'button',
          outerstyle: 'float: right;'
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
          style: 'width: 190px; position: relative;'
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
