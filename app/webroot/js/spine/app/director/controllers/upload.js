var UploadView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
UploadView = (function() {
  __extends(UploadView, Spine.Controller);
  UploadView.prototype.events = {
    'click': 'click',
    'fileuploadadd': 'add',
    'fileuploaddone': 'done',
    'fileuploadsubmit': 'submit'
  };
  function UploadView() {
    UploadView.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
  }
  UploadView.prototype.add = function(e, data) {
    return console.log('UploadView::add');
  };
  UploadView.prototype.done = function(e, data) {
    var photos;
    console.log('UploadView::done');
    photos = $.parseJSON(data.jqXHR.responseText);
    return Photo.refresh(photos, {
      clear: false
    });
  };
  UploadView.prototype.submit = function(e, data) {
    return console.log('UploadView::submit');
  };
  UploadView.prototype.click = function(e) {
    console.log('click');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return UploadView;
})();