<header id="title">
  <h1>Spine Director</h1>
</header>

<div id="wrapper" class="hbox flex">
  <div id="sidebar-wrapper" class="hbox vdraggable">
    <div id="sidebar" class="vbox flex">
      <div class="search">
        <input type="search" placeholder="Search" results="0" incremental="true" autofocus>
      </div>

      <ul class="items vbox flex autoflow"></ul>

      <footer>
        <button>New Album</button>
      </footer>
    </div>

    <div class="vdivide draghandle"></div>
  </div>
  <div id="galleries" class="vbox flex">
    <div class="show vbox flex">
      <ul class="options hbox">
        <li class="view showEditor">Editor</li>
        <li class="view showAlbum">Album</li>
        <li class="view showUpload">Upload Photo</li>
        <li class="view showGrid">Thumb Grid</li>
        <li class="splitter flex"></li>
        <li class="optEdit">Edit album</li>
        <li class="optEmail">Email album</li>
      </ul>
      <div class="content vbox flex autoflow"></div>
      <div id="views-wrapper" class="hbox autoflow">
        <div id="views" class="vbox flex hdraggable">
          <div class="hdivide draghandle"></div>
          <div id="editor" class="view flex autoflow" style="">
            <div class="editEditor"></div>
          </div>
          <div id="album" class="view flex autoflow" style="">
            <div class="editAlbum">Album</div>
          </div>
          <div id="upload" class="view flex autoflow" style="">
            <div>Upload</div>
          </div>
          <div id="grid" class="view flex autoflow" style="">
            <div>Grid</div>
          </div>
        </div>
      </div>  
    </div>
    <div class="edit vbox flex">
      <ul class="options hbox">
        <li class="splitter flex"></li>
        <li class="optSave default">Save album</li>
        <li class="optDestroy">Delete album</li>
      </ul>
      <div class="content vbox flex autoflow"></div>
    </div>
  </div>

</div>

<script type="text/x-jquery-tmpl" id="galleriesTemplate">
  <li class="item" title="Doubleclick to edit / Save with Enter">
    <img src="/img/missing.png" />
    <div style="font-size: 0.6em">ID: ${id}</div
    {{if name}}
    <span class="name">${name}</span>
    {{else}}
    <span class="name empty">No Name</span>
    {{/if}}
    <span class="cta">&gt;</span>
  </li>
</script>  

<script type="text/x-jquery-tmpl" id="detailsViewTemplate">
  <div>
    Details
  </div>
</script>

<script type="text/x-jquery-tmpl" id="albumTemplate">
  <label>
    <span>ID: ${id}</span>
  </label>

  <label>
    <span>Name</span>
    {{if name}}
    <div>${name}</div>
    {{else}}
    <div class="empty">Blank</div>
    {{/if}}
  </label>

  <label>
    <span>Author</span>
    {{if author}}
    <div>${author}</div>
    {{else}}
    <div class="empty">Blank</div>
    {{/if}}
  </label>

  <label>
    <span>Description</span>
    {{if description}}
    <div>${description}</div>
    {{else}}
    <div class="empty">Blank</div>
    {{/if}}
  </label>
</script>

<script type="text/x-jquery-tmpl" id="editAlbumTemplate">
  
  <label>
    <span>Album name</span>
    <input type="text" name="name" value="${name}" autofocus>
  </label>

  <label>
    <span>Author</span>
    <input type="text" name="author" value="${author}">
  </label>

  <label>
    <span>Description</span>
    <textarea name="description">${description}</textarea>
  </label>
  <input type="hidden" name="id" value="${id}" autofocus>
</script>  