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
    <div id="login" class="right" style="margin: 15px 5px;"></div>
  </header>
  <div id="wrapper" class="hbox flex">
    <div id="sidebar" class="views bg-medium hbox vdraggable">
      <div class="vbox sidebar canvas bg-dark flex inner" style="display: none">
        <div class="search">
          <form class="form-search">
            <input class="search-query" type="search" placeholder="Search" results="0" incremental="true">
          </form>
        </div>
        <div class="originals hbox">
          <ul class="opt-ions flex">
            <li id="" class="splitter flickr noborder disabled"></li>
          </ul>
        </div>
        <ul class="items vbox flex autoflow"></ul>
        <footer class="footer">
          <button class="opt-Refresh dark left">
            <i class="glyphicon glyphicon-repeat" style="line-height: 1.5em;"></i>
            <span></span>
          </button>
          <button class="opt-CreateGallery dark">
            <i class="glyphicon glyphicon-plus"></i>
            <span>Gallery</span>
          </button>
          <button class="opt-CreateAlbum dark">
            <i class="glyphicon glyphicon-plus"></i>
            <span>Album</span>
          </button>
        </footer>
      </div>
      <div class="vdivide draghandle"></div>
    </div>
    <div id="content" class="views bg-medium vbox flex">
      <div id="show" class="view canvas bg-dark vbox flex fade">
        <div id="modal-action " class="modal fade"></div>
        <div id="modal-addAlbum" class="modal fade"></div>
        <div id="modal-addPhoto" class="modal fade"></div>
        <ul class="options hbox">
          <ul class="toolbarOne hbox nav"></ul>
          <li class="splitter disabled flex"></li>
          <ul class="toolbarTwo hbox nav"></ul>
        </ul>
        <div tabindex="1" class="contents views vbox flex deselector" style="height: 0;">
          <div class="header views">
            <div class="galleries view"></div>
            <div class="albums view"></div>
            <div class="photos view"></div>
            <div class="photo view"></div>
            <div class="overview view"></div>
          </div>
          <div class="view wait content vbox flex autoflow" style=""></div>
          <div tabindex="1" class="view deselector galleries content vbox flex data parent autoflow" style="">
            <div class="items deselector fadein">Galleries</div>
          </div>
          <div tabindex="1" class="view deselector albums content vbox flex data parent autoflow fadeelement" style="margin-top: -27px;">
            <div class="hoverinfo fadeslow"></div>
            <div class="items deselector flex fadein">Albums</div>
          </div>
          <div tabindex="1" class="view deselector photos content vbox flex data parent autoflow fadeelement" style="margin-top: -27px;">
            <div class="hoverinfo fadeslow"></div>
            <div class="items deselector flex fadein" data-toggle="modal-gallery" data-target="#modal-gallery" data-selector="a">Photos</div>
          </div>
          <div tabindex="1" class="view photo content vbox flex data parent autoflow fadeelement" style="margin-top: -27px;">
            <div class="hoverinfo fadeslow"></div>
            <div class="items flex fadein">Photo</div>
          </div>
          <div tabindex="1" id="slideshow" class="view content vbox flex data parent autoflow">
            <div class="items flex" data-toggle="blueimp-gallery" data-target="#blueimp-gallery" data-selector="a.thumbnail"></div>
          </div>
        </div>
        <div id="views" class="settings bg-light hbox autoflow bg-medium">
          <div class="views canvas content vbox flex autoflow hdraggable" style="position: relative">
            <div class="hdivide draghandle">
              <span class="opt opt-CloseDraghandle glyphicon glyphicon-resize-vertical glyphicon glyphicon-white right" style="cursor: pointer;"></span>
            </div>
            <div id="ga" class="view flex autoflow" style=""></div>
            <div id="al" class="view flex autoflow" style=""></div>
            <div id="ph" class="view flex autoflow" style=""></div>
            <div id="fu" class="view hbox flex bg-dark" style="margin: 0px">
              <!-- The file upload form used as target for the file upload widget -->
              <form id="fileupload" class="vbox flex" action="uploads/image" method="POST" enctype="multipart/form-data">
                  <!-- Redirect browsers with JavaScript disabled to the origin page -->
                  <noscript><input type="hidden" name="redirect" value="http://blueimp.github.io/jQuery-File-Upload/"></noscript>
                  <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
                  <div class="vbox flex">
                    <!-- The table listing the files available for upload/download -->
                    <div class="footer fileupload-buttonbar" style="">
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
                    <div class="vbox flex autoflow" style="">
                      <table role="presentation" class="table"><tbody class="files"></tbody></table>
                    </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      <div id="overview" class="view content vbox flex data parent fade" style="position: relative;">
        <div class="carousel-background bg-medium flex" style="z-index: 0;">
