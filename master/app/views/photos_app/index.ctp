<header id="title">
    <h1>Spine Photos</h1>
</header>

<div id="wrapper" class="hbox flex">

    <div id="sidebar" class="vbox">
        <div class="search">
            <input type="search" placeholder="Search" results="0" incremental="true" autofocus>
        </div>

        <ul class="items vbox flex autoflow"></ul>

        <footer>
            <button>New Image</button>
        </footer>
    </div>
    
    <div class="vdivide"></div>
    
    <div id="images" class="vbox flex">
        <div class="show vbox flex">
            <ul class="options">
                <li class="optEdit">Edit Image</li>
                <li class="optEmail">Email Image</li>
            </ul>
            <div class="content vbox flex autoflow"></div>
        </div>

        <div class="edit vbox flex">
            <ul class="options">
                <li class="optSave default">Save Image</li>
                <li class="optDestroy">Delete Image</li>
            </ul>
            <div class="content vbox flex autoflow"></div>
        </div>
    </div>

</div>

<script type="text/x-jquery-tmpl" id="imagesTemplate">
    <li class="item">
        <img src="/img/missing.png" />
        {{if name}}
        <span class="name">${name}</span>
        {{else}}
        <span class="name empty">No Name</span>
        {{/if}}
        <span class="cta">&gt;</span>
    </li>
</script>  

<script type="text/x-jquery-tmpl" id="imageTemplate">

    <label>
        <span>ID</span>
        {{if id}}
        ${id}
        {{else}}
        <div class="empty">Blank</div>
        {{/if}}
    </label>
    
    <label>
        <span>Name</span>
        ${name}
    </label>
    
    <label>
        <span>Description</span>
        {{if description}}
        ${description}
        {{else}}
        <div class="empty">Blank</div>
        {{/if}}
    </label>

    {{if exposure}}
    <label>
        <span>Exposure</span>
        ${exposure}
    </label>
    {{/if}}

    {{if tags}}
    <label>
        <span>Tags</span>
        ${tags}
    </label>
    {{/if}}

</script>

<script type="text/x-jquery-tmpl" id="editImageTemplate">
    <label>
        <span>ID</span>
        {{if id}}
        ${id}
        {{else}}
        <div class="empty">Blank</div>
        {{/if}}
    </label>
    <label>
        <span>Name</span>
        <input type="text" name="name" value="${name}" autofocus>
    </label>

    <label>
        <span>Description</span>
        <textarea name="description">${description}</textarea>
    </label>

    <label>
        <span>Exposure</span>
        <input type="text" name="exposure" value="${exposure}">
    </label>

    <label>
        <span>Tags</span>
        <input type="text" name="tags" value="${tags}">
    </label>
</script>