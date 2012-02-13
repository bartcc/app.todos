<div id="messenger" style="display: none">
  <div class="dialogue-wrap transparent" id="messenger">
    <div class="dialogue">
      <div style="width:525px; min-width:500px;" class="morph dialogue-content" id="morph_messenger-wrap">
        <div class="bg verticaltop" id="draggable-messenger-wrap">
          <header>
            <fieldset class="right">
              <button class="_close light window input">X</button>
            </fieldset>
          </header>
          <div class="dialogue-inner-wrap">
            <div class="drag-handle">
              <div>
                <h1>Login</h1>
                <div class="_flash"><span></span></div>
                <label><small>(guest/guest, manager/manager, admin/admin)</small></label>
              </div>
              <div class="clearfix"></div>
            </div>
            <div class="dialogue-scroll">
              <fieldset>
                <div class="left">
                  <label>User</label>
                  <input class="username" type="text">
                </div>
                <div class="left">
                  <label>Password</label>
                  <input class="password" type="password">
                </div>
              </fieldset>
            </div>
          </div>
          <footer>
            <span>
              <fieldset>
                <button class="light">Local Storage</button>
                <button class="light disabled" disabled="">Login</button>
              </fieldset>
            </span>
          </footer>
        </div>
      </div>
    </div>
  </div>
</div>
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
    <h1>Director</h1>
    <div id="login" class="flex tright" style="margin-top: 5px;"></div>
  </header>
  <div id="wrapper" class="hbox flex">
    <div id="sidebar" class="views canvas-bg-medium hbox vdraggable">
      <div class="vbox flex inner">
        <div class="search">
          <input type="search" placeholder="Search" results="0" incremental="true" autofocus>
        </div>
        <div class="originals hbox">
          <ul class="options hbox flex">
            <li class="splitter disabled"></li>
          </ul>
        </div>
        <ul class="items canvas vbox flex autoflow"></ul>
        <footer class="footer">
          <button class="create dark">New Gallery</button>
        </footer>
      </div>
      <div class="vdivide draghandle"></div>
    </div>
    <div id="content" class="views canvas-bg-dark vbox flex">
      <div class="overview view content canvas vbox flex">
        <ul class="tools options hbox">
          <li class="splitter disabled flex"></li>
          <li class="optClose right"><button class="dark">X</button></li>
        </ul>
        <div class="flex vbox autoflow">
          <div class="container">
            <fieldset>
              <label class="label"><span class="enlightened">Recently Uploaded:</span></label>
              <div class="items"></div>
            </fieldset>
            <fieldset>
              <label class="label"><span class="enlightened">Summary:</span></label>
              <div class="info">
                Blank 
              </div>
            </fieldset>
          </div>
          <div class="container">
            <fieldset>
              <label class="label"><span class="enlightened">Informations:</span></label>
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
            <div class="hoverinfo"></div>
            <div class="items sortable"></div>
          </div>
          <div class="view albums content vbox flex data parent autoflow">
            <div class="hoverinfo"></div>
            <div class="items sortable flex"></div>
          </div>
          <div class="view photos content vbox flex data parent autoflow">
            <div class="hoverinfo"></div>
            <div class="items sortable flex"></div>
          </div>
          <div class="view photo content vbox flex data parent autoflow">
            <div class="hoverinfo"></div>
            <div class="items sortable flex">PHOTO</div>
          </div>
          <div class="view slideshow content flex data parent autoflow">
            <div id="gallery" class="items flex" data-toggle="modal-gallery" data-target="#modal-gallery" data-selector="li" data-slideshow="5000"></div>
          </div>
        </div>
        <div id="views" class="settings canvas-bg-light hbox autoflow">
          <div class="views content canvas vbox flex hdraggable">
            <div class="hdivide draghandle"></div>
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
            <div id="fu" class="view container flex autoflow" style="">
              <form id="fileupload" action="uploads/image" method="POST" enctype="multipart/form-data">
                <label class="message label right"><span class="enlightened">Drag your images anywhere into the browser window</span></label>
                <div class="uploadinfo"></div>
                <div class="row">
                  <div class="span16 fileupload-buttonbar">
                    <div class="progressbar fileupload-progressbar"><div style="width:0%;"></div></div>
                    <span class="btn btn-success fileinput-button">
                      <span>Add files...</span>
                      <input type="file" name="files[]" multiple>
                    </span>
                    <button type="submit" class="btn btn-primary start">Start upload</button>
                    <button type="reset" class="btn btn-info cancel">Cancel upload</button>
                    <button type="button" class="btn btn-danger delete">Delete selected</button>
                    <input type="checkbox" class="toggle">
                  </div>
                </div>
                <br>
                <div class="row">
                  <div class="span16">
                    <table class="zebra-striped"><tbody class="files"></tbody></table>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>  
        <ul class="options props hbox" style="display: none;">
          <li class="opt optGallery">Gallery<span class="ui-dimmed ui-button-icon-primary ui-icon ui-icon-carat-1 right"></span></li>
          <li class="splitter disabled"></li>
          <li class="opt optAlbum">Album<span class="ui-dimmed ui-button-icon-primary ui-icon ui-icon-carat-1 right"></span></li>
          <li class="splitter disabled"></li>
          <li class="opt optPhoto">Image<span class="ui-dimmed ui-button-icon-primary ui-icon ui-icon-carat-1 right"></span></li>
          <li class="splitter disabled"></li>
          <li class="opt optUpload">Upload<span class="ui-dimmed ui-button-icon-primary ui-icon ui-icon-carat-1 right"></span></li>
          <li class="splitter disabled"></li>
        </ul>
      </div>
      <div class="edit view vbox flex">
        <ul class="tools options hbox">
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="content container canvas vbox flex autoflow"></div>
      </div>
    </div>
  </div>
