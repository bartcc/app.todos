var Main;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Main = (function() {
  __extends(Main, Spine.Controller);
  Main.prototype.events = {
    'sortupdate .items': 'sortupdate',
    'click footer .clear': 'clear',
    'keypress #create-todo input': 'create',
    'keyup #new-todo': 'showTooltip'
  };
  Main.prototype.elements = {
    "footer .clear": 'clear',
    '.items': 'items',
    '#create-todo input': 'input',
    '#create-todo .countVal': 'count',
    '#stats': 'stats'
  };
  Main.prototype.statsTemplate = function() {
    return $.template(null, $('#stats-template').html());
  };
  function Main() {
    Main.__super__.constructor.apply(this, arguments);
    Task.bind('create', this.proxy(this.addOne));
    Task.bind('refresh change', this.proxy(this.renderCount));
    Task.bind('refresh change', this.proxy(this.renderStats));
    Task.bind('refresh change', this.proxy(this.updateUnsaved));
    Task.bind('refresh:list', this.proxy(this.refreshList));
    Task.bind('refresh', this.proxy(this.addAll));
    this.items.sortable();
  }
  Main.prototype.refreshList = function() {
    Spine.App.trigger('render:refreshState', true);
    Spine.Ajax.enabled = false;
    Task.destroyAll();
    Spine.Ajax.enabled = true;
    return Task.fetch();
  };
  Main.prototype.sortupdate = function(e, ui) {
    return this.items.children('li').each(function(index) {
      var task;
      task = Task.find($(this).attr('id').replace("todo-", ""));
      if ((task != null ? task.order : void 0) !== index) {
        task.order = index;
        return task.save();
      }
    });
  };
  Main.prototype.create = function(e) {
    var task;
    if (e.keyCode !== 13) {
      return;
    }
    task = new Task(this.newAttributes());
    task.save();
    this.input.val("");
    return false;
  };
  Main.prototype.newAttributes = function() {
    var attr;
    attr = {};
    $.extend(attr, Task.defaults, {
      name: this.input.val() || void 0,
      order: Task.nextOrder()
    });
    return attr;
  };
  Main.prototype.addOne = function(task) {
    var el, view;
    view = new Tasks({
      item: task
    });
    el = view.render().el;
    return this.items.append(el);
  };
  Main.prototype.addAll = function() {
    Task.each(this.proxy(this.addOne));
    return Spine.App.trigger('render:refreshState', false);
  };
  Main.prototype.renderCount = function() {
    var active;
    active = Task.active().length;
    return this.count.text(active + ' item' + (active !== 1 ? 's' : '') + ' left');
  };
  Main.prototype.renderStats = function() {
    var active;
    active = Task.active().length;
    return this.stats.html($.tmpl(this.statsTemplate(), {
      done: Task.done().length
    }));
  };
  Main.prototype.updateUnsaved = function(task) {
    if (!Spine.Ajax.enabled) {
      return;
    }
    if (task != null ? task.id : void 0) {
      return Task.saveModelState(task.id);
    } else {
      return Task.each(function(model) {
        return Task.saveModelState(model.id);
      });
    }
  };
  Main.prototype.clear = function() {
    Task.destroyDone();
    return Task.trigger('change:unsaved');
  };
  Main.prototype.showTooltip = function(e) {
    var show, tooltip, val;
    tooltip = this.$(".ui-tooltip-top");
    val = this.input.val();
    tooltip.fadeOut();
    if (this.tooltipTimeout) {
      clearTimeout(this.tooltipTimeout);
    }
    if (val === '' || val === this.input.attr('placeholder')) {
      return;
    }
    show = function() {
      return tooltip.show().fadeIn();
    };
    return this.tooltipTimeout = setTimeout(show, 1000);
  };
  return Main;
})();