<!--          The data-ride="carousel" attribute is used to mark a carousel as animating starting at page load.-->
<!--          We can't use it here, since it must be triggered via the controller-->
          <div tabindex="3" id="overview-carousel" class="carousel slide" data-ride="">
            
            <!-- Indicators -->
            <ol class="carousel-indicators">
              <li data-target="#overview-carousel" data-slide-to="0"></li>
              <li data-target="#overview-carousel" data-slide-to="1"></li>
            </ol>
            <div class="carousel-inner"></div>
            <!-- Controls -->
            <a class="left carousel-control" href="#overview-carousel" data-slide="prev">
              <span class="glyphicon glyphicon-chevron-left"></span>
            </a>
            <a class="right carousel-control" href="#overview-carousel" data-slide="next">
              <span class="glyphicon glyphicon-chevron-right"></span>
            </a>
          </div>
          <div class="xxl" style="color: rgba(156, 156, 156, 0.99);">
            Overview
            <div style="font-size: 0.3em; color: rgba(156, 156, 156, 0.59); line-height: 30px;">hit space (play/pause) or arrow keys (navigate)</div>
          </div>
        </div>
        <div style="z-index: 1000; position: absolute; right: 0px; top: 0px; margin: 0;">
          <button type="button" class="close white" data-dismiss="modal" aria-hidden="true" style="padding: 8px;">&times;</button>
        </div>
      </div>
      <div id="missing" class="canvas view vbox flex fade">
        <ul class="options hbox">
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="content vbox flex autoflow"></div>
      </div>
      <div id="flickr" class="canvas view vbox flex fade" style="position: relative;">
        <ul class="options hbox">
          <li class="splitter flex"></li>
          <ul class="toolbar hbox nav"></ul>
          <li class="splitter flex"></li>
        </ul>
        <div class="content links vbox flex autoflow"></div>
        <div style="z-index: 1000; position: absolute; right: 0px; top: 0px; margin: 0;">
          <button type="button" class="close white" data-dismiss="modal" aria-hidden="true" style="padding: 8px;">&times;</button>
        </div>
      </div>
      
    </div>
  </div>
</div>
<!-- blueimp-gallery -->
<div tabindex="1" id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls">
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

<script id="flickrIntroTemplate" type="text/x-jquery-tmpl">
  <div class="dark xxl">
    <i class="glyphicon glyphicon-picture"></i>
    <span class="cover-header">flickr</span>
    <div class=" btn-primary xs">
      <a class="label recent ">flickr recent</a>
      <a class="label inter">flickr interesting</a>
    </div>
  </div>
</script>

<script id="addTemplate" type="text/x-jquery-tmpl">
  <div class="modal-dialog ${type}" style="width: 55%;">
    <div class="bg-dark content modal-content">
      <div class="modal-header">
        <h4 class="modal-title">${title}</h4>
      </div>
      <div class="modal-body autoflow">
        <div class="items flex fadein in"></div>
      </div>
      <div class="modal-footer">
        {{tmpl() "#footerTemplate"}}
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</script>


