/* ----------------------------------------

	* Ideal Forms 1.02
	* Copyright 2011, Cedric Ruiz
	* Free to use under the GPL license.
	* http://www.spacirdesigns.com

-----------------------------------------*/

/* ---------------------------------------
	Set min-width
----------------------------------------*/
var setMinWidth = function (el) {
	var minWidth = 0;
	el
	.each(function () {
		var width = $(this).width();
		if (width > minWidth) {
			minWidth = width;
		}
	})
	.width(minWidth);
};

/* ---------------------------------------
	Start plugin
----------------------------------------*/
(function ($) {

	$.fn.idealforms = function () {
		this.each(function () {

			var $idealform,
			$labels,
			$selects,
			$radios,
			$checks;

			$idealform = $(this);
			$idealform.addClass('idealform');

/* ---------------------------------------
	Label
----------------------------------------*/

//			$labels = $idealform.find('div').children('label').addClass('main-label');
//			$labels.filter('.required').prepend('<span>*</span>');
//			setMinWidth($labels);

/* ---------------------------------------
	Select
----------------------------------------*/

			$selects = $idealform.find('select');

			var Idealselect = function (select) {

				var that = this;

				// Build markup
				that.build = function () {
					var $options,
					$selected,
					_options = '',
					output;
					$options = select.find('option');
					$selected = $options.filter(':selected');
					$options.each(function () {
						_options += '<li><a href="#">' + $(this).text() + '</a></li>';
					});
					output =
						'<ul class="idealselect">' +
						'<li>' +
						'<a href="#" class="idealselect-title">' + $selected.text() + '<span><small></small></span></a>' +
						'<ul>' + _options + '</ul>' +
						'</li>' +
						'</ul>';
					return output;
				};

				that.el = $(that.build()); // Wrap in jquery object
				that.title = that.el.find('.idealselect-title');
				that.menu = that.el.find('ul');
				that.items = that.menu.find('a');

				// Events
				that.events = {
					open : function () {
						that.el.addClass('open');
						that.menu.show();
					},
					close : function () {
						that.el.removeClass('open');
						that.menu.scrollTop(0);
						that.menu.hide();
					},
					change : function () {
						var idx = $(this).parent().index();
						that.title.text($(this).text()).append('<span><small></small></span>');
						select.find('option').eq(idx).attr('selected', 'selected');
						select.trigger('change');
						that.events.close();
					}
				};

				// Initializate
				that.init = function () {

					// Calculate width & height and insert idealselect
					var $idealselect = that.el.insertAfter(select),
					$items = $idealselect.find('ul a'),
					$menu = $idealselect.find('ul'),
					setWidth = function () {
						$menu.width($menu.outerWidth());
						$idealselect.width($menu.outerWidth());
					};
					if ($items.length > 10) {
						setWidth();
						$menu.height($items.outerHeight() * 10);
					} else {
						setWidth();
						$menu.css('overflow-y', 'hidden');
					}

					that.menu.hide();

					// Bind events
					that.el.find('a').click(function (e) {
						e.preventDefault();
					});
					that.el.on('mouseleave', that.events.close);
					that.title.on('click', that.events.open);
					that.menu.on('mouseleave', that.events.close);
					that.items.on('click', that.events.change);

				};
			};

			// Create & Insert all idealselects
			$selects.each(function () {
				var idealselect = new Idealselect($(this));
				idealselect.init();
			});

/* ---------------------------------------
	Radio & Check
----------------------------------------*/

			$radios = $idealform.find(':radio');
			$checks = $idealform.find(':checkbox');

			// Radio
			$radios.each(function () {
				$(this)
				.after('<span class="radio"></span>')
				.parents('ul').addClass('idealradio');
				if ($(this).is(':checked')) {
					$(this).next('span').addClass('checked');
				}
			}).change(function () {
				$(this).parents('ul').find('span').removeClass('checked');
				$(this).next('span').addClass('checked');
			});

			// Check
			$checks.each(function () {
				$(this)
				.after('<span class="check"></span>')
				.parents('ul').addClass('idealcheck');
				if ($(this).is(':checked')) {
					$(this).next('span').addClass('checked');
				}
			}).change(function () {
				$(this).next('span').toggleClass('checked');
			});

		});

	};
})(jQuery);