<div id="loader" class="view">
  <div class="dialogue-wrap">
    <div class="dialogue">
      <div class="dialogue-content">
        <div class="bg transparent" style="line-height: 0.5em; text-align: center; color: #E1EEF7">
          <div class="status-symbol" style="z-index: 2;">
            <img src="/img/ajax-loader.gif" style="">
          </div>
          <div class="status-text">Verifying Account</div>
        </div>
      </div>
    </div>
  </div>
</div>
<div id="main" class="view vbox flex">
  <header id="title" class="hbox">
    <h1><a href="/">Photo Director</a></h1>
    <div id="login" class="flex tright" style="margin-top: 5px;"></div>
  </header>
  <div id="wrapper" class="hbox flex">
    <div id="sidebar" class="views canvas-bg-medium hbox vdraggable">
      <div class="vbox flex inner">
        <div class="search">
          <form class="form-search">
            <input class="search-query" type="search" placeholder="Search" results="0" incremental="true" autofocus>
          </form>
        </div>
        <div class="originals hbox">
          <ul class="options flex">
            <li id="twitter" class="splitter disabled"></li>
          </ul>
        </div>
        <ul class="items canvas vbox flex autoflow"></ul>
        <footer class="footer">
          <button class="create dark">+ Gallery</button>
        </footer>
      </div>
      <div class="vdivide draghandle"></div>
    </div>
    <div id="content" class="views canvas-bg-dark vbox flex">
      <div class="overview view content canvas vbox flex">
        <ul class="navbar options">
          <li class="splitter disabled flex"></li>
          <li class="optClose right" style="position: relative; top: 8px; right: 8px;"><span class="icon-remove icon-white"></span></li>
        </ul>
        <div class="flex vbox autoflow">
          <div class="container">
            <fieldset>
              <label><span class="enlightened">Recently Uploaded:</span></label>
              <div class="items"></div>
            </fieldset>
            <fieldset>
              <label><span class="enlightened">Summary:</span></label>
              <div class="info">
                Blank 
              </div>
            </fieldset>
          </div>
          <div class="container">
            <fieldset>
              <label><span class="enlightened">Informations:</span></label>
            </fieldset>
          </div>
        </div>
      </div>
      <div class="show view canvas vbox flex">
        <ul class="options hbox navbar">
          <ul class="toolbarOne hbox nav"></ul>
          <li class="splitter disabled flex"></li>
<!--          <li class="optSlideshow"><button class="dark">Slideshow</button></li>-->
          <ul class="toolbarTwo hbox nav"></ul>
        </ul>
        <div class="contents views vbox flex">
          <div class="header views">
            <div class="galleriesHeader view"></div>
            <div class="albumsHeader view"></div>
            <div class="photosHeader view"></div>
            <div class="photoHeader view"></div>
          </div>
          <div class="view galleries content vbox flex data parent autoflow">
            <div class="items"></div>
          </div>
          <div class="view albums content vbox flex data parent autoflow">
            <div class="hoverinfo"></div>
            <div class="items flex"></div>
          </div>
          <div class="view photos content vbox flex data parent autoflow">
            <div class="hoverinfo"></div>
            <div class="items flex" data-toggle="modal-gallery" data-target="#modal-gallery" data-selector="a"></div>
          </div>
          <div class="view photo content vbox flex data parent autoflow">
            <div class="hoverinfo"></div>
            <div class="items flex">PHOTO</div>
          </div>
          <div class="view slideshow content flex data parent autoflow">
            <div class="items sortable flex" data-toggle="modal-gallery" data-target="#modal-gallery" data-selector="div.thumbnail"></div>
          </div>
        </div>
        <div id="views" class="settings canvas-bg-light hbox autoflow">
          <div class="views content canvas vbox flex hdraggable">
            <div class="hdivide draghandle">
              <span class=" icon-remove icon-white right"></span>
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
            <div id="fu" class="view canvas-bg-light flex autoflow" style="">
              <form id="fileupload" action="uploads/image" method="POST" enctype="multipart/form-data">
                <div class="hero-unit" style="margin-bottom: 0;">
                  <h1><span>Drop Files </span><span class="right alert alert-info uploadinfo" style="font-size: 0.7em;"></span></h1>
                  <p>enjoy...</p>
                  <span class="btn btn-primary btn-large fileinput-button">
                    <span><i class="icon-plus icon-white"></i> Add more files...</span><input type="file" name="files[]" multiple>
                  </span>
                  <div class="row fileupload-buttonbar">
                    <div class="span7">
                      <!-- The fileinput-button span is used to style the file input field as button -->
                      <button type="submit" class="btn btn-success start">
                          <i class="icon-upload icon-white"></i>
                          <span>Start upload</span>
                      </button>
                      <button type="reset" class="btn btn-warning cancel">
                          <i class="icon-ban-circle icon-white"></i>
                          <span>Cancel upload</span>
                      </button>
                      <button type="button" class="btn btn-danger delete">
                          <i class="icon-trash icon-white"></i>
                          <span>Delete</span>
                      </button>
                      <input type="checkbox" class="toggle">
                    </div>
                  </div>
                  <div class="fileupload-loading"></div>
                  <table class="table table-striped"><tbody class="files" data-toggle="modal-gallery" data-target="#modal-gallery"></tbody></table>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      <div class="edit view vbox flex">
        <ul class="navbar options hbox">
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="content container canvas vbox flex autoflow"></div>
      </div>
    </div>
  </div>
