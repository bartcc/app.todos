<script type="text/x-jquery-tmpl" id="taskTemplate">
    <div class="item {{if done}}done{{/if}}">
    <div class="view" title="Double click to edit...">
    <input type="checkbox" {{if done}}checked="checked"{{/if}}> 
    <span>${name}</span> <a class="destroy"></a>
    </div>

    <div class="edit">
    <input type="text" value="${name}">
    </div>
    </div>
</script>
<script type="text/x-jquery-tmpl" id="stats-template">
    <button class="clear right {{if !done}}disabled{{/if}}" {{if !done}}disabled=''{{/if}}>{{if done}}Clear ${done} completed{{else}}No completed tasks{{/if}}</button>
</script>
<script type="text/x-jquery-tmpl" id="button-checkall-template">
    <button title="Check all Todos" class="primary_lg {{if remaining==0}} disabled {{/if}}" type="button" {{if remaining==0}} disabled {{/if}}>${value}</button>
</script>
<script type="text/x-jquery-tmpl" id="button-uncheckall-template">
    <button title="Uncheck all Todos" class="primary_lg {{if done==0}} disabled {{/if}}" type="button" {{if done==0}} disabled {{/if}}>${value}</button>
</script>
<script type="text/x-jquery-tmpl" id="button-unsaved-template">
    <button title="Save all local changes" class="primary_lg {{if unsaved==0}} disabled {{else}} alert {{/if}}" type="button" {{if unsaved==0}} disabled {{/if}}>${value}</button>
</script>
<script type="text/x-jquery-tmpl" id="button-refresh-template">
    <button title="Reloads a fresh set from server" class="primary_lg {{if busy}} disabled {{/if}}" type="button" {{if busy}} disabled {{/if}}>${value}</button>
</script>
<script type="text/x-jquery-tmpl" id="button-storage-template">
    <button title="Reloads a fresh set from server" class="primary_lg {{if busy}} disabled {{/if}}" type="button" {{if busy}} disabled {{/if}}>${value}</button>
</script>

<header id="title">
    <h1><a href="/">Todos</a></h1>
</header>

<div id="wrapper" class="hbox flex">
    <div id="sidebar" class="vbox">
        <div class="vbox flex">
            <div id="todo-controls" class="vbox flex">
                <span id="button-checkall"></span>
                <span id="button-uncheckall"></span>
                <span id="button-unsaved"></span>
                <span id="button-refresh"></span>
            </div>
            <div class="hbox">
                <footer class="vbox flex">
                    <div style="height: 33px;">
                        <button id="refresh-db" class="light" style="width: 100%" onclick="window.location.href = base_url + 'mysql/restore/todos_spine/'">Restore</button>
                    </div>
                </footer>
            </div>
        </div>
    </div>
    <div class="vdivide"></div>
    <div id="views" class="vbox flex">
        <div id="tasks" class="vbox flex">
            <div id="create-todo" class="hbox">
                <div class="new-todo flex" id="new-todo">
                    <input type="text" placeholder="What needs to be done?">
                    <span class="ui-tooltip-top" style="display:none;">Press Enter to save this task</span>
                </div>
                <span id="ballon" class="count"><span class="countVal"></span></span>
            </div>

            <div class="items vbox flex autoflow"></div>

            <footer>
                <div id="stats"></div>
            </footer>
        </div>
    </div>
</div>
