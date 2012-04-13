var $, Controller;
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Controller = Spine.Controller;
Controller.KeyEnhancer = {
  extended: function() {
    var Extend, Include;
    Include = {
      init: function() {
        if (this.constructor.events) {
          return this.delegateEvents(this.constructor.events);
        }
      },
      stopPropagation: function(e) {
        return e.stopPropagation();
      }
    };
    Extend = {
      events: {
        'keypress input': 'stopPropagation',
        'keypress textarea': 'stopPropagation'
      }
    };
    this.include(Include);
    return this.extend(Extend);
  }
};
