/*
 * jQuery File Upload User Interface Plugin 5.0.18
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://creativecommons.org/licenses/MIT/
 */
/*jslint white: true, nomen: true, unparam: true, regexp: true */
/*global window, document, URL, webkitURL, FileReader, jQuery */
(function ($) {
  'use strict';
  // The UI version extends the basic fileupload widget and adds
  // a complete user interface based on the given upload/download
  // templates.
  $.widget('blueimpUI.fileupload', $.blueimp.fileupload, {
    options: {
      // By default, files added to the widget are uploaded as soon
      // as the user clicks on the start buttons. To enable automatic
      // uploads, set the following option to true:
      autoUpload: false,
      // The following option limits the number of files that are
      // allowed to be uploaded using this widget:
      maxNumberOfFiles: undefined,
      // The maximum allowed file size:
      maxFileSize: undefined,
      // The minimum allowed file size:
      minFileSize: 1,
      // The regular expression for allowed file types, matches
      // against either file type or file name:
      acceptFileTypes: /.+$/i,
      // The regular expression to define for which files a preview
      // image is shown, matched against the file type:
      previewFileTypes: /^image\/(gif|jpeg|png)$/,
      // The maximum width of the preview images:
      previewMaxWidth: 80,
      // The maximum height of the preview images:
      previewMaxHeight: 80,
      // By default, preview images are displayed as canvas elements
      // if supported by the browser. Set the following option to false
      // to always display preview images as img elements:
      previewAsCanvas: true,
      // The file upload template that is given as first argument to the
      // jQuery.tmpl method to render the file uploads:
      uploadTemplate: $('#uploadTemplate'),
      // The file download template, that is given as first argument to the
      // jQuery.tmpl method to render the file downloads:
      downloadTemplate: $('#template-download'),
      // The expected data type of the upload response, sets the dataType
      // option of the $.ajax upload requests:
      dataType: 'json',
      // The add callback is invoked as soon as files are added to the fileupload
      // widget (via file input selection, drag & drop or add API call).
      // See the basic file upload widget for more information:
      add: function (e, data) {
        var that = $(this).data('fileupload');
        that._adjustMaxNumberOfFiles(-data.files.length);
        data.isAdjusted = true;
        data.isValidated = that._validate(data.files);
        data.context = that._renderUpload(data.files)
        .appendTo($(this).find('.files')).fadeIn(function () {
          // Fix for IE7 and lower:
          $(this).show();
        }).data('data', data);
        if ((that.options.autoUpload || data.autoUpload) &&
          data.isValidated) {
          data.jqXHR = data.submit();
        }
      },
      // Callback for the start of each file upload request:
      send: function (e, data) {
        if (!data.isValidated) {
          var that = $(this).data('fileupload');
          if (!data.isAdjusted) {
            that._adjustMaxNumberOfFiles(-data.files.length);
          }
          if (!that._validate(data.files)) {
            return false;
          }
        }
        if (data.context && data.dataType &&
          data.dataType.substr(0, 6) === 'iframe') {
          // Iframe Transport does not support progress events.
          // In lack of an indeterminate progress bar, we set
          // the progress to 100%, showing the full animated bar:
          data.context.find('.ui-progressbar').progressbar(
          'value',
          parseInt(100, 10)
        );
        }
      },
      // Callback for successful uploads:
      done: function (e, data) {
        var that = $(this).data('fileupload');
        if (data.context) {
          data.context.each(function (index) {
            var file = ($.isArray(data.result) &&
              data.result[index]) || {
              error: 'emptyResult'
            };
            if (file.error) {
              that._adjustMaxNumberOfFiles(1);
            }
            $(this).fadeOut(function () {
              that._renderDownload([file])
              .css('display', 'none')
              .replaceAll(this)
              .fadeIn(function () {
                // Fix for IE7 and lower:
                $(this).show();
              });
            });
          });
        } else {
          that._renderDownload(data.result)
          .css('display', 'none')
          .appendTo($(this).find('.files'))
          .fadeIn(function () {
            // Fix for IE7 and lower:
            $(this).show();
          });
        }
      },
      // Callback for failed (abort or error) uploads:
      fail: function (e, data) {
        var that = $(this).data('fileupload');
        that._adjustMaxNumberOfFiles(data.files.length);
        if (data.context) {
          data.context.each(function (index) {
            $(this).fadeOut(function () {
              if (data.errorThrown !== 'abort') {
                var file = data.files[index];
                file.error = file.error || data.errorThrown
                  || true;
                that._renderDownload([file])
                .css('display', 'none')
                .replaceAll(this)
                .fadeIn(function () {
                  // Fix for IE7 and lower:
                  $(this).show();
                });
              } else {
                data.context.remove();
              }
            });
          });
        } else if (data.errorThrown !== 'abort') {
          that._adjustMaxNumberOfFiles(-data.files.length);
          data.context = that._renderUpload(data.files)
          .css('display', 'none')
          .appendTo($(this).find('.files'))
          .fadeIn(function () {
            // Fix for IE7 and lower:
            $(this).show();
          }).data('data', data);
        }
      },
      // Callback for upload progress events:
      progress: function (e, data) {
        if (data.context) {
          data.context.find('.ui-progressbar').progressbar(
          'value',
          parseInt(data.loaded / data.total * 100, 10)
        );
        }
      },
      // Callback for global upload progress events:
      progressall: function (e, data) {
        $(this).find('.fileupload-progressbar').progressbar(
        'value',
        parseInt(data.loaded / data.total * 100, 10)
      );
      },
      // Callback for uploads start, equivalent to the global ajaxStart event:
      start: function () {
        $(this).find('.fileupload-progressbar')
        .progressbar('value', 0).fadeIn();
      },
      // Callback for uploads stop, equivalent to the global ajaxStop event:
      stop: function () {
        $(this).find('.fileupload-progressbar').fadeOut();
      },
      // Callback for file deletion:
      destroy: function (e, data) {
        var that = $(this).data('fileupload');
        if (data.url) {
          $.ajax(data)
          .success(function () {
            that._adjustMaxNumberOfFiles(1);
            $(this).fadeOut(function () {
              $(this).remove();
            });
          });
        } else {
          that._adjustMaxNumberOfFiles(1);
          data.context.fadeOut(function () {
            $(this).remove();
          });
        }
      }
    },
    // Scales the given image (img HTML element)
    // using the given options.
    // Returns a canvas object if the canvas option is true
    // and the browser supports canvas, else the scaled image:
    _scaleImage: function (img, options) {
      options = options || {};
      var canvas = document.createElement('canvas'),
      scale = Math.min(
      (options.maxWidth || img.width) / img.width,
      (options.maxHeight || img.height) / img.height
    );
      if (scale >= 1) {
        scale = Math.max(
        (options.minWidth || img.width) / img.width,
        (options.minHeight || img.height) / img.height
      );
      }
      img.width = parseInt(img.width * scale, 10);
      img.height = parseInt(img.height * scale, 10);
      if (!options.canvas || !canvas.getContext) {
        return img;
      }
      canvas.width = img.width;
      canvas.height = img.height;
      canvas.getContext('2d')
      .drawImage(img, 0, 0, img.width, img.height);
      return canvas;
    },
    _createObjectURL: function (file) {
      var undef = 'undefined',
      urlAPI = (typeof window.createObjectURL !== undef && window) ||
        (typeof URL !== undef && URL) ||
        (typeof webkitURL !== undef && webkitURL);
      return urlAPI ? urlAPI.createObjectURL(file) : false;
    },
    _revokeObjectURL: function (url) {
      var undef = 'undefined',
      urlAPI = (typeof window.revokeObjectURL !== undef && window) ||
        (typeof URL !== undef && URL) ||
        (typeof webkitURL !== undef && webkitURL);
      return urlAPI ? urlAPI.revokeObjectURL(url) : false;
    },