</div>
<!-- modal-gallery is the modal dialog used for the image gallery -->
<div id="modal-gallery" class="modal modal-gallery hide fade">
    <div class="modal-header">
        <a class="close" data-dismiss="modal">&times;</a>
        <h3 class="modal-title"></h3>
    </div>
    <div class="modal-body"><div class="modal-image"></div></div>
    <div class="modal-footer">
        <a class="btn btn-primary modal-next">Next <i class="icon-arrow-right icon-white"></i></a>
        <a class="btn btn-info modal-prev"><i class="icon-arrow-left icon-white"></i> Previous</a>
        <a class="btn btn-success modal-play modal-slideshow"><i class="icon-play icon-white"></i> Slideshow</a>
        <a class="btn modal-download" target="_blank"><i class="icon-download"></i> Download</a>
    </div>
</div>


<!-- Templates -->

<script id="sidebarTemplate" type="text/x-jquery-tmpl">
  <li class="gal item data parent" title="Deselect   Cmd-Click">
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
    <span class="author">{{if author}} by ${author}{{else}}(no author){{/if}}</span>
    <span class="gal cta">{{tmpl($item.data.details()) "#galleryDetailsTemplate"}}</span>
  </div>
</script>

<script id="galleryDetailsTemplate" type="text/x-jquery-tmpl">
    <span>${aCount} </span><span style="font-size: 0.6em;"> (${iCount})</span>
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
    <span class="title">{{if title}}{{html title}}{{else}}no title{{/if}}</span>
    <span class="cta">{{if count}}${count}{{else}}0{{/if}}</span>
  </li>
  {{/if}}
</script>

<script id="galleriesTemplate" type="text/x-jquery-tmpl">
  <li class="item container">
    <div class="ui-symbol ui-symbol-gallery center"></div>
    <div class="thumbnail" draggable="true">
      <div class="inner">
        {{tmpl($item.data.details()) "#galDetailsTemplate"}}
      </div>
    </div>
    <div class="title">{{if name}}{{html name}}{{else}}no title{{/if}}</div>
  </li>
</script>

<script id="galDetailsTemplate" type="text/x-jquery-tmpl">
  <div>Albums: <span class="cta">${aCount}</span></div>
  <div>Images: <span class="cta">${iCount}</span></div>
</script>

