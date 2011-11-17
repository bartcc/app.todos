<div id="main" class="view vbox flex">
  <header id="title" class="hbox">
    <h1>Spine Director</h1>
    <div id="login" class="flex tright" style="margin-top: 8px;"></div>
  </header>

  <div id="wrapper" class="hbox flex">
    <div id="sidebar" class="views canvas-bg-medium hbox vdraggable">
      <div class="vbox flex inner">
        <div class="search">
          <input type="search" placeholder="Search" results="0" incremental="true" autofocus>
        </div>
        <ul class="items canvas vbox flex autoflow"></ul>
        <footer class="footer">
          <button class="">New Gallery</button>
        </footer>
      </div>
      <div class="vdivide draghandle"></div>
    </div>
    <div id="content" class="views canvas-bg-dark vbox flex">
      <div class="show view canvas vbox flex">
        <ul class="options hbox">
          <li class="opt optOverview">Overview</li>
          <li class="splitter disabled flex"></li>
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="contents views vbox flex autoflow">
          <div class="view albums content flex data">
            <div class="header"></div>
            <div class="items sortable">Albums</div>
          </div>
          <div class="view photos content flex data">
            <div class="header"></div>
            <div class="items sortable">Images</div>
          </div>
        </div>
        <div id="views" class="canvas-bg-light hbox autoflow">
          <div class="views content canvas vbox flex hdraggable">
            <div class="hdivide draghandle"></div>
            <div id="gallery" class="view items flex autoflow" style="">
              <div class="editGallery">You have no Galleries!</div>
            </div>
            <div id="album" class="view items flex autoflow" style="">
              <div class="editAlbum">
                <div class="item">No Albums found!</div>
              </div>
            </div>
            <div id="photo" class="view items flex autoflow" style="">
              <label>
                <span class="dimmed">Not quite there yet</span>
              </label>
            </div>
            <div id="fileupload" class="view items flex autoflow" style="">
              <form action="/uploads/image" method="POST" enctype="multipart/form-data">
                <div class="fileupload-buttonbar">
                  <label class="fileinput-button">
                    <span>Drag and drop files here...</span>
                    <input type="file" name="files[]" multiple>
                  </label>
                  <button type="submit" class="start">Start upload</button>
                  <button type="reset" class="cancel">Cancel upload</button>
                  <button type="button" class="delete">Delete files</button>
                </div>
              </form>
              <div class="fileupload-content">
                <table class="files"></table>
                <div class="fileupload-progressbar"></div>
              </div>
            </div>
            <div id="slideshow" class="view items flex autoflow" style="">
              <label>
                <span class="dimmed">Not quite there yet</span>
              </label>
            </div>
          </div>
        </div>  
        <ul class="options hbox">
          <li class="disabled">…</li>
          <li class="opt optGallery">Gallery</li>
          <li class="opt optAlbum">Album</li>
          <li class="opt optPhoto">Image</li>
          <li class="opt optUpload">Upload</li>
          <li class="opt optSlideshow">Slideshow</li>
        </ul>
      </div>
      <div class="edit canvas-bg-light view vbox flex">
        <ul class="tools options hbox">
          <li class="optOptions opt">Options</li>
          <li class="splitter disabled flex"></li>
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="content canvas vbox flex autoflow"></div>
      </div>
    </div>
  </div>
</div>
<div id="loader" class="view">
  <div class="dialogue-wrap">
    <div class="dialogue">
      <div class="dialogue-content">
        <div class="bg transparent" style="line-height: 0.5em;">
          <div class="status-symbol" style="z-index: 2;">
            <img src="/img/ajax-loader.gif" style="">
          </div>
          <div class="status-text">Verifying Account</div>
        </div>
      </div>
    </div>
  </div>
</div>

<script id="galleriesTemplate" type="text/x-jquery-tmpl">
  <li id="${id}" class="gal item data" title="Deselect   Cmd-Click">
    <div class="item-header">
      <div class="expander"></div>
      <div class="item-content">
        {{if name}}
        <span class="name">${name}</span>
        {{else}}
        <span class="name empty">No Name</span>
        {{/if}}
        <span class="author">{{if author}} by ${author}{{else}}(no author){{/if}}</span>
        <span class="gal cta"></span>
      </div>
    </div>
    <hr>
    <ul class="sublist" style="display: none;"></ul>
  </li>
</script>

<script id="albumsSublistTemplate" type="text/x-jquery-tmpl">
  {{if flash}}
  <span class="author">${flash}</span>
  {{else}}
  <li class="sublist-item alb item" draggable="true" title="Move (Hold Cmd-Key to Copy)">
    <span class="title">{{if title}}{{html title}}{{/if}}</span>
    <span class="cta">{{if count}}${count}{{else}}0{{/if}}</span>
  </li>
  {{/if}}
</script>

<script id="albumsTemplate" type="text/x-jquery-tmpl">
  <li class="item">
    <div class="thumbnail" draggable="true">
    </div>
    {{if title}}
    <div class="name">${title}</div>
    {{else}}
    <div class="name empty">No title</div>
    {{/if}}
  </li>