</div>
<!-- modal-image-gallery -->
<div id="modal-gallery" class="modal modal-gallery hide fade">
    <div class="modal-header">
        <a class="close" data-dismiss="modal">&times;</a>
        <h3 class="modal-title"></h3>
        <h5><span class="left modal-captured"></span></h5>
        <h5><span class="modal-description"></span></h5>
        <h5><span class="right modal-model"></span></h5>
    </div>
    <div class="modal-body"><div class="modal-image"></div></div>
    <div class="modal-footer">
        <a class="btn btn-primary modal-next">Next <i class="icon-arrow-right icon-white"></i></a>
        <a class="btn btn-info modal-prev"><i class="icon-arrow-left icon-white"></i> Previous</a>
        <a class="btn btn-success modal-play modal-slideshow" data-slideshow="1000"><i class="icon-pause icon-white"></i> Slideshow</a>
        <a class="btn modal-download" target="_blank"><i class="icon-download"></i> Download</a>
    </div>
</div>
<!-- modal-dialogue -->
<div id="modal-view" class="hide fade"></div>


<!-- Templates -->

<script id="modalTemplate" type="text/x-jquery-tmpl">
  <div class="modal-header">
    <a class="close" data-dismiss="modal">&times;</a>
    <h3 class="modal-title">${header}</h3>
  </div>
  <div class="modal-body">${body}</div>
    <div class="modal-footer">${footer}</div>
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
    <span class="author info">{{if author}} by ${author}{{else}}(no author){{/if}}</span>
    <span class="gal cta">{{tmpl($item.data.details()) "#galleryDetailsTemplate"}}</span>
  </div>
</script>

<script id="sidebarTwitterTemplate" type="text/x-jquery-tmpl">
  <li class="gal item data parent" title="" draggable="true">
    <div class="item-header">
      <div class="expander"></div>
        <div class="item-content">
          <span class="name">${name}</span>
        </div>
    </div>
    <hr>
    <ul class="sublist" style="display: none;">
      {{tmpl($item.data.sub) "#sidebarTwitterSublistTemplate"}}
    </ul>
  </li>
</script>

<script id="sidebarTwitterSublistTemplate" type="text/x-jquery-tmpl">
  <div class="item-content">
    <span class="name">${name}</span>
  </div>
</script>

<script id="galleryDetailsTemplate" type="text/x-jquery-tmpl">
    <span>${aCount} </span><span style="font-size: 0.6em;"> (${iCount})</span>
</script>

<script id="galleriesTemplate" type="text/x-jquery-tmpl">
  <li class="item container">
    <div class="ui-symbol ui-symbol-gallery center"></div>
    <div class="thumbnail" draggable="true">
      <div class="inner">
        {{tmpl($item.data.details()) "#galDetailsTemplate"}}
      </div>
    </div>
    <div class="icon-set fade out" style="">
      <span class="zoom icon-zoom-in icon-white left"></span>
      <span class="delete icon-remove icon-white right"></span>
    </div>
    <div class="title">{{if name}}{{html name}}{{else}}---{{/if}}</div>
  </li>
</script>

<script id="galDetailsTemplate" type="text/x-jquery-tmpl">
  <div>Albums: <span class="cta">${aCount}</span></div>
  <div>Images: <span class="cta">${iCount}</span></div>
</script>

<script id="editGalleryTemplate" type="text/x-jquery-tmpl">
  <div class="">
    <div class="">
      <label>
        <span class="enlightened">Gallery Name</span>
      </label>
      <input type="text" name="name" value="${name}">
      <label>
        <span class="enlightened">Description</span>
      </label>
      <textarea name="description">${description}</textarea>
    </div>
  </div>
