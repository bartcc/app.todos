<div id="loader" class="view">
  <div class="dialogue-wrap">
    <div class="dialogue">
      <div class="dialogue-content">
        <div class="bg transparent" style="line-height: 0.5em; text-align: center; color: #E1EEF7">
          <div class="status-symbol" style="z-index: 2;">
            <img src="/img/ajax-loader.gif" style="">
          </div>
          <div class="status-text"></div>
        </div>
      </div>
    </div>
  </div>
</div>
<div id="main" class="view vbox flex">
  <header id="title" class="">
    <div class="left" style="position: relative;">
      <h1 class="" style="line-height: 3em;"><a style="font-size: 3em;" href="/"><span class="chopin">Photo Director</span></a></h1>
      <span style="position: absolute; top: 10px; right: 67px;"><a href="http://glyphicons.com/" target="_blank" class="glyphicon-brand" title="GLYPHICONS is a library of precisely prepared monochromatic icons and symbols, created with an emphasis on simplicity and easy orientation.">GLYPHICONS.com</a></span>
    </div>
    <div id="login" class="right" style="line-height: 2em; margin: 15px 5px;"></div>
  </header>
  <div id="wrapper" class="hbox flex">
    <div id="sidebar" class="views bg-medium hbox vdraggable">
      <div class="vbox sidebar canvas flex inner" style="display: none">
        <div class="search">
          <form class="form-search">
            <input class="search-query" type="search" placeholder="Search" results="0" incremental="true">
          </form>
        </div>
        <div class="originals hbox">
          <ul class="options flex">
            <li id="" class="splitter flickr disabled"></li>
          </ul>
        </div>
        <ul class="container items vbox flex autoflow"></ul>
        <footer class="footer">
          <button class="createGallery dark">
            <i class="glyphicon glyphicon-plus"></i>
            <span>Gallery</span>
          </button>
          <button class="createAlbum dark">
            <i class="glyphicon glyphicon-plus"></i>
            <span>Album</span>
          </button>
        </footer>
      </div>
      <div class="vdivide draghandle"></div>
    </div>
    <div id="content" class="views bg-medium vbox flex">
      <div id="show" class="view canvas vbox flex">
        <div id="modal-action" class="modal fade"></div>
        <ul class="options hbox">
          <ul class="toolbarOne hbox nav"></ul>
          <li class="splitter disabled flex"></li>
          <ul class="toolbarTwo hbox nav"></ul>
        </ul>
        <div class="contents views vbox flex" style="height: 0;">
          <div class="header views">
            <div class="galleriesHeader view"></div>
            <div class="albumsHeader view"></div>
            <div class="photosHeader view"></div>
            <div class="photoHeader view"></div>
          </div>
          <div class="view galleries content vbox flex data parent autoflow" style="">
            <div class="items"></div>
          </div>
          <div class="view albums content vbox flex data parent autoflow" style="margin-top: -24px;">
            <div class="hoverinfo in"></div>
            <div class="container items flex"></div>
          </div>
          <div class="view photos content vbox flex data parent autoflow" style="margin-top: -24px;">
            <div class="hoverinfo in"></div>
            <div class="container items flex" data-toggle="modal-gallery" data-target="#modal-gallery" data-selector="a"></div>
          </div>
          <div class="view photo content vbox flex data parent autoflow" style="margin-top: -24px;">
            <div class="hoverinfo in"></div>
            <div class="container items flex">PHOTO</div>
          </div>
          <div id="slideshow" class="view content flex data parent autoflow">
            <div class="items flex" data-toggle="blueimp-gallery" data-target="#blueimp-gallery" data-selector="div.thumbnail"></div>
          </div>
        </div>
        <div id="views" class="settings bg-light hbox autoflow bg-medium">
          <div class="views canvas content vbox flex hdraggable" style="position: relative">
            <div class="hdivide draghandle">
              <span class="optClose glyphicon glyphicon-remove glyphicon glyphicon-white right"></span>
            </div>
            <div id="ga" class="view container flex autoflow" style="">
              <div class="editGallery">You have no Galleries!</div>
            </div>
            <div id="al" class="view container flex autoflow" style="">
              <div class="editAlbum">
                <div class="content">No Albums found!</div>
              </div>
            </div>
            <div id="ph" class="view container flex autoflow" style="">
              <div class="editPhoto">
                <div class="content">No Photo found!</div>
              </div>
            </div>
            <div id="fu" class="view flex canvas bg-medium autoflow" style="margin: 0px">
              <!-- The file upload form used as target for the file upload widget -->
              <form id="fileupload" action="uploads/image" method="POST" enctype="multipart/form-data">
                  <!-- Redirect browsers with JavaScript disabled to the origin page -->
                  <noscript><input type="hidden" name="redirect" value="http://blueimp.github.io/jQuery-File-Upload/"></noscript>
                  <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
                  <div class="">
                    <!-- The table listing the files available for upload/download -->
                    <div class="canvas bg-medium fileupload-buttonbar" style="z-index: 2; position: fixed; width: 100%;">
                      <div class="span6 left" style="margin: 10px;">
                            <!-- The fileinput-button span is used to style the file input field as button -->
                            <span class="btn dark fileinput-button">
                                <i class="glyphicon glyphicon-plus"></i>
                                <span>Add files...</span>
                                <input type="file" name="files[]" multiple>
                            </span>
                            <button type="submit" class="dark start">
                                <i class="glyphicon glyphicon-upload"></i>
                                <span>Start upload</span>
                            </button>
                            <button type="reset" class="dark cancel">
                                <i class="glyphicon glyphicon-ban-circle"></i>
                                <span>Cancel upload</span>
                            </button>
                            <button type="button" class="dark delete">
                                <i class="glyphicon glyphicon-remove"></i>
                                <span>Clear List</span>
                            </button>
                            <!-- The loading indicator is shown during file processing -->
                            <span class="fileupload-loading"></span>
                        </div>
                        <!-- The global progress information -->
                        <div class="span3 fileupload-progress fade left" style="width: 260px; margin: 14px;">
                            <!-- The global progress bar -->
                            <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                                <div class="progress-bar" style="width:0%;"></div>
                            </div>
                        </div>
                    </div>
                    <div class="autoflow" style="top: 74px; position: relative; z-index: 1;">
                      <table role="presentation" class="table"><tbody class="files"></tbody></table>
                    </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      <div id="overview" class="canvas view content vbox flex data parent autoflow">
        <ul class="options">
          <li class="splitter disabled flex"></li>
          <li class="optClose right" style="position: relative; top: 8px; right: 8px;"><span class="glyphicon glyphicon-remove glyphicon glyphicon-white"></span></li>
        </ul>
        <div class="flex vbox">
          <div class="container canvas bg-medium clearfix">
            <fieldset>
              <label><span class="enlightened">Recently Uploaded:</span></label>
              <div class="items"></div>
            </fieldset>
            <fieldset>
              <label><span class="enlightened">Summary:</span></label>
              <div class="info"></div>
            </fieldset>
          </div>
          <div class="container">
            <fieldset>
              <label><span class="enlightened">Informations:</span></label>
            </fieldset>
          </div>
        </div>
      </div>
      <div id="edit" class="canvas view vbox flex">
        <ul class="options hbox">
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="content container vbox flex autoflow"></div>
      </div>
      <div id="flickr" class="canvas view vbox flex">
        <ul class="options hbox">
          <li class="splitter flex"></li>
          <ul class="toolbar hbox nav"></ul>
          <li class="splitter flex"></li>
        </ul>
        <div class="content links vbox flex autoflow"></div>
      </div>
      
    </div>
  </div>