<script id="editGalleryTemplate" type="text/x-jquery-tmpl">
  <div class="">
    <div class="">
      <label class="label">
        <span>Gallery Name</span>
      </label>
      <input type="text" name="name" value="${name}">

      <label class="label"><span>Author: </span>{{if author}}${author}{{else}}no author{{/if}}</label>
      <label class="label">
        <span>Description</span>
      </label>
      <textarea name="description">${description}</textarea>
    </div>
  </div>
</script>

<script id="albumsTemplate" type="text/x-jquery-tmpl">
  <li class="item container">
    <div class="ui-symbol ui-symbol-album center"></div>
    <div class="thumbnail left" draggable="true"></div>
    <div class="title">{{if title}}{{html title}}{{else}}no title{{/if}}</div>
  </li>
</script>

<script id="editAlbumTemplate" type="text/x-jquery-tmpl">
  <div class="">
    <div class="">
      <label class="label">
        <span>Album Title</span>
      </label>
      <input type="text" name="title" value="${title}" {{if newRecord}}autofocus{{/if}}>
    </div>
    <div class="">
      <label class="label">
        <span>Description</span>
      </label>
      <textarea name="description">${description}</textarea>
    </div>
  </div>
</script>

<script id="albumSelectTemplate" type="text/x-jquery-tmpl">
  <option {{if ((constructor.record) && (constructor.record.id == id))}}selected{{/if}} value="${id}">${title}</option>
</script>

<script id="editPhotoTemplate" type="text/x-jquery-tmpl">
  <div class="">
    <label class="label">
      <span>Photo Title</span>
    </label>
    <input type="text" name="title" value="${title}" >
  </div>
  <div class="">
    <label class="label">
      <span>Description</span>
    </label>
    <textarea name="description">${description}</textarea>
  </div>
</script>

<script id="toolsTemplate" type="text/x-jquery-tmpl">
  {{if dropdown}}
    {{tmpl(itemGroup)  "#dropdownTemplate"}}
  {{else}}
  <li class="${klass}"{{if outerstyle}} style="${outerstyle}"{{/if}}>
    <{{if type}}${type} class="tb-name"{{else}}button class="dark" {{if dataToggle}} data-toggle="${dataToggle}"{{/if}}{{/if}}
    {{if style}} style="${style}"{{/if}}
    {{if disabled}}disabled{{/if}}>
    {{html name}}
    </{{if type}}${type}{{else}}button{{/if}}>
  </li>
  {{/if}}
</script>

<script id="dropdownTemplate" type="text/x-jquery-tmpl">
  <li class="dropdown" id="menu1">
    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
      ${name}
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
  <li><a class="${klass} {{if disabled}}disabled{{/if}}" href="#">${name}</a></li>
  {{/if}}
</script>

<script id="testTemplate" type="text/x-jquery-tmpl">
  {{if eval}}{{tmpl($item.data.eval()) "#testTemplate"}}{{/if}}
</script>

<script id="noSelectionTemplate" type="text/x-jquery-tmpl">
  {{html type}}
</script>

<script id="headerGalleryTemplate" type="text/x-jquery-tmpl">
  <section class="top">
    <h2>Gallery Overview<span class="active cta right"><h2>${count}</h2></span></h2>
  </section>
</script>

<script id="headerAlbumTemplate" type="text/x-jquery-tmpl">
  <section class="top">
    {{if record}}
    <h3>Author: <label> ${record.author}</label></h3>
    <h2>Gallery: ${record.name}
      <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{else}}
    <label class="label label-important"><span class=""> Caution: These albums  are the original photo collections!</span></label>
    <br>
    <label class="label label-info"><span class="">Photos part of a destroyed collection are not removed permanently</span></label>
    <h2>All Albums
      <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{/if}}
  </section>
  <section class="closeView options">
    <ul class="breadcrumb">
      <li class="gal">
        <a href="#">Galleries</a> <span class="divider">/</span>
      </li>
      <li class="alb active">Albums</li>
    </ul>
  </section>
</script>

