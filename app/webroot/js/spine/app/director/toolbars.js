({
  "group1": {
    "name": "Gallery",
    "content": [
      {
        "name": "Edit Gallery",
        "klass": "optEditGallery",
        "disabled": function() {
          return !Gallery.record;
        }
      }, {
        "name": "New Gallery",
        "klass": "optCreateGallery"
      }, {
        "name": "Delete Gallery",
        "klass": "optDestroyGallery",
        "disabled": function() {
          return !Gallery.record;
        }
      }
    ]
  },
  "group2": {
    "name": "GalleryEdit",
    "content": [
      {
        "name": "Save and Close",
        "klass": "optSave default",
        "disabled": function() {
          return !Gallery.record;
        }
      }, {
        "name": "Delete Gallery",
        "klass": "optDestroy",
        "disabled": function() {
          return !Gallery.record;
        }
      }
    ]
  },
  "group3": {
    "name": Album,
    "content": [
      {
        "name": "New Album",
        "klass": "optCreateAlbum"
      }, {
        "name": "Delete Album",
        "klass": "optDestroyAlbum ",
        "disabled": function() {
          return !Gallery.selectionList().length;
        }
      }
    ]
  },
  "group4": {
    "name": "Photos",
    "content": [
      {
        "name": "Delete Image",
        "klass": "optDestroyPhoto ",
        "disabled": function() {
          return !Album.selectionList().length;
        }
      }, {
        "klass": "optThumbsize ",
        "name": "<span id=\"slider\" style=\"\"></span>",
        type: "div",
        style: "width: 190px; position: relative;"
      }
    ]
  },
  "group5": {
    "name": "Photo",
    "content": [
      {
        "name": "Delete Image",
        "klass": "optDestroyPhoto ",
        "disabled": function() {
          return !Album.selectionList().length;
        }
      }
    ]
  },
  "group6": {
    "name": "Upload",
    "content": [
      {
        "name": "Show Upload",
        "klass": ""
      }
    ]
  },
  "group7": {
    "name": "Slideshow",
    "content": [
      {
        "name": "Slideshow",
        "klass": "optSlideshow",
        "disabled": function() {
          return !Album.record;
        }
      }, {
        "name": "Fullscreen",
        "klass": "optFullscreen"
      }
    ]
  },
  "group8": {
    "name": "Back",
    "content": [
      {
        "name": "Back",
        "klass": "optPrevious"
      }
    ]
  }
});