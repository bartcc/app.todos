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
<div id="modal-action" class="modal fade"></div>
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
          <li class="previous {{if min}}disabled{{/if}}"><a href="#">&larr;</a></li>
          <li class="next {{if max}}disabled{{/if}}"><a href="#">&rarr;</a></li>
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
    <div class="glyphicon-set fade out" style="">
      <span class="downloading glyphicon glyphicon-download-alt glyphicon-white left fade"></span>
      <span class="zoom glyphicon glyphicon-eye-open glyphicon-white left"></span>
      <span class="back glyphicon glyphicon-chevron-up glyphicon-white left"></span>
      <span class="glyphicon delete glyphicon glyphicon-trash glyphicon-white right"></span>
    </div>
    <div class="title">{{if title}}{{html title.substring(0, 15)}}{{else}}...{{/if}}</div>
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
    <div class="title">{{if title}}${title.substring(0, 15)}{{else}}{{if src}}${src.substring(0, 15)}{{else}}no title{{/if}}{{/if}}</div>
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
  <div class="title">{{if title}}${title.substring(0, 15)}{{else}}{{if src}}${src.substring(0, 15)}{{else}}no title{{/if}}{{/if}}</div>
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
    <em><li class="empty bold">{{if title}}{{html title}}{{else}}${src}{{/if}}</li></em>
    <li class="">${src}</li>
    <li class="">iso: ${iso}</li>
    <li class="">model: ${model}</li>
    <li class="">date: ${captured}</li>
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
  <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
    <h1 class="page-header">Dashboard</h1>

    <div class="row placeholders">
      <div class="col-xs-6 col-sm-3 placeholder">
        <img data-src="holder.js/200x200/auto/sky" class="img-responsive" alt="200x200" src="data:image/png;base64,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">
        <h4>Label</h4>
        <span class="text-muted">Something else</span>
      </div>
      <div class="col-xs-6 col-sm-3 placeholder">
        <img data-src="holder.js/200x200/auto/vine" class="img-responsive" alt="200x200" src="data:image/png;base64,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">
        <h4>Label</h4>
        <span class="text-muted">Something else</span>
      </div>
      <div class="col-xs-6 col-sm-3 placeholder">
        <img data-src="holder.js/200x200/auto/sky" class="img-responsive" alt="200x200" src="data:image/png;base64,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">
        <h4>Label</h4>
        <span class="text-muted">Something else</span>
      </div>
      <div class="col-xs-6 col-sm-3 placeholder">
        <img data-src="holder.js/200x200/auto/vine" class="img-responsive" alt="200x200" src="data:image/png;base64,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">
        <h4>Label</h4>
        <span class="text-muted">Something else</span>
      </div>
    </div>

    <h2 class="sub-header">Section title</h2>
    <div class="table-responsive">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>#</th>
            <th>Header</th>
            <th>Header</th>
            <th>Header</th>
            <th>Header</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>1,001</td>
            <td>Lorem</td>
            <td>ipsum</td>
            <td>dolor</td>
            <td>sit</td>
          </tr>
          <tr>
            <td>1,002</td>
            <td>amet</td>
            <td>consectetur</td>
            <td>adipiscing</td>
            <td>elit</td>
          </tr>
          <tr>
            <td>1,003</td>
            <td>Integer</td>
            <td>nec</td>
            <td>odio</td>
            <td>Praesent</td>
          </tr>
          <tr>
            <td>1,003</td>
            <td>libero</td>
            <td>Sed</td>
            <td>cursus</td>
            <td>ante</td>
          </tr>
          <tr>
            <td>1,004</td>
            <td>dapibus</td>
            <td>diam</td>
            <td>Sed</td>
            <td>nisi</td>
          </tr>
          <tr>
            <td>1,005</td>
            <td>Nulla</td>
            <td>quis</td>
            <td>sem</td>
            <td>at</td>
          </tr>
          <tr>
            <td>1,006</td>
            <td>nibh</td>
            <td>elementum</td>
            <td>imperdiet</td>
            <td>Duis</td>
          </tr>
          <tr>
            <td>1,007</td>
            <td>sagittis</td>
            <td>ipsum</td>
            <td>Praesent</td>
            <td>mauris</td>
          </tr>
          <tr>
            <td>1,008</td>
            <td>Fusce</td>
            <td>nec</td>
            <td>tellus</td>
            <td>sed</td>
          </tr>
          <tr>
            <td>1,009</td>
            <td>augue</td>
            <td>semper</td>
            <td>porta</td>
            <td>Mauris</td>
          </tr>
          <tr>
            <td>1,010</td>
            <td>massa</td>
            <td>Vestibulum</td>
            <td>lacinia</td>
            <td>arcu</td>
          </tr>
          <tr>
            <td>1,011</td>
            <td>eget</td>
            <td>nulla</td>
            <td>Class</td>
            <td>aptent</td>
          </tr>
          <tr>
            <td>1,012</td>
            <td>taciti</td>
            <td>sociosqu</td>
            <td>ad</td>
            <td>litora</td>
          </tr>
          <tr>
            <td>1,013</td>
            <td>torquent</td>
            <td>per</td>
            <td>conubia</td>
            <td>nostra</td>
          </tr>
          <tr>
            <td>1,014</td>
            <td>per</td>
            <td>inceptos</td>
            <td>himenaeos</td>
            <td>Curabitur</td>
          </tr>
          <tr>
            <td>1,015</td>
            <td>sodales</td>
            <td>ligula</td>
            <td>in</td>
            <td>libero</td>
          </tr>
        </tbody>
      </table>
    </div>
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