<script id="headerPhotosTemplate" type="text/x-jquery-tmpl">
  <section class="top">
    {{if gallery}}
    <h3>Gallery: ${gallery.name}</h3>
    {{/if}}
    {{if album}}
    <h2>Album: ${album.title}
      <span class="active cta right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{else}}
    <label class="label label-important"><span class=""> Caution: Removing the original means destroying the photo on the server!</span></label>
    <h2>All Photos (Originals)
      <span class="active cta right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{/if}}
  </section>
  <section class="closeView options">
    <ul class="breadcrumb">
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
  <section class="top">
    {{if $item.data.details}}{{tmpl($item.data.details()) "#photoDetailsTemplate"}}{{/if}}
  </section>
  <section class="closeView options">
    <ul class="breadcrumb">
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

<script id="photoDetailsTemplate" type="text/x-jquery-tmpl">
  <h3>{{if gallery}}<span>Gallery: ${gallery.name}</span>{{/if}}{{if album}}<span>Album: ${album.title}</span>{{/if}}</h3>
  {{if !album}}
  <label class="label label-important"><span class=""> Caution: Removing the original means destroying the photo on the server!</span></label>
  {{/if}}
  <h2>Photo: {{if photo.title}}${photo.title}{{else}}{{if photo.src}}${photo.src}{{else}}unknown{{/if}}{{/if}}</h2>
</script>

<script id="loginTemplate" type="text/x-jquery-tmpl">
  <button class="dark clear logout" title="Group ${groupname}">Logout ${name}</button>
</script>

<script id="overviewTemplate" type="text/x-jquery-tmpl">
  <div class="item">
    {{tmpl "#photoThumbnailTemplate"}}
  </div>
</script>

<script id="photosTemplate" type="text/x-jquery-tmpl">
  <li  class="item data container">
    {{tmpl "#photoThumbnailTemplate"}}
  </li>
</script>

<script id="photosSlideshowTemplate" type="text/x-jquery-tmpl">
  <li  class="item data container">
    {{tmpl "#photoThumbnailTemplate"}}
  </li>
</script>

<script id="photoTemplate" type="text/x-jquery-tmpl">
  <li class="item container">
    {{tmpl "#photoThumbnailTemplate"}}
  </li>
</script>

<script id="photoThumbnailTemplate" type="text/x-jquery-tmpl">
  <div class="thumbnail image left" draggable="true"></div>
</script>

<script id="preloaderTemplate" type="text/x-jquery-tmpl">
  <div class="preloader">
    <div class="content">
      <div></div
    </div>
  </div>
</script>

<script id="albumInfoTemplate" type="text/x-jquery-tmpl">
  <ul>
    <li class="name"><span class="left">{{if title}}${title}{{else}}no title{{/if}} </span><span class="right"> {{tmpl($item.data.details()) "#albumDetailsTemplate"}}</span></li>
  </ul>
</script>

<script id="photoInfoTemplate" type="text/x-jquery-tmpl">
  <ul>
    {{if title}}
      <li class="empty">{{html title}}</li>
    {{else}}
      <li class="empty">${src}</li>
    {{/if}}
    <li class="">iso: ${iso}</li>
    <li class="">model: ${model}</li>
    <li class="">date: ${captured}</li>
  </ul>
</script>

<script id="fileuploadTemplate" type="text/x-jquery-tmpl">
  <label class="label"><span>Target Album: </span>{{if album}} ${album.title}{{else}}none (all photos){{/if}}</label>
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

<script id="template-upload" type="text/html">
  {% for (var i=0, files=o.files, l=files.length, file=files[0]; i<l; file=files[++i]) { %}
    <tr class="template-upload fade">
      <td class="preview"><span class="fade"></span></td>
      <td class="name">{%=file.name%}</td>
      <td class="size">{%=o.formatFileSize(file.size)%}</td>
      {% if (file.error) { %}
      <td class="error" colspan="2"><span class="label important">Error</span> {%=fileUploadErrors[file.error] || file.error%}</td>
      {% } else if (o.files.valid && !i) { %}
      <td class="progress"><div class="progressbar"><div style="width:0%;"></div></div></td>
      <td class="start">{% if (!o.options.autoUpload) { %}<button class="btn primary">Start</button>{% } %}</td>
      {% } else { %}
      <td colspan="2"></td>
      {% } %}
      <td class="cancel">{% if (!i) { %}<button class="btn info">Cancel</button>{% } %}</td>
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

        
        