</div>
<!-- blueimp-gallery -->
<div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls">
  <div class="slides"></div>
    <h3 class="title"></h3>
    <a class="prev">‹</a>
    <a class="next">›</a>
    <a class="close">×</a>
    <a class="play-pause"></a>
    <ol class="indicator"></ol>
</div>
<!-- modal-dialogue -->
<div id="modal-view" class="modal fade"></div>
<!-- /.modal -->

<!-- Templates -->
<script id="flickrTemplate" type="text/x-jquery-tmpl">
  <a href='http://farm${farm}.static.flickr.com/${server}/${id}_${secret}_b.jpg' title="${title}" data-gallery>
    <img src='http://farm${farm}.static.flickr.com/${server}/${id}_${secret}_s.jpg'>
  </a>
</script>

<script id="modalActionTemplate" type="text/x-jquery-tmpl">
  <form>
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <ul class="pager">
          <li class="previous {{if min}}disabled{{/if}}"><a href="#">Reset List</a></li>
        </ul>
        <h4 class="modal-title">${text}</h4>
      </div>
      <div class="modal-body autoflow">
        <div class="row">
          <div class="col-md-6 galleries">
            <div class="list-group">
            {{tmpl($item.data.galleries()) "#modalActionColTemplate"}}
            </div>
          </div>
          <div class="col-md-6 albums">
            <div class="list-group">
            {{tmpl($item.data.albums()) "#modalActionColTemplate"}}
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="optCreateGallery btn btn-default">New Gallery</button>
        <button type="button" class="optCreateAlbum btn btn-default" {{if type == 'Gallery'}}disabled{{/if}}>New Album</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="copy btn btn-primary">Copy</button>
        <label class="hide">
        <input type="checkbox" class="remove">remove original items when done</label>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
  </form>
