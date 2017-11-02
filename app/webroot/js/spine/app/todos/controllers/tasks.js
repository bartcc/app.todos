var Tasks,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Tasks = (function(_super) {
  __extends(Tasks, _super);

  Tasks.prototype.tag = 'li';

  Tasks.prototype.events = {
    "click .item": "blur",
    "change   input[type=checkbox]": "toggle",
    "click    .destroy": "destroy",
    "dblclick .view": "edit",
    "keypress input[type=text]": "blurOnEnter",
    "blur     input[type=text]": "close"
  };

  Tasks.prototype.elements = {
    ".items": "list",
    "input[type=text]": "input",
    ".item": "wrapper"
  };

  function Tasks() {
    Tasks.__super__.constructor.apply(this, arguments);
    this.item.bind("update", this.proxy(this.render));
    this.item.bind("destroy", this.proxy(this.remove));
  }

  Tasks.prototype.template = function(item) {
    return $("#taskTemplate").tmpl(item);
  };

  Tasks.prototype.display = function(item) {
    var anchorContent, anchorEl, anchorText, container, content, href, matches, part, patt, protocol, regex_content, res;
    patt = /(https?:\/\/)?([\da-z\.-]+)\.([a-z]{2,6})\/?/g;
    content = item.name;
    res = content.match(patt);
    regex_content = content;
    protocol = "http://";
    container = $('<div></div>');
    if (res) {
      while ((matches = patt.exec(regex_content)) !== null) {
        href = matches[0].indexOf(protocol) !== -1 ? matches[0] : protocol + matches[0];
        anchorEl = $('<a></a>').attr({
          'href': href,
          'target': '_blank',
          'title': 'Open ' + matches[0] + ' in new Tab'
        });
        part = content.split(matches[0]);
        content = part.slice(1).join(matches[0]);
        anchorText = matches[2] + '.' + matches[3];
        anchorContent = anchorEl.html(anchorText);
        container.append(part[0]).append(anchorContent);
      }
      container.append(content);
    } else {
      container.text(content);
    }
    item.html = container.html();
    return item;
  };

  Tasks.prototype.render = function() {
    var element, isEqual;
    this.item.reload();
    isEqual = _.isEqual(this.item.savedAttributes, this.item.attributes());
    element = this.template(this.display(this.item));
    this.el.prop('id', 'todo-' + this.item.id).addClass('hover');
    this.el.html(element).toggleClass('unsaved', !isEqual);
    this.refreshElements();
    return this;
  };

  Tasks.prototype.toggle = function() {
    this.item.done = !this.item.done;
    return this.item.save();
  };

  Tasks.prototype.destroy = function() {
    return this.item.remove();
  };

  Tasks.prototype.edit = function() {
    this.wrapper.addClass("editing");
    return this.input.focus();
  };

  Tasks.prototype.blur = function(e) {
    return $(e.target).attr('tabindex', 0).focus();
  };

  Tasks.prototype.blurOnEnter = function(e) {
    if (e.keyCode === 13) {
      return e.target.blur();
    }
  };

  Tasks.prototype.close = function() {
    this.wrapper.removeClass("editing");
    return this.item.updateAttributes({
      name: this.input.val()
    });
  };

  Tasks.prototype.remove = function() {
    return this.el.remove();
  };

  return Tasks;

})(Spine.Controller);