<script id="footerTemplate" type="text/x-jquery-tmpl">
  <div class="btn-group left">
    <button type="button" class="opt-SelectInv dark {{if !contains}}disabled{{/if}}">Invert</button>
    <button type="button" class="opt-SelectAll dark {{if !contains}}disabled{{/if}}">All</button>
  </div>
  <div class="btn-group right">
    <button type="button" class="opt-AddExecute dark {{if disabled}}disabled{{/if}}">Add</button>
    <button type="button" class="opt- dark" data-dismiss="modal">Cancel</button>
  </div>
</script>

<script id="modalActionTemplate" type="text/x-jquery-tmpl">
  <form>
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <ul class="pager">
          <li class="refresh previous {{if min}}disabled{{/if}}"><a href="#">Refresh List</a></li>
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
        <button type="button" class="opt-CreateGallery btn-default">New Gallery</button>
        <button type="button" class="opt-CreateAlbum btn-default" {{if type == 'Gallery'}}disabled{{/if}}>New Album</button>
        <button type="button" class="btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="copy btn-default">Copy</button>
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
  <div class="modal-dialog {{if small}}modal-sm{{else}}modal-lg{{/if}}">
    <div class="modal-content bg-dark">
      <div class="modal-header dark">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>${header}</h3>
      </div>
      <div class="modal-body dark" style="text-align: center;">
        <img src="/img/keyboard.png">
      </div>
      {{if info}}
      <div class="modal-header label-info dark">
        <div class="label label-info">${info}</div>
      </div>
      {{/if}}
      <div class="modal-footer dark">
        <div class="left" style="text-align: left;"> {{html footer}}</div>
        <button class="btn btnClose dark">Ok</button>
      </div>
    </div>
  </div>
</script>

<script id="modalSimpleTemplateBody" type="text/x-jquery-tmpl">
  <div>test</div>
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
  <li data-id="${id}" class="gal gal-trigger-edit item data parent">
    <div class="item-header">
      <div class="expander"></div>
      {{tmpl "#sidebarContentTemplate"}}
    </div>
    <hr>
    <ul class="sublist" style=""></ul>
  </li>
</script>

<script id="sidebarContentTemplate" type="text/x-jquery-tmpl">
  <div class="item-content">
    <span class="name">{{if name}}${name.slice(0, 15)}{{else}}${title.slice(0, 15)}{{/if}}</span>
    <span class="gal cta gal-trigger-edit">{{tmpl($item.data.details()) "#galleryDetailsTemplate"}}</span>
  </div>
</script>

<script id="sidebarFlickrTemplate" type="text/x-jquery-tmpl">
  <li class="gal item parent" title="">
    <div class="item-header">
      <div class="expander"></div>
        <div class="item-content">
          <span class="" style="color: rgba(255,255,255, 1); text-shadow: 0 -1px 0 rgba(0,0,0,0.9); font-size: 1.5em;">${name}</span>
        </div>
    </div>
    <hr>
    <ul class="sublist" style="">
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

<script id="overviewHeaderTemplate" type="text/x-jquery-tmpl">
</script>

<script id="galleryDetailsTemplate" type="text/x-jquery-tmpl">
    <span>${aCount} </span><span style="font-size: 0.6em;"> (${iCount})</span>
</script>

<script id="galleriesTemplate" type="text/x-jquery-tmpl">
  <li id="${id}" data-id="${id}" class="item container data fade in gal-trigger-edit" data-drag-over="thumbnail">
    <div class="thumbnail">
      <div class="inner">
        {{tmpl($item.data.details()) "#galDetailsTemplate"}}
      </div>
    </div>
    <div class="glyphicon-set fade out" style="">
      <span class="delete glyphicon glyphicon-trash glyphicon-white right"></span>
      <span class="back glyphicon glyphicon-chevron-up glyphicon-white right"></span>
      <span class="zoom glyphicon glyphicon-folder-close glyphicon-white right"></span>
    </div>
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

<script id="missingViewTemplate" type="text/x-jquery-tmpl">
  <div class="dark xxl">
    <i class="glyphicon glyphicon-question-sign"></i>
    <span class="cover-header">404</span><span>Not Found Error</span>
    <div class=" btn-primary xs">
      <a class="label relocate">Proceed to Overview (or use TAB for sidebar)</a>
    </div>
  </div>