</script>

<script id="modalActionColTemplate" type="text/x-jquery-tmpl">
  {{tmpl($item.data.items) "#modalActionContentTemplate"}}
</script>

<script id="modalActionContentTemplate" type="text/x-jquery-tmpl">
  <a class="list-group-item item" id="${id}">{{if name}}${name}{{else}}${title}{{/if}}</a>
</script>

<script id="modalSimpleTemplate" type="text/x-jquery-tmpl">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>${header}</h3>
      </div>
      <div class="modal-body">
        <p>${body}</p>
      </div>
      {{if info}}
      <div class="modal-header label-info">
        <div class="label label-info">${info}</div>
      </div>
      {{/if}}
      <div class="modal-footer">
        <button class="btn btnClose">Ok</button>
      </div>
    </div>
  </div>
</script>

<script id="modal2ButtonTemplate" type="text/x-jquery-tmpl">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>${header}</h3>
      </div>
      <div class="modal-body content">
        <ul class="items">
          ${body}
        </ul>
      </div>
      {{if info}}
      <div class="modal-header">
        <div class="label label-warning">${info}</div>
      </div>
      {{/if}}
      <div class="modal-footer">
        <button class="btn btnOk" data-dismiss="modal" aria-hidden="true">${button_1_text}</button>
        <button type="button" class="btn btnAlt">${button_2_text}</button>
      </div>
    </div>
  </div>
</script>

<script id="sidebarTemplate" type="text/x-jquery-tmpl">
  <li class="gal item data parent" title="" draggable="true">
    <div class="item-header">
      <div class="expander"></div>
      {{tmpl "#sidebarContentTemplate"}}
    </div>
    <hr>
    <ul class="sublist" style="display: none;"></ul>
  </li>
</script>

<script id="sidebarContentTemplate" type="text/x-jquery-tmpl">
  <div class="item-content">
    {{if name}}
    <span class="name">${name}</span>
    {{else}}
    <span class="name empty">no name</span>
    {{/if}}
<!--    <span class="author info">{{if author}} by ${author}{{else}}(no author){{/if}}</span>-->
    <span class="gal cta">{{tmpl($item.data.details()) "#galleryDetailsTemplate"}}</span>
  </div>
</script>

<script id="sidebarFlickrTemplate" type="text/x-jquery-tmpl">
  <li class="gal item data parent" title="" draggable="true">
    <div class="item-header">
      <div class="expander"></div>
        <div class="item-content">
          <span class="name">${name}</span>
        </div>
    </div>
    <hr>
    <ul class="sublist" style="display: none;">
      {{tmpl($item.data.sub) "#sidebarFlickrSublistTemplate"}}
    </ul>
  </li>
</script>

<script id="sidebarFlickrSublistTemplate" type="text/x-jquery-tmpl">
  <li class="sublist-item item item-content ${klass}">
    <span class="glyphicon glyphicon-${icon}"></span>
    <span class="">${name}</span>
  </li>
</script>

<script id="galleryDetailsTemplate" type="text/x-jquery-tmpl">
    <span>${aCount} </span><span style="font-size: 0.6em;"> (${iCount})</span>
</script>

<script id="galleriesTemplate" type="text/x-jquery-tmpl">
  <li class="item container fade in">
    <div class="ui-symbol ui-symbol-gallery center"></div>
    <div class="thumbnail" draggable="true">
      <div class="inner">
        {{tmpl($item.data.details()) "#galDetailsTemplate"}}
      </div>
    </div>
    <div class="glyphicon-set fade out" style="">
      <span class="delete glyphicon glyphicon-trash glyphicon-white right"></span>
      <span class="back glyphicon glyphicon-chevron-up glyphicon-white right"></span>
      <span class="zoom glyphicon glyphicon-eye-open glyphicon-white right"></span>
    </div>
    <div class="title">{{if name}}{{html name}}{{else}}no name{{/if}}</div>
  </li>