</script>

<script id="albumsTemplate" type="text/x-jquery-tmpl">
  <li class="item container">
    <div class="ui-symbol ui-symbol-album center"></div>
    <div class="thumbnail left" draggable="true"></div>
    <div class="icon-set fade out" style="">
      <span class="zoom icon-zoom-in icon-white left"></span>
      <span class="delete icon-remove icon-white right"></span>
    </div>
    <div class="title">{{if title}}{{html title}}{{else}}No album selected{{/if}}</div>
    <div class="title" style="font-size: 0.5em">{{if id}}{{html id}}{{else}}no id{{/if}}</div>
  </li>
</script>

<script id="editAlbumTemplate" type="text/x-jquery-tmpl">
  <label class="">
    <span class="enlightened">Album Title</span>
  </label>
  <input type="text" name="title" value="${title}" {{if newRecord}}autofocus{{/if}}>
  <label class="">
    <span class="enlightened">Description</span>
  </label>
  <textarea name="description">${description}</textarea>
</script>

<script id="albumSelectTemplate" type="text/x-jquery-tmpl">
  <option {{if ((constructor.record) && (constructor.record.id == id))}}selected{{/if}} value="${id}">${title}</option>
</script>

<script id="headerGalleryTemplate" type="text/x-jquery-tmpl">
  <section class="top hoverinfo">
    <h2>Gallery Overview<span class="active cta right"><h2>${count}</h2></span></h2>
  </section>
</script>

<script id="headerAlbumTemplate" type="text/x-jquery-tmpl">
  <section class="top hoverinfo">
    {{if record}}
    <h3>Author: </h3><label> ${record.author}</label>
    <h2>Gallery: {{if record.name}}${record.name}{{else}}---{{/if}}
      <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{else}}
    <div class="alert alert-block"><h4 class="alert-heading">Caution</h4>Albums which get removed from this place, will also be permanently removed from <strong class="alert-heading">any</strong> linked Galleries! You may want try removing it from a specific Gallery instead. <em>(Images won't be deleted.)</em></div>
    <h2>All Albums (Album-Masters)
      <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{/if}}
  </section>
  <section class="breadcrumb">
    <ul class="">
      <li class="gal">
        <a href="#">Galleries</a> <span class="divider">/</span>
      </li>
      <li class="alb active">Albums</li>
    </ul>
  </section>
</script>

<script id="albumDetailsTemplate" type="text/x-jquery-tmpl">
  <span class="cta">${iCount}</span>
</script>

<script id="albumsSublistTemplate" type="text/x-jquery-tmpl">
  {{if flash}}
  <span class="author">${flash}</span>
  {{else}}
  <li class="sublist-item alb item data" draggable="true" title="Move (Hold Cmd-Key to Copy)">
    <span class="ui-symbol ui-symbol-album"></span>
    <span class="title">{{if title}}{{html title}}{{else}}---{{/if}}</span>
    <span class="cta">{{if count}}${count}{{else}}0{{/if}}</span>
  </li>
  {{/if}}
</script>

<script id="albumInfoTemplate" type="text/x-jquery-tmpl">
  <ul>
    <li class="name bold"><span class="left">{{if title}}${title}{{else}}no title{{/if}} </span><span class="right"> {{tmpl($item.data.details()) "#albumDetailsTemplate"}}</span></li>
  </ul>
</script>

<script id="headerPhotosTemplate" type="text/x-jquery-tmpl">
  <section class="top hoverinfo">
    {{if album}}
      {{tmpl($item.data.album.details()) "#photosDetailsTemplate"}}
    {{else}}
    <div class="alert alert-error"><h4 class="alert-heading">Caution!</h4>Photos which get removed from this place, will also be permanently removed from <strong class="alert-heading">any</strong> linked Albums!</div>
    <h2>All Photos (Photo-Masters)
      <span class="active cta right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{/if}}
  </section>
  <section class="breadcrumb">
    <ul class="">
      <li class="gal">
        <a href="#">Galleries</a> <span class="divider">/</span>
      </li>
      <li class="alb">
        <a href="#">Albums</a> <span class="divider">/</span>
      </li>
      <li class="pho active">Photos</li>
    </ul>
  </section>
</script>

