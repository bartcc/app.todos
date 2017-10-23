<header id="title">
    <a href="/"><h1>Spine Contacts</h1></a>
</header>

<div id="wrapper" class="hbox flex">
  <div id="sidebar-wrapper" class="hbox vdraggable">
    <div id="sidebar" class="vbox flex">
      <div class="search">
        <input type="search" placeholder="Search" results="0" incremental="true" autofocus>
      </div>

      <ul class="items vbox flex autoflow"></ul>

      <footer>
        <button>New contact</button>
      </footer>
    </div>

    <div class="vdivide draghandle"></div>
  </div>
  <div id="contacts" class="vbox flex">
    <div class="show vbox flex">
      <ul class="options hbox">
        <li class="view showEditor">Editor</li>
        <li class="view showAlbum">Album</li>
        <li class="view showUpload">Upload Photo</li>
        <li class="view showGrid">Thumb Grid</li>
        <li class="splitter flex"></li>
        <li class="optEdit">Edit contact</li>
        <li class="optEmail">Email contact</li>
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
        <li class="optSave default">Save contact</li>
        <li class="optDestroy">Delete contact</li>
      </ul>
      <div class="content vbox flex autoflow"></div>
    </div>
  </div>

</div>

<script type="text/x-jquery-tmpl" id="contactsTemplate">
  <li class="item" title="Doubleclick to edit / Save with Enter">
    <img src="/img/missing.png" />
    {{if fullName()}}
    <div style="font-size: 0.6em">ID: ${id}</div
    <span class="name">${fullName()}</span>
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

<script type="text/x-jquery-tmpl" id="contactTemplate">
  <label>
    <span>ID: ${id}</span>
  </label>

  <label>
    <span>Name</span>
    {{if fullName()}}
    <div>${fullName()}</div>
    {{else}}
    <div class="empty">Blank</div>
    {{/if}}
  </label>

  <label>
    <span>Email</span>
    {{if email}}
    <div>${email}</div>
    {{else}}
    <div class="empty">Blank</div>
    {{/if}}
  </label>

  {{if mobile}}
  <label>
    <span>Mobile number</span>
    <div>${mobile}</div>
  </label>
  {{/if}}

  {{if work}}
  <label>
    <span>Work number</span>
    <div>${work}</div>
  </label>
  {{/if}}

  {{if address}}
  <label>
    <span>Address</span>
    <div><pre>${address}</pre></div>
  </label>
  {{/if}}

  <label>
    <span>Notes</span>
    {{if notes}}
    <div>${notes}</div>
    {{else}}
    <div class="empty">Blank</div>
    {{/if}}
  </label>
</script>

<script type="text/x-jquery-tmpl" id="editContactTemplate">
  
  <label>
    <span>First name</span>
    <input type="text" name="first_name" value="${first_name}" autofocus>
  </label>

  <label>
    <span>Last name</span>
    <input type="text" name="last_name" value="${last_name}">
  </label>

  <label>
    <span>Email</span>
    <input type="text" name="email" value="${email}">
  </label>

  <label>
    <span>Mobile number</span>
    <input type="text" name="mobile" value="${mobile}">
  </label>

  <label>
    <span>Work number</span>
    <input type="text" name="work" value="${work}">
  </label>

  <label>
    <span>Address</span>
    <textarea name="address">${address}</textarea>
  </label>

  <label>
    <span>Notes</span>
    <textarea name="notes">${notes}</textarea>
  </label>
  <input type="hidden" name="id" value="${id}" autofocus>
</script>  