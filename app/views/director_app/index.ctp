<div id="main" class="view vbox flex">
  <header id="title" class="hbox">
    <h1>Spine Director</h1>
    <div id="login" class="flex tright" style="margin-top: 8px;"></div>
  </header>

  <div id="wrapper" class="hbox flex">
    <div id="sidebar" class="hbox vdraggable">
      <div class="vbox flex inner">
        <div class="search">
          <input type="search" placeholder="Search" results="0" incremental="true" autofocus>
        </div>
        <ul class="items vbox flex autoflow"></ul>
        <footer class="footer">
          <button class="">New Gallery</button>
        </footer>
      </div>
      <div class="vdivide draghandle"></div>
    </div>
    <div id="albums" class="views vbox flex">
      <div class="show view vbox flex">
        <ul class="options hbox">
          <li class="opt optOverview">Overview</li>
          <li class="splitter disabled flex"></li>
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="header"></div>
        <div class="content vbox flex autoflow">
          <div class="items sortable"></div>
        </div>
        <div id="views" class="hbox autoflow">
          <div class="views vbox flex hdraggable">
            <div class="hdivide draghandle"></div>
            <div id="gallery" class="view flex autoflow" style="">
              <div class="editGallery">You have no Galleries!</div>
            </div>
            <div id="album" class="view flex autoflow" style="">
              <div class="editAlbum">
                <div class="item">No Albums found!</div>
              </div>
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
          <li class="opt optUpload">Upload Photo</li>
          <li class="opt optGrid">Thumb Grid</li>
        </ul>
      </div>
      <div class="edit view vbox flex">
        <ul class="tools options hbox">
          <li class="optOptions opt">Options</li>
          <li class="splitter disabled flex"></li>
          <ul class="toolbar hbox"></ul>
        </ul>
        <div class="content vbox flex autoflow"></div>
      </div>
    </div>
  </div>
</div>
<div id="loader" class="view">
  <div class="dialogue-wrap">
    <div class="dialogue">
      <div class="dialogue-content">
        <div class="bg transparent" style="height: 100px;">
          <img id="icon" src="/img/ajax-loader.gif">
          <div id="status">Verifying User...</div>
        </div>
      </div>
    </div>
  </div>
</div>

<script type="text/x-jquery-tmpl" id="galleriesTemplate">
  <li id="${id}" class="item" title="Deselect   Cmd-Click">
    <div class="item-expander">
      <div class="expander"></div>
      <div class="item-content">
        {{if name}}
        <span class="name">${name}</span>
        {{else}}
        <span class="name empty">No Name</span>
        {{/if}}
        <span class="author">{{if author}} by ${author}{{else}}(no author){{/if}}</span>
        <span class="cta">${count}</span>
      </div>
    </div>
  </li>
  <ul id="sub-${id}" class="sublist vbox" style="display: none;"></ul>
</script>

<script type="text/x-jquery-tmpl" id="albumsSubListTemplate">
  <li class="sublist-item item" draggable="true" title="Move (Hold Cmd-Key to Copy)">
    {{if title}}
    <span class="title">${title}</span>
    {{/if}}
  </li>
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
        {{if author}}
        <div class="name" >${author}</div>
        {{else}}
          <div class="name">No author</div>
        {{/if}}
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
  <h3>Gallery: ${record.name} <span>Author: ${record.author}</span></h3>
  <h2>Albums</h2>
  {{else}}
  <h3>Album Originals</h3>
  <h2>All Albums</h2>
  {{/if}}
  <span class="cta right"><h2>${count}</h2></span>
</script>

<script type="text/x-jquery-tmpl" id="loginTemplate">
  <button class="dark clear logout" title="Group ${groupname}">Logout ${name}</button>
</script>