<script id="headerPhotoTemplate" type="text/x-jquery-tmpl">
  <section class="top hoverinfo">
    {{if $item.data.details}}{{tmpl($item.data.details()) "#photoDetailsTemplate"}}{{/if}}
  </section>
  <section class="breadcrumb">
    <ul class="">
      <li class="gal">
        <a href="#">Galleries</a> <span class="divider">/</span>
      </li>
      <li class="alb">
        <a href="#">Albums</a> <span class="divider">/</span>
      </li>
      <li class="pho">
        <a href="#">Photos</a> <span class="divider">/</span>
      </li>
      <li class="active">{{if src}}${src}{{else}}deleted{{/if}}</li>
    </ul>
  </section>
</script>

<script id="photosDetailsTemplate" type="text/x-jquery-tmpl">
  {{if gallery}}<h3>Gallery: </h3> ${gallery.name}{{else}}no title{{/if}}
  <h2>Album: {{if album.title}}${album.title}{{else}}no title{{/if}}
    <span class="active cta right"><h2>{{if iCount}}${iCount}{{else}}0{{/if}}</h2></span>
  </h2>
</script>

<script id="photoDetailsTemplate" type="text/x-jquery-tmpl">
  {{if gallery}}<div class="left"><h3>Gallery: </h3>${gallery.name}</div>{{/if}}{{if album}}<div class=""><h3>Album: </h3>${album.title}</div>{{/if}}
  {{if !album}}
    <div class="alert alert-error"><h4 class="alert-heading">Warning!</h4>Each photo that's part of an album derives from a master-photo. Destroying the master, will cause all derived photos (aliases) to be removed!</div>
  {{/if}}
  <h2>Photo: {{if photo.title}}${photo.title}{{else}}{{if photo.src}}${photo.src}{{else}}no title{{/if}}{{/if}}</h2>
</script>


<script id="editPhotoTemplate" type="text/x-jquery-tmpl">
  <label class="">
    <span class="enlightened">Photo Title</span>
  </label>
  <input type="text" name="title" value="${src}" >
  <label class="">
    <span class="enlightened">Description</span>
  </label>
  <textarea name="description">${description}</textarea>
</script>

<script id="photosTemplate" type="text/x-jquery-tmpl">
  <li  class="item data container">
    {{tmpl "#photosThumbnailTemplate"}}
  </li>
</script>

<script id="photosSlideshowTemplate" type="text/x-jquery-tmpl">
  <li  class="item data container">
    <div class="thumbnail image left" draggable="true"></div>
  </li>
</script>

<script id="photoTemplate" type="text/x-jquery-tmpl">
  <li class="item container">
    {{tmpl "#photoThumbnailTemplate"}}
  </li>
</script>

<script id="photosThumbnailTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left" draggable="true"></div>
  <div class="icon-set fade out" style="">
    <span class="zoom icon-zoom-in icon-white left"></span>
    <span class="delete icon-remove icon-white right"></span>
  </div>
</script>

<script id="photoThumbnailTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left" draggable="true"></div>
  <div class="icon-set fade out" style="">
    <span class="delete icon-remove icon-white right"></span>
  </div>
</script>

<script id="photoThumbnailSimpleTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left" draggable="true"></div>
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
    <{{if type}}${type} class="tb-name"{{else}}button class="dark {{if innerklass}}${innerklass}{{/if}}" {{if dataToggle}} data-toggle="${dataToggle}"{{/if}}{{/if}}
    {{if innerstyle}} style="${innerstyle}"{{/if}}
    {{if disabled}}disabled{{/if}}>
    {{if icon}}<i class="icon-${icon}  {{if iconcolor}}icon-${iconcolor}{{/if}}"></i>{{/if}}{{html name}}
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
      {{tmpl(content) "#dropListItemTemplate"}}
    </ul>
  </li>
</script>

<script id="dropListItemTemplate" type="text/x-jquery-tmpl">
  {{if devider}}
  <li class="divider"></li>
  {{else}}
  <li><a {{if dataToggle}} data-toggle="${dataToggle}"{{/if}} class="${klass} {{if disabled}}disabled{{/if}}"><i class="icon-{{if icon}}${icon} {{if iconcolor}}icon-${iconcolor}{{/if}}{{/if}}"></i>${name}</a></li>
  {{/if}}
</script>

<script id="testTemplate" type="text/x-jquery-tmpl">
  {{if eval}}{{tmpl($item.data.eval()) "#testTemplate"}}{{/if}}
</script>

<script id="noSelectionTemplate" type="text/x-jquery-tmpl">
  {{html type}}
</script>

<script id="loginTemplate" type="text/x-jquery-tmpl">
  <button class="dark clear logout" title="Group ${groupname}">Logout ${name}</button>
</script>

<script id="overviewTemplate" type="text/x-jquery-tmpl">
  <div class="item">
    {{tmpl "#photoThumbnailSimpleTemplate"}}
  </div>
