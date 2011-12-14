<div id="messenger" style="display: none">
  <div class="dialogue-wrap transparent" id="messenger">
    <div class="dialogue">
      <div style="width:525px; min-width:500px;" class="morph dialogue-content" id="morph_messenger-wrap">
        <div class="bg verticaltop" id="draggable-messenger-wrap">
          <header>
            <fieldset class="right">
              <button class="_close light window input">x</button>
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
    <h1>Photo Director</h1>
    <div id="login" class="flex tright" style="margin-top: 8px;"></div>
  </header>
  <div id="wrapper" class="hbox flex">
    <div id="sidebar" class="views canvas-bg-medium hbox vdraggable">
      <div class="vbox flex inner">
        <div class="search">
          <input type="search" placeholder="Search" results="0" incremental="true" autofocus>
        </div>
        <div class="originals hbox">
          <ul class="options hbox flex">
            <li class="optAllAlbums"><span>all albums</span></li>
            <li class="splitter disabled flex"></li>
            <li class="optAllPhotos"><span>all photos</span></li>
          </ul>
        </div>
        <ul class="items canvas vbox flex autoflow"></ul>
        <footer class="footer">
          <button class="">New Gallery</button>
        </footer>
      </div>
      <div class="vdivide draghandle"></div>
    </div>
    <div id="content" class="views canvas-bg-dark vbox flex">
      <div class="overview view content canvas vbox flex">
        <ul class="tools options hbox">
          <li class="optClose opt">Close</li>
          <li class="splitter disabled flex"></li>
        </ul>
        <div class="flex vbox autoflow">
          <div class="container">
            <fieldset>
              <label class="invite"><span class="enlightened">Recently Uploaded:</span></label>
              <div class="items"></div>
            </fieldset>
            <fieldset>
              <label class="invite"><span class="enlightened">Summary:</span></label>
              <div class="info">
                Blank 
              </div>
            </fieldset>
          </div>
          <div class="container">
            <fieldset>
              <label class="invite"><span class="enlightened">Informations:</span></label>
            </fieldset>
          </div>
        </div>
      </div>
      <div class="show view canvas vbox flex">
        <ul class="options hbox">
          <li class="opt optOverview">Overview</li>
          <li class="splitter disabled flex"></li>
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="contents views vbox flex">
          <div class="header views">
            <div class="galleriesHeader view"></div>
            <div class="albumsHeader view"></div>
            <div class="photosHeader view"></div>
            <div class="photoHeader view"></div>
          </div>
          <div class="view galleries content vbox flex data autoflow">
            <div class="preview"></div>
            <div class="items sortable"></div>
          </div>
          <div class="view albums content vbox flex data autoflow">
            <div class="preview"></div>
            <div class="items sortable"></div>
          </div>
          <div class="view photos content vbox flex data autoflow">
            <div class="preview"></div>
            <div class="items sortable flex"></div>
          </div>
          <div class="view photo content vbox flex data autoflow">
            <div class="preview"></div>
            <div class="items sortable flex">PHOTO</div>
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
                <div class="content">No Albums found!</div>
              </div>
            </div>
            <div id="photo" class="view items flex autoflow" style="">
              <div class="editPhoto">
                <div class="content">No Photo found!</div>
              </div>
            </div>
            <div id="fileupload" class="view items flex autoflow" style=""></div>
            <div id="slideshow" class="view items flex autoflow" style="">
              <label>
                <span class="disabled">Not quite there yet</span>
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

<script id="sidebarTemplate" type="text/x-jquery-tmpl">
  <li class="gal item data" title="Deselect   Cmd-Click">
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
    <span>${aCount} </span><span style="font-size: 0.5em;"> (${iCount})</span>
</script>

<script id="albumDetailsTemplate" type="text/x-jquery-tmpl">
  <span class="cta">${iCount}</span>
</script>

<script id="albumsSublistTemplate" type="text/x-jquery-tmpl">
  {{if flash}}
  <span class="author">${flash}</span>
  {{else}}
  <li class="sublist-item alb item data" draggable="true" title="Move (Hold Cmd-Key to Copy)">
    <span class="title">{{if title}}{{html title}}{{else}}no title{{/if}}</span>
    <span class="cta">{{if count}}${count}{{else}}0{{/if}}</span>
  </li>
  {{/if}}
</script>

