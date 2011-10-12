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
  <div id="albums" class="views vbox flex">
    <div class="show view vbox flex">
      <ul class="options hbox">
        <li class="opt optOverview">Overview</li>
        <li class="splitter disabled flex"></li>
        <ul class="toolbar hbox"></ul>
      </ul>
      <div class="content vbox flex autoflow">
        <div class="header"></div>
        <div class="items sortable">No Albums found!</div>
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
            <div>Not quite there yet</div>
          </div>
          <div id="grid" class="view flex autoflow" style="">
            <div>Not quite there yet</div>
          </div>
        </div>
      </div>  
      <ul class="options hbox">
        <li class="disabled">Properties:</li>
        <li class="opt optGallery">Gallery</li>
        <li class="opt optAlbum">Album</li>
        <li class="opt optUpload">Upload Photo</li>
        <li class="opt optGrid">Thumb Grid</li>
      </ul>
    </div>
    <div class="edit view vbox flex">
      <ul class="tools options hbox">
        <li class="splitter disabled flex"></li>
        <li class="optSave default">Save and Close</li>
        <li class="optDestroy">Delete Gallery</li>
      </ul>
      <div class="content vbox flex autoflow"></div>
    </div>
  </div>

</div>

<script type="text/x-jquery-tmpl" id="galleriesTemplate">
  <li id="${id}" class="item droppable" title="Deselect   Cmd-Click">
    <div class="item-expander"></div>
    <div class="item-content">
      {{if name}}
      <span class="name">${name}</span>
      {{else}}
      <span class="name empty">No Name</span>
      {{/if}}
      <span class="cta">${count}</span>
      {{if author}}
      <span class="author">(${author})</span>
      {{/if}}
    </div>
  </li>
  <ul id="sub-${id}" class="sublist vbox" style="display: none;"></ul>
</script>

<script type="text/x-jquery-tmpl" id="albumsSubListTemplate">
  <li class="sublist-item" draggable="true" title="Move (Hold Cmd-Key to Copy)">
    {{if name}}
    <span class="name">${name}</span>
    {{/if}}
  </li>
</script>

<script type="text/x-jquery-tmpl" id="albumsTemplate">
  <li class="item thumbnail" draggable="true">
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

<script type="text/x-jquery-tmpl" id="toolsTemplate">
    
    <li class="{{if disabled}}disabled{{/if}} ${klass}">${name}</li>
  
</script>

<script type="text/x-jquery-tmpl" id="noSelectionTemplate">
  <div>${type}</div>
</script>

<script type="text/x-jquery-tmpl" id="headerTemplate">
  <h3>Gallery: ${record.name} <span style="color: #D0D0D0; font-style: normal; font-weight: 100; font-size: 1.2em;">&nbsp;||&nbsp;</span> Author: ${record.author}</h3>
  <h2>{{if count}}${count} Album{{if count>1}}s{{/if}}{{else}}No Albums{{/if}}</h2>
</script>