</script>

<script id="galDetailsTemplate" type="text/x-jquery-tmpl">
  <div style="">{{if name}}${name.slice(0, 15)}{{else}}...{{/if}}</div>
  <div style="font-size: 0.8em; font-style: oblique;">Albums: ${aCount}</div>
  <div style="font-size: 0.8em; font-style: oblique;">Images: ${iCount}</div>
  <div class="opt-SlideshowPlay" style="">
    <span class="label label-default">
    <i class="glyphicon glyphicon-picture"></i><i class="glyphicon glyphicon-play"></i>
    ${pCount}
    </span>
  </div>
  {{if pCount}}
  <div class="hide" style="font-size: 0.8em; font-style: oblique; ">hit space to play</div>
  {{/if}}
</script>

<script id="editGalleryTemplate" type="text/x-jquery-tmpl">
  <div class="content">
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
  </div>
</script>

<script id="albumsTemplate" type="text/x-jquery-tmpl">
  <li id="${id}" data-id="${id}" class="item fade in alb-trigger-edit" draggable="true">
    <div class="thumbnail"></div>
    <div class="glyphicon-set fade out" style="">
      <span class="tooltips downloading glyphicon glyphicon-download-alt glyphicon-white hide left fade" data-toggle="tooltip"></span>
      <span class="tooltips zoom glyphicon glyphicon-folder-close glyphicon-white left" data-toggle="tooltip" title="Open"></span>
      <span class="back glyphicon glyphicon-chevron-up glyphicon-white left" data-toggle="tooltip" title="Up"></span>
      <span class="glyphicon delete glyphicon glyphicon-trash glyphicon-white right" data-toggle="tooltip" title="Delete"></span>
    </div>
    <div class="title center">{{if title}}{{html title.slice(0, 15)}}{{else}}...{{/if}}</div>
  </li>
</script>

<script id="editAlbumTemplate" type="text/x-jquery-tmpl">
  <div class="content">
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
  </div>
</script>

<script id="editPhotoTemplate" type="text/x-jquery-tmpl">
  <div class="content">
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
  </div>
</script>

<script id="albumSelectTemplate" type="text/x-jquery-tmpl">
  <option {{if ((constructor.record) && (constructor.record.id == id))}}selected{{/if}} value="${id}">${title}</option>
</script>

<script id="headerGalleryTemplate" type="text/x-jquery-tmpl">
  <section class="top viewheader fadeelement">
    <span>
      Author:&nbsp;<span class="label label-default">${author}</span>
    </span>
    {{tmpl() "#gallerySpecsTemplate"}}
    <br><br>
    <h2>Galleries Overview</h2>
    <span class="first right"><h3 class=""><i>Info</i></h3></span>
  </section>
</script>

<script id="headerAlbumTemplate" type="text/x-jquery-tmpl">
  <section class="top viewheader fadeelement">
    <span>
      {{if model.record}}
      Gallery:&nbsp;<span class="label label-{{if model.record}}default{{else}}warning{{/if}}">${model.record.name.slice(0, 25)}</span>
      {{else}}
      Author:&nbsp;<span class="label label-default">${author}</span>
      {{/if}}
    </span>
    {{tmpl() "#albumSpecsTemplate"}}
    <br><br>
    <h2>{{if model.record}}Albums in:&nbsp;{{else}}Master Albums{{/if}}</h2>
    {{if model.record}}<label class="h2 chopin">{{if model.record.name}}${model.record.name.slice(0, 25)}{{else}}...{{/if}}</label>{{/if}}
    <span class="right"><h3 class=""><i>Info</i></h3></span>
  </section>
  <section class="left">
    <span class="fadeelement breadcrumb">
      <li class="gal gal-trigger-edit">
        <a href="#">Galleries</a>
      </li>
      <li class="alb active alb-trigger-edit">Albums</li>
    </span>
  </section>
