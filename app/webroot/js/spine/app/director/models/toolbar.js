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
    var key, val, _ref, _results;
    _ref = this.data;
    _results = [];
    for (key in _ref) {
      val = _ref[key];
      _results.push(val);
    }
    return _results;
  };
  Toolbar.dropdownGroups = {
    group0: {
      name: 'View',
      content: [
        {
          name: 'Overview',
          klass: 'optOverview '
        }, {
          name: 'Slides View',
          klass: 'optShowSlideshow ',
          disabled: function() {
            return !App.showView.activePhotos.call();
          }
        }, {
          devider: true
        }, {
          name: 'Invert Selection     Cmd + A',
          klass: 'optSelectAll'
        }, {
          devider: true
        }, {
          name: 'Toggle Fullscreen',
          klass: 'optFullScreen',
          icon: 'fullscreen',
          iconcolor: 'black'
        }, {
          name: 'Toggle Sidebar       Tab',
          klass: 'optSidebar'
        }, {
          devider: true
        }, {
          name: 'Modal Test',
          icon: 'th',
          iconcolor: 'black',
          klass: 'optShowModal'
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
          devider: true
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
        }, {
          devider: true
        }, {
          name: 'Large Edit View',
          icon: 'pencil',
          klass: 'optEditGallery',
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
          icon: '',
          klass: 'optCreateAlbum'
        }, {
          devider: true
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
        }, {
          devider: true
        }, {
          name: function() {
            return 'Start Slideshow';
          },
          icon: 'play',
          klass: 'optSlideshowPlay',
          dataToggle: 'modal-gallery',
          disabled: function() {
            return !(App.showView.activePhotos.call(this)).length;
          }
        }, {
          name: function() {
            return 'Slideshow Autostart';
          },
          icon: function() {
            if (App.slideshow.options.autostart) {
              return 'ok';
            } else {
              return '';
            }
          },
          klass: 'optSlideshowAutoStart',
          disabled: function() {
            return false;
          }
        }, {
          name: function() {
            return 'Albummasters';
          },
          klass: 'optShowAlbumMasters',
          disabled: function() {
            return false;
          }
        }
      ]
    },
    group3: {
      name: 'Photo',
      content: [
        {
          name: 'Upload',
          icon: 'upload',
          klass: 'optUpload'
        }, {
          devider: true
        }, {
          name: function() {
            return 'Copy Photos to New Album (' + Album.selectionList().length + ')';
          },
          icon: '',
          klass: 'optCreateAlbumFromSel',
          disabled: function() {
            return !Album.selectionList().length;
          }
        }, {
          name: function() {
            return 'Move Photos to New Album (' + Album.selectionList().length + ')';
          },
          icon: '',
          klass: 'optCreateAlbumFromSelCut',
          disabled: function() {
            return !Album.selectionList().length;
          }
        }, {
          devider: true
        }, {
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
          name: 'Auto Upload',
          icon: function() {
            if (App.showView.isQuickUpload()) {
              return 'ok';
            } else {
              return '';
            }
          },
          klass: 'optQuickUpload'
        }, {
          name: function() {
            return 'Photomasters';
          },
          klass: 'optShowPhotoMasters',
          disabled: function() {
            return false;
          }
        }
      ]
    }
  };
  Toolbar.data = {
    group01: {
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
    group02: {
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
    group03: {
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
    group04: {
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
    group05: {
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
    group06: {
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
    group07: {
      name: 'Upload',
      content: [
        {
          name: 'Show Upload',
          icon: 'upload',
          klass: ''
        }
      ]
    },
    group08: {
      name: 'Slideshow',
      content: [
        {
          name: function() {
            return (App.showView.activePhotos.call(this)).length;
          },
          klass: 'optSlideshowPlay',
          icon: 'play',
          iconcolor: 'white',
          innerstyle: 'left: -8px; top: 8px;',
          disabled: function() {
            return !(App.showView.activePhotos.call(this)).length;
          }
        }
      ]
    },
    group10: {
      name: 'Back',
      locked: true,
      content: [
        {
          name: '',
          klass: 'optPrevious',
          innerklass: 'chromeless',
          outerstyle: 'float: left;',
          innerstyle: 'left: -8px; top: 8px;'
        }
      ]
    },
    group11: {
      name: 'Chromeless',
      locked: true,
      content: [
        {
          name: 'Chromeless',
          klass: function() {
            return 'optFullScreen' + (App.showView.slideshowView.fullScreenEnabled() ? ' active' : '');
          },
          icon: '',
          dataToggle: 'button',
          outerstyle: ''
        }, {
          name: function() {
            return '';
          },
          klass: 'optSlideshowPlay',
          icon: 'play',
          iconcolor: 'white',
          disabled: function() {
            return !App.showView.activePhotos.call(this);
          }
        }
      ]
    },
    group12: {
      name: 'Slider',
      content: [
        {
          name: '<span class="slider" style=""></span>',
          klass: 'optThumbsize ',
          type: 'div',
          innerstyle: 'width: 190px; position: relative;'
        }
      ]
    },
    group13: {
      name: 'SlideshowPackage',
      content: [
        {
          name: 'Chromeless',
          klass: function() {
            return 'optFullScreen' + (App.showView.slideshowView.fullScreenEnabled() ? ' active' : '');
          },
          icon: '',
          dataToggle: 'button',
          outerstyle: ''
        }, {
          name: function() {
            return (App.showView.activePhotos.call(this)).length;
          },
          klass: 'optSlideshowPlay',
          icon: 'play',
          iconcolor: 'white',
          disabled: function() {
            return !(App.showView.activePhotos.call(this)).length;
          }
        }, {
          name: '<span class="slider" style=""></span>',
          klass: 'optThumbsize ',
          type: 'div',
          innerstyle: 'width: 190px; position: relative;'
        }, {
          name: '',
          klass: 'optPrevious',
          type: 'span',
          innerklass: 'icon-white icon-remove',
          outerstyle: 'float: right;',
          innerstyle: 'left: -8px; top: 8px; position:relative;'
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
