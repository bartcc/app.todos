/**
 * jquery.resizestop (and resizestart)
 * by: Fatih Kadir Akın
 *
 * License is CC0, published to the public domain.
 */
(function($) {
    // Slice shortcut
    var slice = Array.prototype.slice;

    // Special event definition
    $.extend($.event.special, {
        // resize stop special event.
        resizestop: {
            add: function(handle) {
                // shortcut to the event handler.
                var handler = handle.handler;

                // event modifying
                $(this).resize(function(e) {
                    // every resize event clears handler's timer.
                    // and every handler must have a timer.
                    clearTimeout(handler._timer);
                    // change event type text.
                    e.type = 'resizestop';
                    // push the "resize" event to the handler.
                    var _proxy = $.proxy(handler, this, e);
                    // if no resize event fired for a time that we decide, 
                    // then it means its stopped.
                    handler._timer = setTimeout(_proxy, handle.data || 200);
                });
            }
        },
        // resize start special event
        resizestart: {
            add: function(handle) {
                // shortcut to the event handler.
                var handler = handle.handler;

                // event modifying
                $(this).on('resize', function(e) {
                    // every resize event clears handler's timer.
                    // and every handler must have a timer.
                    clearTimeout(handler._timer);
                    // we suddenly fire the event, then we can put 
                    // a flag with name _started knows if it's already fired.
                    if (!handler._started) {
                        e.type = 'resizestart';
                        handler.apply(this, arguments);
                        // after firing the handler, put the flag with the value "true"
                        handler._started = true;
                    }
                    handler._timer = setTimeout($.proxy(function() {
                        // after a while, it will make the flag false.
                        handler._started = false;
                    }, this), handle.data || 300);
                });
            }
        }
    });
    // binding and currying the shortcuts.
    $.extend($.fn, {
        // $(window).resizestop instead of $(window).on('resizestop')
        resizestop: function() {
            // will push the "resizestop" argument at the beginning of arguments
            $(this).on.apply(this, ["resizestop"].concat(slice.call(arguments)));
        },
        // $(window).resizestart instead of $(window).on('resizestart')
        resizestart: function() {
            // will push the "resizestart" argument at the beginning of arguments
            $(this).on.apply(this, ["resizestart"].concat(slice.call(arguments)));
        }
    });
})(jQuery);