</script>

<script id="modalGalleriesActionTemplate" type="text/x-jquery-tmpl">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>${header}</h3>
  </div>
  <div class="modal-body content">
    <div class="container item btn-group" data-toggle="buttons">
      {{tmpl($item.data.body) "#galleryActionTemplate"}}
    </div>
  </div>
  <div class="modal-footer">
    {{if info}}
    <div class="left label label-warning">${info}</div>
    {{/if}}
    <button class="btn btnOk" data-dismiss="modal" aria-hidden="true">OK</button>
    <button type="button" class="btn btnAlt">Save changes</button>
  </div>
</script>

<script id="galleryActionTemplate" type="text/x-jquery-tmpl">
  <label class="btn btn-primary">
    <input type="radio" name="options" id="option1">${name}
  </label>
</script>

<script id="defaultActionTemplate" type="text/x-jquery-tmpl">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>${header}</h3>
  </div>
  <div class="modal-body content">
  {{if body}}
    {{html body}}
  {{/if}}
  </div>
  {{if info}}
  <div class="modal-header">
    <div class="label label-warning">${info}</div>
  </div>
  {{/if}}
  <div class="modal-footer">
    <button class="btn btnOk" data-dismiss="modal" aria-hidden="true">OK</button>
    <button type="button" class="btn btnAlt">Save changes</button>
  </div>
</script>

<script id="galDetailsTemplate" type="text/x-jquery-tmpl">
  <div style="font-size: 0.8em; font-style: oblique; ">Albums: ${aCount}</div>
  <div style="font-size: 0.8em; font-style: oblique; ">Images: ${iCount}</div>
  {{if sCount}}
  <div style="font-size: 0.8em; font-style: oblique; "><span class="label label-default">Slideshow Images: ${sCount}</span></div>
  <div style="font-size: 0.8em; font-style: oblique; ">(press space to play)</div>
  {{/if}}
</script>

<script id="editGalleryTemplate" type="text/x-jquery-tmpl">
  <div class="editGallery">
    <div class="galleryEditor">
      <label>
        <span class="enlightened">Gallery - Name</span>
      </label>
      <br>
      <input class="name" data-toggle="tooltip" placeholder="gallery name" data-placement="right" data-trigger="manual" data-title="Press Enter to save" data-content="${name}" type="text" name="name" value="${name}">
      <br>
      <br>
      <label>
        <span class="enlightened">Description</span>
      </label>
      <br>
      <textarea name="description">${description}</textarea>
    </div>
  </div>
</script>

<script id="albumsTemplate" type="text/x-jquery-tmpl">
  <li class="item container fade in sortable">
    <div class="ui-symbol ui-symbol-album center"></div>
    <div class="thumbnail left"></div>
    <div class="title">{{if title}}{{html title.substring(0, 15)}}{{else}}...{{/if}}</div>
    <div class="glyphicon-set fade out" style="">
      <span class="downloading glyphicon glyphicon-download-alt glyphicon-white left fade"></span>
      <span class="zoom glyphicon glyphicon-eye-open glyphicon-white left"></span>
      <span class="back glyphicon glyphicon-chevron-up glyphicon-white left"></span>
      <span class="glyphicon delete glyphicon glyphicon-trash glyphicon-white right"></span>
    </div>
  </li>
</script>

<script id="editAlbumTemplate" type="text/x-jquery-tmpl">
  <label class="">
    <span class="enlightened">Album Title</span>
  </label>
  <br>
  <input placeholder="album title" type="text" name="title" value="${title}" {{if newRecord}}autofocus{{/if}}>
  <br>
  <br>
  <label class="">
    <span class="enlightened">Description</span>
  </label>
  <br>
  <textarea name="description">${description}</textarea>
</script>

<script id="albumSelectTemplate" type="text/x-jquery-tmpl">
  <option {{if ((constructor.record) && (constructor.record.id == id))}}selected{{/if}} value="${id}">${title}</option>
</script>

<script id="headerGalleryTemplate" type="text/x-jquery-tmpl">
  <section class="top viewheader z2" style="padding-top: 15px; height: 78px;">
    <h2>Gallery Overview</h2><span class="active cta right"><h2>${count}</h2></span>
  </section>