</script>

<script id="fileuploadTemplate" type="text/x-jquery-tmpl">
  <span style="font-size: 0.6em;" class=" alert alert-success"><span style="font-size: 2.9em; font-family: cursive; margin-right: 20px;" class="alert alert-error">"</span>{{if album}}{{if album.title}}${album.title}{{else}}no title{{/if}}{{else}}all photos{{/if}}<span style="font-size: 5em; font-family: cursive;  margin-left: 20px;" class="alert alert-block uploadinfo">"</span></span>
</script>

<script>
var fileUploadErrors = {
    maxFileSize: 'File is too big',
    minFileSize: 'File is too small',
    acceptFileTypes: 'Filetype not allowed',
    maxNumberOfFiles: 'Max number of files exceeded',
    uploadedBytes: 'Uploaded bytes exceed file size',
    emptyResult: 'Empty file upload result'
};
</script>

<script id="template-upload_" type="text/html">
  {% for (var i=0, files=o.files, l=files.length, file=files[0]; i<l; file=files[++i]) { %}
    <tr class="template-upload fade">
      <td class="preview"><span class="fade"></span></td>
      <td class="name">{%=file.name%}</td>
      <td class="size">{%=o.formatFileSize(file.size)%}</td>
      {% if (file.error) { %}
      <td class="error" colspan="2"><span class="label important">Error</span> {%=fileUploadErrors[file.error] || file.error%}</td>
      {% } else if (o.files.valid && !i) { %}
      <td class="progress"><div class="progress progressbar progress-info"><div class="bar" style="width:0%;"></div></div></td>
      <td class="start">{% if (!o.options.autoUpload) { %}<button class="btn primary">Start</button>{% } %}</td>
      {% } else { %}
      <td colspan="2"></td>
      {% } %}
      <td class="cancel">{% if (!i) { %}<button class="btn info">Cancel</button>{% } %}</td>
    </tr>
  {% } %}
</script>

<script id="template-upload" type="text/x-jquery-tmpl">
{% for (var i=0, files=o.files, l=files.length, file=files[0]; i<l; file=files[++i]) { %}
    <tr class="template-upload fade">
        <td class="preview"><span class="fade"></span></td>
        <td class="name">{%=file.name%}</td>
        <td class="size">{%=o.formatFileSize(file.size)%}</td>
        {% if (file.error) { %}
            <td class="error" colspan="2"><span class="label label-important">{%=locale.fileupload.error%}</span> {%=locale.fileupload.errors[file.error] || file.error%}</td>
        {% } else if (o.files.valid && !i) { %}
            <td>
                <div class="progress progress-success progress-striped active"><div class="bar" style="width:0%;"></div></div>
            </td>
            <td class="start">{% if (!o.options.autoUpload) { %}
                <button class="btn btn-primary">
                    <i class="icon-upload icon-white"></i> {%=locale.fileupload.start%}
                </button>
            {% } %}</td>
        {% } else { %}
            <td colspan="2"></td>
        {% } %}
        <td class="cancel">{% if (!i) { %}
            <button class="btn btn-warning">
                <i class="icon-ban-circle icon-white"></i> {%=locale.fileupload.cancel%}
            </button>
        {% } %}</td>
    </tr>
{% } %}
</script>

<script id="template-download" type="text/html">
  {% for (var i=0, files=o.files, l=files.length, file=files[0]; i<l; file=files[++i]) { %}
    <tr class="template-download fade">
      {% if (file.error) { %}
      <td></td>
      <td class="name">{%=file.name%}</td>
      <td class="size">{%=o.formatFileSize(file.size)%}</td>
      <td class="error" colspan="2"><span class="label important">Error</span> {%=fileUploadErrors[file.error] || file.error%}</td>
      {% } else { %}
      <td class="preview">{% if (file.thumbnail_url) { %}
        <a href="{%=file.url%}" title="{%=file.name%}" rel="gallery"><img src="{%=file.thumbnail_url%}"></a>
        {% } %}</td>
      <td class="name">
        <a href="{%=file.url%}" title="{%=file.name%}" rel="{%=file.thumbnail_url&&'gallery'%}">{%=file.name%}</a>
      </td>
      <td class="size">{%=o.formatFileSize(file.size)%}</td>
      <td colspan="2"></td>
      {% } %}
      <td class="delete">
        <button class="btn danger" data-type="{%=file.delete_type%}" data-url="{%=file.delete_url%}">Delete</button>
        <input type="checkbox" name="delete" value="1">
      </td>
    </tr>
  {% } %}
</script>