</script>

<script id="headerPhotosTemplate" type="text/x-jquery-tmpl">
  <section class="top viewheader fadeelement">
    <span>
      {{if model.record}}
      Gallery:&nbsp;<span class="label label-{{if gallery.name}}default{{else}}warning{{/if}}">{{if gallery.name}}${gallery.name.slice(0, 25)}{{else}}none{{/if}}</span>
      Album:&nbsp;<span class="label label-{{if model.record}}default{{else}}warning{{/if}}">{{if modelAlbum.record}}{{if album.title}}${album.title.slice(0, 25)}{{else}}...{{/if}}{{else}}none{{/if}}</span>
      {{else}}
      Author:&nbsp;<span class="label label-default">${author}</span>
      {{/if}}
    </span>
    {{tmpl() "#photoSpecsTemplate"}}
    <br><br>
    <h2>{{if album}}Photos in:&nbsp;{{else}}Master Photos{{/if}}</h2>
    {{if album}}<label class="h2 chopin">{{if album.title}}${album.title.slice(0, 25)}{{else}}...{{/if}}</label>{{/if}}
    <span class="right"><h3 class=""><i>Info</i></h3></span>
  </section>
  {{if zoomed}}
  {{tmpl() "#photoBreadcrumbTemplate"}}
  {{else}}
  {{tmpl() "#photosBreadcrumbTemplate"}}
  {{/if}}
</script>

<script id="photosBreadcrumbTemplate" type="text/x-jquery-tmpl">
  <section class="left">
    <span class="fadeelement breadcrumb">
      <li class="gal gal-trigger-edit">
        <a href="#">Galleries</a>
      </li>
      <li class="alb alb-trigger-edit">
        <a href="#">Albums</a>
      </li>
      <li class="pho active">Photos</li>
    </span>
  </section>
</script>

<script id="photoBreadcrumbTemplate" type="text/x-jquery-tmpl">
  <section class="left">
    <span class="fadeelement breadcrumb">
      <li class="gal gal-trigger-edit">
        <a href="#">Galleries</a>
      </li>
      <li class="alb alb-trigger-edit">
        <a href="#">Albums</a>
      </li>
      <li class="pho pho-trigger-edit">
        <a href="#">Photos</a>
      </li>
      <li class="active">{{if photo.src}}${photo.src}{{else}}deleted{{/if}}</li>
    </span>
  </section>
</script>

<script id="headerPhotoTemplate" type="text/x-jquery-tmpl">
  <section class="top viewheader fadeelement">
    <span>
      {{if model.record}}
      Gallery:&nbsp;<span class="label label-{{if gallery.name}}default{{else}}warning{{/if}}">{{if gallery.name}}${gallery.name}{{else}}none{{/if}}</span>
      Album:&nbsp;<span class="label label-{{if model.record}}default{{else}}warning{{/if}}">{{if modelAlbum.record}}{{if album.title}}${album.title}{{else}}...{{/if}}{{else}}none{{/if}}</span>
      {{else}}
      Author:&nbsp;<span class="label label-default">${author}</span>
      {{/if}}
    </span>
    {{tmpl() "#photoSpecsTemplate"}}
    <br><br>
    <h2>{{if album}}Photos in:&nbsp;{{else}}Master Photos{{/if}}</h2>
    {{if album}}<label class="h2 chopin">{{if album.title}}${album.title}{{else}}...{{/if}}</label>{{/if}}
    <span class="right"><h3 class=""><i>Info</i></h3></span>
  </section>
  {{tmpl() "#photoBreadcrumbTemplate"}}
</script>

<script id="gallerySpecsTemplate" type="text/x-jquery-tmpl">
  <div class="right">
    <span class="">
    <div class="btn btn-sm">Galleries<b><h5>${model.count()}</h5></b></div>
    </span> 
    <span class="">
    <div class="btn btn-sm">Connected Albums<b><h5>${modelGas.count()} (${modelAlbum.count()} Masters)</h5></b></div>
    </span> 
    <span class="">
    <div class="btn btn-sm">Connected Images<b><h5>${modelAps.count()} (${modelPhoto.count()} Masters)</h5></b></div>
    </span>
  </div>