</script>

<script id="headerAlbumTemplate" type="text/x-jquery-tmpl">
  <section class="top viewheader z2 {{if record == ''}}red{{/if}}">
    {{if record}}
    Author:   <span class="label label-default">${author}</span>
    <br><br>
    <h2>Gallery: </h2>
    <label class="h2 chopin">{{if record.name}}${record.name}{{else}}no name{{/if}}</label>
      <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    {{else}}
    <h2 class="">Master Albums
      <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{/if}}
  </section>
  <section class="left">
    <span class="breadcrumb">
      <li class="gal">
        <a href="#">Galleries</a>
      </li>
      <li class="alb active">Albums</li>
    </span>
  </section>
  <section class="right">
    <span class="breadcrumb move">
      <li class="optAlbumActionCopy">
        <a href="#"><i class="glyphicon glyphicon-share-alt"></i>Copy</a>
      </li>
    </span>
  </section>
</script>

<script id="albumDetailsTemplate" type="text/x-jquery-tmpl">
  <span class="cta">${iCount}</span>
</script>

<script id="albumsSublistTemplate" type="text/x-jquery-tmpl">
  {{if flash}}
  <span class="author">${flash}</span>
  {{else}}
  <li class="sublist-item alb item data" draggable="true" title="move (Hold Cmd-Key to Copy)">
    <span class="glyphicon glyphicon-folder-close ui-symbol-album"></span>
    <span class="title">{{if title}}{{html title}}{{else}}no title{{/if}}</span>
    <span class="cta">{{if count}}${count}{{else}}0{{/if}}</span>
  </li>
  {{/if}}
</script>

<script id="albumInfoTemplate" type="text/x-jquery-tmpl">
  <ul>
    <li class="name bold">
      <span class="left">{{if title}}${title}{{else}}no title{{/if}} </span>
      <span class="right"> {{tmpl($item.data.details()) "#albumDetailsTemplate"}}</span>
    </li>
  </ul>
</script>

<script id="photosDetailsTemplate" type="text/x-jquery-tmpl">
  Author:  <span class="label label-default">${author}</span>
  Gallery:  <span class="label label-default">{{if gallery}}{{if gallery.name}}${gallery.name}{{else}}no name{{/if}}{{else}}not found{{/if}}</span>
  <br><br>
  <h2>Album: </h2>
  <label class="h2 chopin">{{if album.title}}${album.title}{{else}}no title{{/if}}</label>
  <span class="active cta right">
    <h2>{{if iCount}}${iCount}{{else}}0{{/if}}</h2>
  </span>
  
</script>

<script id="photoDetailsTemplate" type="text/x-jquery-tmpl">
  Author:  <span class="label label-default">{{if author}}${author}{{/if}}</span>
  Gallery:  <span class="label label-default">{{if gallery}}{{if gallery.name}}${gallery.name}{{else}}no name{{/if}}{{else}}not found{{/if}}</span>
  Album:  <span class="label label-default">{{if album}}{{if album.title}}${album.title}{{else}}no title{{/if}}{{else}}not found{{/if}}</span>
  <br><br>
  <h2>Photo:  </h2>
  <label class="h2 chopin">
    {{if photo}}
    {{if photo.title}}${photo.title}{{else}}{{if photo.src}}${photo.src}{{else}}no title{{/if}}{{/if}}
    {{else}}
    deleted
    {{/if}}
  </label>
</script>

<script id="editPhotoTemplate" type="text/x-jquery-tmpl">
  <label class="">
    <span class="enlightened">Photo Title</span>
  </label>
  <br>
  <input placeholder="${src}" type="text" name="title" value="{{if title}}${title}{{else}}{{if src}}${src}{{/if}}{{/if}}" >
  <br>
  <br>
  <label class="">
    <span class="enlightened">Description</span>
  </label>
  <br>
  <textarea name="description">${description}</textarea>
</script>

<script id="photosTemplate" type="text/x-jquery-tmpl">
  <li  class="item data container fade in sortable">
    {{tmpl "#photosThumbnailTemplate"}}
    <div class="title hide">{{if title}}${title.substring(0, 15)}{{else}}{{if src}}${src.substring(0, 15)}{{else}}no title{{/if}}{{/if}}</div>
  </li>
</script>

<script id="photosSlideshowTemplate" type="text/x-jquery-tmpl">
  <li  class="item data fade in">
    <div class="thumbnail container image left"></div>
  </li>