</script>

<script id="editGalleryTemplate" type="text/x-jquery-tmpl">
  <div class="flex items">
    <div class="left">
      <label>
        <span>Gallery Name</span>
        <input type="text" name="name" value="${name}">
      </label>

      <label>
        <span>Author</span>
        <label>{{if author}}${author}{{else}}No author{{/if}}</label>
      </label>
    </div>
    <div class="left">
      <label>
        <span>Description</span>
        <textarea name="description">${description}</textarea>
      </label>
    </div>
    <input type="hidden" name="id" value="${id}">
  </div>
</script>

<script id="editAlbumTemplate" type="text/x-jquery-tmpl">
  <div class="left">
    <label>
      <span>Album Title</span>
      <input type="text" name="title" value="${title}" {{if newRecord}}autofocus{{/if}}>
    </label>
  </div>
  <div class="left">
    <label>
      <span>Description</span>
      <textarea name="description">${description}</textarea>
    </label>
  </div>
</script>

<script id="toolsTemplate" type="text/x-jquery-tmpl">
  <li class="{{if disabled}}disabled{{/if}} ${klass}">${name}</li>
</script>

<script id="noSelectionTemplate" type="text/x-jquery-tmpl">
  {{html type}}
</script>

<script id="headerGalleryTemplate" type="text/x-jquery-tmpl">
  {{if record}}
  <h3>Author: <label> ${record.author}</label></h3>
  <h2>Gallery: ${record.name}</h2>
  {{else}}
  <h3>Album Originals</h3>
  <h2>All Albums</h2>
  {{/if}}
  <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
</script>

<script id="headerAlbumTemplate" type="text/x-jquery-tmpl">
  {{if gallery}}
  <h3>${gallery.name}</h3>
  {{/if}}
  {{if record}}
  <h2>Album: ${record.title}</h2>
  {{else}}
  <h3>Album Originals</h3>
  <h2>All Albums</h2>
  {{/if}}
  <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
</script>

<script id="loginTemplate" type="text/x-jquery-tmpl">
  <button class="dark clear logout" title="Group ${groupname}">Logout ${name}</button>
</script>

<script id="photosTemplate" type="text/x-jquery-tmpl">
  <li class="item">
    <div class="thumbnail image" style="background-image: url(${src})" draggable="true">
      {{if src}}
      <div class="name"></div>
      {{else}}
      <div class="name empty">No name</div>
      {{/if}}
    </div>
  </li>
</script>

<script id="preloaderTemplate" type="text/x-jquery-tmpl">
  <div class="preloader">
    <div class="content">
      <div></div
    </div>
  </div>
</script>

<script id="template-upload" type="text/x-jquery-tmpl">
  <tr class="template-upload{{if error}} ui-state-error{{/if}}">
    <td class="preview"></td>
    <td class="name">{{if name}}${name}{{else}}Untitled{{/if}}</td>
    <td class="size">${sizef}</td>
    {{if error}}
    <td class="error" colspan="2">Error:
      {{if error === 'maxFileSize'}}File is too big
      {{else error === 'minFileSize'}}File is too small
      {{else error === 'acceptFileTypes'}}Filetype not allowed
      {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
      {{else}}${error}
      {{/if}}
    </td>
    {{else}}
    <td class="progress"><div></div></td>
    <td class="start"><button>Start</button></td>
    {{/if}}
    <td class="cancel"><button>Cancel</button></td>
  </tr>
</script>

<script id="template-download" type="text/x-jquery-tmpl">
  <tr class="template-download{{if error}} ui-state-error{{/if}}">
    {{if error}}
    <td></td>
    <td class="name">${name}</td>
    <td class="size">${sizef}</td>
    <td class="error" colspan="2">Error:
      {{if error === 1}}File exceeds upload_max_filesize (php.ini directive)
      {{else error === 2}}File exceeds MAX_FILE_SIZE (HTML form directive)
      {{else error === 3}}File was only partially uploaded
      {{else error === 4}}No File was uploaded
      {{else error === 5}}Missing a temporary folder
      {{else error === 6}}Failed to write file to disk
      {{else error === 7}}File upload stopped by extension
      {{else error === 'maxFileSize'}}File is too big
      {{else error === 'minFileSize'}}File is too small
      {{else error === 'acceptFileTypes'}}Filetype not allowed
      {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
      {{else error === 'uploadedBytes'}}Uploaded bytes exceed file size
      {{else error === 'emptyResult'}}Empty file upload result
      {{else}}${error}
      {{/if}}
    </td>
    {{else}}
    <td class="preview">
      {{if thumbnail_url}}
      <a href="${url}" target="_blank"><img src="${thumbnail_url}"></a>
      {{/if}}
    </td>
    <td class="name">
      <a href="${url}"{{if thumbnail_url}} target="_blank"{{/if}}>${name}</a>
    </td>
    <td class="size">${sizef}</td>
    <td colspan="2"></td>
    {{/if}}
    <td class="delete">
      <button data-type="${delete_type}" data-url="${delete_url}">Delete</button>
    </td>
  </tr>
</script>