</script>

<script id="albumSpecsTemplate" type="text/x-jquery-tmpl">
  <div class="right">
    <span class="">
      <div class="opt-SelectAll select btn btn-sm {{if model.details().sCount>0}}btn-info{{/if}}"><b class=""><h5>${model.details().sCount}</h5></b></div>
    </span> 
    <span class="">
    <div class="btn btn-sm">Albums<b><h5>${model.details().aCount} (${modelAlbum.count()} Masters)</h5></b></div>
    </span> 
    <span class="">
    <div class="btn btn-sm">Connected Images<b><h5>${model.details().iCount} (${modelPhoto.count()} Masters)</h5></b></div>
    </span>
  </div>
</script>

<script id="photoSpecsTemplate" type="text/x-jquery-tmpl">
  <div class="right">
    <span class="">
    <div class="opt-SelectAll select btn btn-sm {{if model.details().sCount>0}}btn-info{{/if}}"><b><h5>${model.details().sCount}</h5></b></div>
    </span> 
    <span class="">
    <div class="btn btn-sm">Images<b><h5>${model.details().iCount} (${modelPhoto.count()} Masters)</h5></b></div>
    </span> 
  </div>
</script>

<script id="albumCountTemplate" type="text/x-jquery-tmpl">
  <span class="cta">${iCount}</span>
</script>

<script id="albumsSublistTemplate" type="text/x-jquery-tmpl">
  {{if flash}}
  <span class="author">${flash}</span>
  {{else}}
  <li data-id="${id}" class="sublist-item alb alb-trigger-edit item data" title="move (Hold Cmd-Key to Copy)">
    <span class="glyphicon glyphicon-folder-close"></span>
    <span class="title center">{{if title}}${title.slice(0, 15)}{{else}}...{{/if}}</span>
    <span class="cta">{{if count}}${count}{{else}}0{{/if}}</span>
  </li>
  {{/if}}
</script>

<script id="albumInfoTemplate" type="text/x-jquery-tmpl">
  <ul>
    <li class="name">
      <span class="left">{{if title}}${title}{{else}}no title{{/if}} </span>
      <span class="right"> {{tmpl($item.data.details()) "#albumCountTemplate"}}</span>
    </li>
    <li class="italic">
      <span class="">{{if description}}${description}{{/if}}</span>
    </li>
  </ul>
</script>

<script id="photosDetailsTemplate" type="text/x-jquery-tmpl">
  Author:  <span class="label label-default">${author}</span>
  Gallery:  <span class="label label-{{if gallery}}default{{else}}warning{{/if}}">{{if gallery}}{{if gallery.name}}${gallery.name}{{else}}no name{{/if}}{{else}}not found{{/if}}</span>
  <br><br>
  <h2>Photos in Album: </h2>
  <label class="h2 chopin">{{if album.title}}${album.title}{{else}}no title{{/if}}</label>
  <span class="active cta right">
    <h2>Total: ${count}</h2>
  </span>
</script>

<script id="photoDetailsTemplate" type="text/x-jquery-tmpl">
  Author:&nbsp;<span class="label label-default">{{if author}}${author}{{/if}}</span>
  Gallery:&nbsp;<span class="label label-{{if gallery}}default{{else}}warning{{/if}}">{{if gallery}}{{if gallery.name}}${gallery.name}{{else}}no name{{/if}}{{else}}not found{{/if}}</span>
  Album:&nbsp;<span class="label label-{{if album}}default{{else}}warning{{/if}}">{{if album}}{{if album.title}}${album.title}{{else}}no title{{/if}}{{else}}not found{{/if}}</span>
  <br><br>
  <h2>Photo:</h2>
  <label class="h2 chopin">
    {{if photo}}
    {{if photo.title}}${photo.title}{{else}}{{if photo.src}}${photo.src}{{else}}no title{{/if}}{{/if}}
    {{else}}
    deleted
    {{/if}}
  </label>
