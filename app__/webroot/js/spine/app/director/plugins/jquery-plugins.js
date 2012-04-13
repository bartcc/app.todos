var $, Timer;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
$ = typeof jQuery !== "undefined" && jQuery !== null ? jQuery : require("jqueryify");
$.fn.deselect = function(sel) {
  return $(this).children(sel).removeClass('active');
};
$.Timer_ = function(interval, calls, onend) {
  var callback, count, end, payload, startTime, timer;
  count = 0;
  payload = this;
  startTime = new Date();
  callback = function() {
    return payload(startTime, count);
  };
  end = function() {
    if (onend) {
      return onend(startTime, count, calls);
    }
  };
  timer = function() {
    count++;
    if (count < calls && callback()) {
      return window.setTimeout(timer, interval);
    } else {
      return end();
    }
  };
  return timer();
};
Timer = (function() {
  __extends(Timer, Object);
  function Timer(interval, calls, onend) {
    this.stop = __bind(this.stop, this);    Timer.__super__.constructor.apply(this, arguments);
  }
  Timer.prototype.start = function() {
    var d;
    d = new Date();
    this.startTime = this.now();
    return this;
  };
  Timer.prototype.now = function() {
    return new Date().getTime();
  };
  Timer.prototype.stop = function() {
    var now;
    now = this.now();
    return {
      started: this.startTime,
      ended: now,
      s: (now - this.startTime) / 1000,
      ms: now - this.startTime
    };
  };
  return Timer;
})();