<script id="galleriesTemplate" type="text/x-jquery-tmpl">
  <li class="item container">
    <div class="thumbnail" draggable="true">
      <div class="ui-icon"></div>
      {{tmpl($item.data.details()) "#galDetailsTemplate"}}
    </div>
    <div class="title">{{if name}}{{html name}}{{else}}no title{{/if}}</div>
  </li>
</script>

<script id="galDetailsTemplate" type="text/x-jquery-tmpl">
  <div>Albums: <span class="cta">${aCount}</span></div>
  <div>Images: <span class="cta">${iCount}</span></div>
</script>

<script id="albumsTemplate" type="text/x-jquery-tmpl">
  <li class="item container">
    <div class="thumbnail left" draggable="true"></div>
    <div class="title">{{if title}}{{html title}}{{else}}no title{{/if}}</div>
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
        <label>{{if author}}${author}{{else}}no author{{/if}}</label>
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

<script id="editPhotoTemplate" type="text/x-jquery-tmpl">
  <div class="left">
    <label>
      <span>Photo Title</span>
      <input type="text" name="title" value="${title}" >
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
  <li class="{{if disabled}}disabled{{/if}} ${klass}"><span class="tb-name">${name}</span>
    {{if html}}
      {{html html}}
    {{/if}}
  </li>
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
    <h3><span>Album Originals</span></h3>
    <h2>All Albums
      <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{/if}}
  </section>
  <section class="closeView options">
    <ul class="gal">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>Galleries</span>
    </ul>
    <ul class="alb disabled">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>Albums</span>
    </ul>
  </section>
</script>

<script id="headerPhotosTemplate" type="text/x-jquery-tmpl">
  <section class="top">
    {{if gallery}}
    <h3>Gallery: ${gallery.name}</h3>
    {{/if}}
    {{if record}}
    <h2>Album: ${record.title}
      <span class="active cta right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{else}}
    <h3><span>Photo Originals</span><span style="color: rgba(255, 10, 10, 0.8);"> Caution: Deleted Photos are unrecoverable!</span></h3>
    <h2>All Photos
      <span class="active cta right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
    </h2>
    {{/if}}
  </section>
  <section class="closeView options">
    <ul class="gal">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>Galleries</span>
    </ul>
    <ul class="alb">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>Albums</span>
    </ul>
    <ul class="pho disabled">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>Photos</span>
    </ul>
  </section>
</script>

<script id="headerPhotoTemplate" type="text/x-jquery-tmpl">
  <section class="top">
    {{tmpl($item.data.details()) "#photoDetailsTemplate"}}
    <h2>Photo: {{if title}}${title}{{else}}${src}{{/if}}</h2>
  </section>
  <section class="closeView options">
    <ul class="gal">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>Galleries</span>
    </ul>
    <ul class="alb">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>Albums</span>
    </ul>
    <ul class="pho">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>Photos</span>
    </ul>
    <ul class="disabled">
      <li class="ui-button-icon-primary ui-icon ui-icon-carat-1-w left"></li><span>${src}</span>
    </ul>
  </section>
</script>

<script id="photoDetailsTemplate" type="text/x-jquery-tmpl">
  <h3>{{if gallery}}<span>Gallery: ${gallery.name}</span>{{/if}}{{if album}}<span>Album: ${album.title}</span>{{/if}}</h3>
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
  <li class="item container">
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

<script id="albumPreviewTemplate" type="text/x-jquery-tmpl">
  <ul>
    <li class="name"><span class="left">{{if title}}${title}{{else}}no title{{/if}} </span><span class="right"> {{tmpl($item.data.details()) "#albumDetailsTemplate"}}</span></li>
  </ul>
</script>

<script id="photoPreviewTemplate" type="text/x-jquery-tmpl">
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
  {{if album}}
  <form action="" method="POST" enctype="multipart/form-data">
    <label class="fileinput-button">
      <div>
        <span>Drag and drop files here...</span>
      </div>
      <div>
        <span>Target-Album: ${album.title}</span>
      </div>
    </label>
  </form>
  <div class="fileupload-content">
    <table class="files"></table>
    <div class="fileupload-progressbar"></div>
  </div>
  {{else}}
  <label class="">
    <span>No target album selected!</span>
  </label>
  {{/if}}
</script>

<script id="uploadTemplate" type="text/x-jquery-tmpl">
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
    <td class="start"><button></button></td>
    {{/if}}
    <td class="cancel"><button></button></td>
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
      <button data-type="${delete_type}" data-url="${delete_url}"></button>
    </td>
  </tr>
</script>