</script>

<script id="photosTemplate" type="text/x-jquery-tmpl">
  <li  id="${id}" data-id="${id}" class="item data fade in pho-trigger-edit" draggable="true">
    {{tmpl "#photosThumbnailTemplate"}}
    <div class="title center hide">{{if title}}${title.substring(0, 15)}{{else}}{{if src}}${src.substring(0, 15)}{{else}}no title{{/if}}{{/if}}</div>
  </li>
</script>

<script id="photosSlideshowTemplate" type="text/x-jquery-tmpl">
  <li  class="item data ">
    <a class="thumbnail image left fadeslow in"></a>
  </li>
</script>

<script id="photoTemplate" type="text/x-jquery-tmpl">
  <li data-id="${id}" class="item pho-trigger-edit">
    {{tmpl "#photoThumbnailTemplate"}}
  </li>
</script>

<script id="photosThumbnailTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left fadeslow"></div>
  <div class="glyphicon glyphicon-set fade out" style="">
    <span class="delete glyphicon glyphicon-trash glyphicon-white right" title="Delete"></span>
    <span class="back glyphicon glyphicon-chevron-up glyphicon-white right" title="Up"></span>
    <span class="zoom glyphicon glyphicon-resize-full glyphicon-white right" title="Full Size"></span>
    <span class="rotate glyphicon glyphicon-repeat glyphicon-white right" title="Rotate clockwise"></span>
    </div>
  </div>
</script>

<script id="photoThumbnailTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left"></div>
  <div class="glyphicon glyphicon-set fade out" style="">
    <span class="back glyphicon glyphicon-chevron-up glyphicon-white right" title="Up"></span>
    <span class="zoom glyphicon glyphicon-resize-full glyphicon-white right" title="Full Size"></span>
    <span class="rotate glyphicon glyphicon-repeat glyphicon-white right" title="Rotate clockwise"></span>
    <ul class="dropdown-menu" role="menu">
      <li class="opt-">
        <a href="#"><i class="delete glyphicon glyphicon-trash glyphicon-white" title="Delete"></i>Delete</a>
        <a href="#"><i class="glyphicon glyphicon-ok"></i>Trace</a>
      </li>
    </ul>
  </div>
  <div class="title center hide">{{if title}}${title.substring(0, 15)}{{else}}{{if src}}${src.substring(0, 15)}{{else}}no title{{/if}}{{/if}}</div>
</script>

<script id="photoThumbnailSimpleTemplate" type="text/x-jquery-tmpl">
  <div class="opt- thumbnail image left"></div>
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
    <li class="">
      <span class="">{{if title}}{{html title}}{{else}}${src}{{/if}}</span>
    </li>
    <li class="tr">{{if model}}
      <span class="td">Model</span><span class="td">:</span><span class="td">${model}</span>{{/if}}
    </li>
    <li class="tr">{{if software}}
      <span class="td">Software</span><span class="td">:</span><span class="td">${software}</span>{{/if}}
    </li>
    <li class="tr">{{if exposure}}
      <span class="td">Exposure</span><span class="td">:</span><span class="td">${exposure}</span>{{/if}}
    </li>
    <li class="tr">{{if iso}}
      <span class="td">Iso</span><span class="td">:</span><span class="td">${iso}</span>{{/if}}
    </li>
    <li class="tr">{{if aperture}}
      <span class="td">Aperture</span><span class="td">:</span><span class="td">${aperture}</span>{{/if}}
    </li>
    <li class="tr">{{if captured}}
      <span class="td">Captured</span><span class="td">:</span><span class="td">${captured}</span>{{/if}}
    </li>
    <li class="tr italic">{{if description}}
      <span class="td">Description</span><span class="td">:</span>
      <span class="">${description}</span>{{/if}}
    </li>
  </ul>
</script>

