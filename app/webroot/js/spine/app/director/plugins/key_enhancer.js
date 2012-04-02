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
      preventEvents: function(e) {
        return e.stopPropagation();
      }
    };
    Extend = {
      events: {
        'keypress input': 'preventEvents',
        'keypress textarea': 'preventEvents'
      }
    };
    this.include(Include);
    return this.extend(Extend);
  }
};
