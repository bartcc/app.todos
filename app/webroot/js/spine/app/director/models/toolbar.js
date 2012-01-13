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
  Toolbar.data = {
    group1: {
      name: 'Gallery',
      content: [
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
        }, {
          name: 'Delete Gallery',
          klass: 'optDestroy',
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
          name: 'New Album',
          klass: 'optCreateAlbum'
        }, {
          name: 'Delete Album',
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
      ]
    },
    group5: {
      name: 'Photo',
      content: [
        {
          name: 'Delete Image',
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
            if (Album.record.title) {
              return 'Slideshow: ' + Album.record.title;
            } else {
              return 'No Slideshow (Select Album)';
            }
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
          name: 'Autoplay Mode',
          klass: function() {
            return 'optSlideshowMode ' + (App.showView.slideshowView.slideshowMode() ? ' active' : '');
          }
        }, {
          name: 'Chromless Mode',
          klass: function() {
            return 'optFullscreenMode ' + (App.showView.slideshowView.fullscreenMode() ? ' active' : '');
          }
        }, {
          name: 'X',
          klass: 'optPrevious'
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