<script id="toolsTemplate" type="text/x-jquery-tmpl">
  {{if dropdown}}
    {{tmpl(itemGroup)  "#dropdownTemplate"}}
  {{else}}
  <li class="${klass}"{{if outerstyle}} style="${outerstyle}"{{/if}}{{if id}} id="${id}"{{/if}}>
    <{{if type}}${type} class="{{if icon}}symbol{{/if}} tb-name {{if innerklass}}${innerklass}{{/if}}"{{else}}button class="symbol dark {{if innerklass}}${innerklass}{{/if}}" {{if dataToggle}} data-toggle="${dataToggle}"{{/if}}{{/if}}
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
  <li>
    <a {{if dataToggle}} data-toggle="${dataToggle}"{{/if}} class="${klass} {{if disabled}}disabled{{/if}}">
      <i class="glyphicon glyphicon-{{if icon}}${icon} {{if iconcolor}}glyphicon glyphicon-${iconcolor}{{/if}}{{/if}}"></i>
      {{html name}}
      {{if shortcut}}
      <span class="label label-primary">{{html shortcut}}</span>
      {{/if}}
    </a>
  </li>
  {{/if}}
</script>

<script id="testTemplate" type="text/x-jquery-tmpl">
  {{if eval}}{{tmpl($item.data.eval()) "#testTemplate"}}{{/if}}
</script>

<script id="noSelectionTemplate" type="text/x-jquery-tmpl">
  {{html type}}
</script>

<script id="loginTemplate" type="text/x-jquery-tmpl">
  <div class="btn-group">
    <button type="button" class="dropdown-toggle dark clear" style="min-width: 180px;" data-toggle="dropdown">
      <i class="glyphicon glyphicon-user"></i>
      <span>${user.name}</span>
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu" role="menu">
      <li class="opt-logout"><a href="#">Logout</a></li>
      <li class="divider"></li>
      <li class="opt-trace"><a href="#">
        <i class="glyphicon {{if trace}}glyphicon-ok{{/if}}"></i>Trace</a>
      </li>
    </ul>
  </div>
</script>

<script id="overviewTemplate" type="text/x-jquery-tmpl">
  <div class="item active">
    <img src="/img/overview-background.png" style="width: 800px; height: 370px;">
    <div class="recents carousel-item">
      {{tmpl($item.data.photos) "#overviewPhotosTemplate"}}
    </div>
    <div class="carousel-caption">
      <h3>Recents</h3>
      <p>Last uploaded images</p>
    </div>  
  </div>
  <div class="item summary">
    <img src="/img/overview-background.png" style="width: 800px; height: 370px;">
    <div class="carousel-item">
      {{tmpl($item.data.summary) "#overviewSummaryTemplate"}}
    </div>
    <div class="carousel-caption">
      <h3>Summary</h3>
    </div> 
  </div>
</script>

<script id="overviewPhotosTemplate" type="text/x-jquery-tmpl">
  <div class="item">
    {{tmpl "#photoThumbnailSimpleTemplate"}}
  </div>
</script>

<script id="overviewSummaryTemplate" type="text/x-jquery-tmpl">
  <table class="carousel table center">
    <tbody>
      <tr>
        <td>Galleries</td>
        <td>Albums</td>
        <td>Photos</td>
      </tr>
      <tr class="h1">
        <td>${Gallery.records.length}</td>
        <td>${Album.records.length}</td>
        <td>${Photo.records.length}</td>
      </tr>
    </tbody>
  </table>
</script>

<script id="fileuploadTemplate" type="text/x-jquery-tmpl">
  <span style="font-size: 0.6em;" class=" alert alert-success">
    <span style="font-size: 2.9em; font-family: cursive; margin-right: 20px;" class="alert alert-error">"</span>
    {{if album}}{{if album.title}}${album.title}{{else}}...{{/if}}{{else}}all photos{{/if}}
    <span style="font-size: 5em; font-family: cursive;  margin-left: 20px;" class="alert alert-block uploadinfo"></span>
  </span>
</script>

<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
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


