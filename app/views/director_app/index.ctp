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
        <button>New Gallery</button>
      </footer>
    </div>

    <div class="vdivide draghandle"></div>
  </div>
  <div id="albums" class="vbox flex">
    <div class="show vbox flex">
      <ul class="options hbox">
        <li class="view nobutton">Properties:</li>
        <li class="view showGallery">Gallery</li>
        <li class="view showAlbum">Album</li>
        <li class="view showUpload">Upload Photo</li>
        <li class="view showGrid">Thumb Grid</li>
        <li class="splitter nobutton flex"></li>
        <li class="optEdit">Edit Gallery</li>
        <li class="optEmail">Email Gallery</li>
      </ul>
      <div class="content vbox flex autoflow">
        <div class="header"></div>
        <div class="items"></div>
      </div>
      <div id="views-wrapper" class="hbox autoflow">
        <div id="views" class="vbox flex hdraggable">
          <div class="hdivide draghandle"></div>
          <div id="gallery" class="view flex autoflow" style="">
            <div class="editGallery"></div>
          </div>
          <div id="album" class="view flex autoflow" style="">
            <div class="editAlbum">
              <div class="item">Albums</div>
            </div>
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
        <li class="optSave default">Save Gallery</li>
        <li class="optDestroy">Delete Gallery</li>
      </ul>
      <div class="content vbox flex autoflow"></div>
    </div>
  </div>

</div>

<script type="text/x-jquery-tmpl" id="galleriesTemplate">
  <li class="item" title="Doubleclick to edit / Save with Enter">
    <img src="/img/gallery.png" />
    <div style="font-size: 0.6em">ID: ${id}</div
    {{if name}}
    <span class="name">${name}</span>
    {{else}}
    <span class="name empty">No Name</span>
    {{/if}}
    <span class="cta">&gt;</span>
  </li>
</script>

<script type="text/x-jquery-tmpl" id="albumsTemplate">
  <li class="item thumbnail" >
    <span style="font-size: 0.6em">ID: ${id}</span>
    {{if name}}
    <div class="name">${name}</div>
    {{else}}
    <div class="name empty">No Name</div>
    {{/if}}
    {{if title}}
    <div class="name">${title}</div>
    {{else}}
    <div class="name empty">No Title</div>
    {{/if}}
  </li>
</script>  

<script type="text/x-jquery-tmpl" id="editGalleryTemplate">
  
  <label>
    <span>Gallery name</span>
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

<script type="text/x-jquery-tmpl" id="editAlbumTemplate">
  
  <label>
    <span>Album name</span>
    <input type="text" name="name" value="${name}" autofocus>
  </label>

  <label>
    <span>Album Title</span>
    <input type="text" name="title" value="${title}">
  </label>

  <label>
    <span>Description</span>
    <textarea name="description">${description}</textarea>
  </label>
  
</script>

<script type="text/x-jquery-tmpl" id="noSelectionTemplate">
  <div>${type}</div>
</script>