</script>

<script id="photoTemplate" type="text/x-jquery-tmpl">
  <li class="item container fade in">
    {{tmpl "#photoThumbnailTemplate"}}
  </li>
</script>

<script id="photosThumbnailTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left fade in" draggable="true"></div>
  <div class="glyphicon glyphicon-set fade out" style="">
    <span class="delete glyphicon glyphicon-trash glyphicon-white right"></span>
    <span class="back glyphicon glyphicon-chevron-up glyphicon-white right"></span>
    <span class="zoom glyphicon glyphicon-eye-open glyphicon-white right"></span>
  </div>
</script>

<script id="photoThumbnailTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left fade in" draggable="true"></div>
  <div class="glyphicon glyphicon-set fade out" style="">
    <span class="back glyphicon glyphicon-chevron-up glyphicon-white right"></span>
  </div>
  <div class="title hide">{{if title}}${title.substring(0, 15)}{{else}}{{if src}}${src.substring(0, 15)}{{else}}no title{{/if}}{{/if}}</div>
</script>

<script id="photoThumbnailSimpleTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left" draggable="true"></div>
</script>

<script id="headerPhotosTemplate" type="text/x-jquery-tmpl">
  <section class="top viewheader z2 {{if album == ''}}red{{/if}}">
    {{if album}}
      {{tmpl($item.data.album.details()) "#photosDetailsTemplate"}}
    {{else}}
<!--    <div class="alert alert-error"><h4 class="alert-heading">Note</h4>Drag your selected photos on to an album in the sidebar to become part of it. Wait to reveal its albums, if necessary.</div>-->
    <h2>Master Photos
      <span class="active cta right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{/if}}
  </section>
  <section class="left">
    <span class="breadcrumb">
      <li class="gal">
        <a href="#">Galleries</a>
      </li>
      <li class="alb">
        <a href="#">Albums</a>
      </li>
      <li class="pho active">Photos</li>
    </span>
  </section>
  <section class="right">
    <span class="breadcrumb move">
      <li class="optPhotoActionCopy">
        <span class="">
          <a href="#"><i class="glyphicon glyphicon-share-alt"></i>Copy</a>
        </span>
      </li>
    </span>
  </section>
</script>

<script id="headerPhotoTemplate" type="text/x-jquery-tmpl">
  <section class="top viewheader z2">
    {{if $item.data.details}}{{tmpl($item.data.details()) "#photoDetailsTemplate"}}{{/if}}
  </section>
  <section class="left">
    <span class="breadcrumb">
      <li class="gal">
        <a href="#">Galleries</a>
      </li>
      <li class="alb">
        <a href="#">Albums</a>
      </li>
      <li class="pho">
        <a href="#">Photos</a>
      </li>
      <li class="active">{{if src}}${src}{{else}}deleted{{/if}}</li>
    </span>
  </section>
  <section class="right">
    <span class="breadcrumb move">
      <li class="optAction">
        <span class="">
          <a href="#"><i class="glyphicon glyphicon-share-alt"></i>Copy</a>
        </span>
      </li>
    </span>
  </section>
</script>

<script id="preloaderTemplate" type="text/x-jquery-tmpl">
  <div class="preloader">
    <div class="content">
      <div></div
    </div>
  </div>
</script>

<script id="photoInfoTemplate" type="text/x-jquery-tmpl">
  <ul>
    <li class="">{{if title}}{{html title}}{{else}}${src}{{/if}}</li>
    <li class="">{{if iso}}iso&nbsp;&nbsp;: ${iso}{{/if}}</li>
    <li class="">{{if model}}model: ${model}{{/if}}</li>
    <li class="">{{if captured}}date : ${captured}{{/if}}</li>
  </ul>
</script>

<script id="toolsTemplate" type="text/x-jquery-tmpl">
  {{if dropdown}}
    {{tmpl(itemGroup)  "#dropdownTemplate"}}
  {{else}}
  <li class="${klass}"{{if outerstyle}} style="${outerstyle}"{{/if}}{{if id}} id="${id}"{{/if}}>
    <{{if type}}${type} class="tb-name {{if innerklass}}${innerklass}{{/if}}"{{else}}button class="dark {{if innerklass}}${innerklass}{{/if}}" {{if dataToggle}} data-toggle="${dataToggle}"{{/if}}{{/if}}
    {{if innerstyle}} style="${innerstyle}"{{/if}}
    {{if disabled}}disabled{{/if}}>
    {{if icon}}<i class="glyphicon glyphicon-${icon}  {{if iconcolor}}glyphicon glyphicon-${iconcolor}{{/if}}"></i>{{/if}}{{html name}}
    </{{if type}}${type}{{else}}button{{/if}}>
  </li>
  {{/if}}
