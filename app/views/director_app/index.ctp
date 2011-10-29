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
          <li class="opt optAlbums">Albums</li>
          <li class="opt optPhotos">Images</li>
          <li class="splitter disabled flex"></li>
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="header"></div>
        <div class="contents views vbox flex autoflow" class="views">
          <div class="view albums content flex">
            <div class="items sortable"></div>
          </div>
          <div class="view images content flex">
            <div class="items sortable"></div>
          </div>
        </div>
        <div id="views" class="canvas-bg-light hbox autoflow">
          <div class="views canvas vbox flex hdraggable">
            <div class="hdivide draghandle"></div>
            <div id="gallery" class="view flex autoflow" style="">
              <div class="editGallery">You have no Galleries!</div>
            </div>
            <div id="album" class="view flex autoflow" style="">
              <div class="editAlbum">
                <div class="item">No Albums found!</div>
              </div>
            </div>
            <div id="photo" class="view flex autoflow" style="">
              <label>
                <span class="dimmed">Not quite there yet</span>
              </label>
            </div>
            <div id="upload" class="view flex autoflow" style="">
              <label>
                <span class="dimmed">Not quite there yet</span>
              </label>
            </div>
            <div id="grid" class="view flex autoflow" style="">
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
          <li class="opt optGrid">Grid</li>
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

<script type="text/x-jquery-tmpl" id="galleriesTemplate">
  <li id="${id}" class="gal item" title="Deselect   Cmd-Click">
    <div class="item-header">
      <div class="expander"></div>
      <div class="item-content">
        {{if name}}
        <span class="name">${name}</span>
        {{else}}
        <span class="name empty">No Name</span>
        {{/if}}
        <span class="author">{{if author}} by ${author}{{else}}(no author){{/if}}</span>
        <span class="cta">{{if count}}${count}{{else}}0{{/if}}</span>
      </div>
    </div>
    <hr>
    <ul class="sublist" style="display: none;"></ul>
  </li>
</script>

<script type="text/x-jquery-tmpl" id="albumsSubListTemplate">
  {{if flash}}<span class="author">${flash}</span>{{else}}
  <li class="sublist-item alb item" draggable="true" title="Move (Hold Cmd-Key to Copy)">
    {{if title}}<span class="title">{{html title}}</span>{{/if}}
  </li>
  {{/if}}
</script>

<script type="text/x-jquery-tmpl" id="albumsTemplate">
  <li class="item">
    <div class="thumbnail" draggable="true">
      {{if title}}
      <div class="name">${title}</div>
      {{else}}
      <div class="name empty">No title</div>
      {{/if}}
    </div>
  </li>
</script>  

<script type="text/x-jquery-tmpl" id="editGalleryTemplate">
  <div class="flex">
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

<script type="text/x-jquery-tmpl" id="editAlbumTemplate">
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

<script type="text/x-jquery-tmpl" id="toolsTemplate">
    <li class="{{if disabled}}disabled{{/if}} ${klass}">${name}</li>
</script>

<script type="text/x-jquery-tmpl" id="noSelectionTemplate">
  {{html type}}
</script>

<script type="text/x-jquery-tmpl" id="headerTemplate">
  {{if record}}
  <h3>Author: <label> ${record.author}</label></h3>
  <h2>${record.name}</h2>
  {{else}}
  <h3>Album Originals</h3>
  <h2>All Albums</h2>
  {{/if}}
  <span class="active cta {{if record}}active{{/if}} right"><h2>{{if count}}${count}{{else}}0{{/if}}</h2></span>
</script>

<script type="text/x-jquery-tmpl" id="loginTemplate">
  <button class="dark clear logout" title="Group ${groupname}">Logout ${name}</button>
</script>