</script>

<script id="dropdownTemplate" type="text/x-jquery-tmpl">
  <li class="dropdown" {{if id}} id="${id}"{{/if}} >
    <a class="dropdown-toggle" data-toggle="dropdown">
      {{html name}}
      <b class="caret"></b>
    </a>
    <ul class="dropdown-menu">
      {{tmpl(content) "#dropdownListItemTemplate"}}
    </ul>
  </li>
</script>

<script id="dropdownListItemTemplate" type="text/x-jquery-tmpl">
  {{if devider}}
  <li class="divider"></li>
  {{else}}
  <li><a {{if dataToggle}} data-toggle="${dataToggle}"{{/if}} class="${klass} {{if disabled}}disabled{{/if}}"><i class="glyphicon glyphicon-{{if icon}}${icon} {{if iconcolor}}glyphicon glyphicon-${iconcolor}{{/if}}{{/if}}"></i>${name}</a></li>
  {{/if}}
</script>

<script id="testTemplate" type="text/x-jquery-tmpl">
  {{if eval}}{{tmpl($item.data.eval()) "#testTemplate"}}{{/if}}
</script>

<script id="noSelectionTemplate" type="text/x-jquery-tmpl">
  {{html type}}
</script>

<script id="loginTemplate" type="text/x-jquery-tmpl">
  <button data-active="active..." data-loading="loading..." data-complete="completed..." class="dark clear logout" title="Group ${groupname}">
    <i class="glyphicon glyphicon-log-out"></i>
    <span>Logout ${name}</span>
  </button>
</script>

<script id="overviewTemplate" type="text/x-jquery-tmpl">
  <div class="item">
    {{tmpl "#photoThumbnailSimpleTemplate"}}
  </div>
</script>

<script id="fileuploadTemplate" type="text/x-jquery-tmpl">
  <span style="font-size: 0.6em;" class=" alert alert-success">
    <span style="font-size: 2.9em; font-family: cursive; margin-right: 20px;" class="alert alert-error">"</span>
    {{if album}}{{if album.title}}${album.title}{{else}}no title{{/if}}{{else}}all photos{{/if}}
    <span style="font-size: 5em; font-family: cursive;  margin-left: 20px;" class="alert alert-block uploadinfo"></span>
  </span>
</script>

<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade dark">
        <td>
            <span class="preview"></span>
        </td>
        <td>
            <p class="name">{%=file.name%}</p>
            {% if (file.error) { %}
                <div><span class="label label-important">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
        <td>
            <p class="size">{%=o.formatFileSize(file.size)%}</p>
            {% if (!o.files.error) { %}
                <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar" style="width:0%;"></div></div>
            {% } %}
        </td>
        <td>
            {% if (!o.files.error && !i && !o.options.autoUpload) { %}
                <button class="dark start">
                    <i class="glyphicon glyphicon-upload"></i>
                    <span>Start</span>
                </button>
            {% } %}
            {% if (!i) { %}
                <button class="dark cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>Cancel</span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade dark">
        <td>
            <button class="dark delete" data-type="{%=file.delete_type%}" data-url="{%=file.delete_url%}"{% if (file.delete_with_credentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                <i class="glyphicon glyphicon-remove"></i>
                <span></span>
            </button>
        </td>
        <td>
            <span class="preview">
                {% if (file.thumbnail_url) { %}
                    <a href="{%=file.url%}" title="{%=file.name%}" class="gallery" download="{%=file.name%}"><img src="{%=file.thumbnail_url%}"></a>
                {% } %}
            </span>
        </td>
        <td>
            <p class="name">
                <a href="{%=file.url%}" title="{%=file.name%}" class="{%=file.thumbnail_url?'gallery':''%}" download="{%=file.name%}">{%=file.name%}</a>
            </p>
            {% if (file.error) { %}
                <div><span class="label label-important">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
        <td>
            <span class="size">{%=o.formatFileSize(file.size)%}</span>
        </td>
    </tr>
{% } %}
</script>


