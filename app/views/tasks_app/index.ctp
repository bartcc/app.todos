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
  {{if total}}
  <span class="todo-count">
    <span class="number">{ remaining }</span>
    <span class="word">{{if remaining == 1 ? 'item' : 'items' }}</span> lefft.
  </span>
  {{/if}}
  <span class="todo-clear">
    <a href="#">
    {{ if done }}
      All <span class="number-done">{ done }</span>
      completed <span class="word-done">{{ done == 1 ? 'item' : 'items' }}</span>
    {{ else }}
      Clear <span class="number-done"></span>
      completed <span class="word-done"></span>
    {{/if}}
    </a>
  </span>
</script>

<script type="text/x-jquery-tmpl" id="button-checkall-template">
  <button title="Check all Todos" class="primary_lg {{if remaining==0}} disabled {{/if}}" type="button" {{if remaining==0}} disabled {{/if}}>${value}</button>
</script>

<script type="text/x-jquery-tmpl" id="button-uncheckall-template">
  <button title="Uncheck all Todos" class="primary_lg {{if done==0}} disabled {{/if}}" type="button" {{if done==0}} disabled {{/if}}>${value}</button>
</script>

<script type="text/x-jquery-tmpl" id="button-unsaved-template">
  <button title="Save all local changes" class="primary_lg {{if unsaved==0}} disabled {{/if}}" type="button" {{if unsaved==0}} disabled {{/if}}>${value}</button>
</script>

<script type="text/x-jquery-tmpl" id="button-refresh-template">
  <button title="Reloads a fresh set from server" class="primary_lg {{if busy}} disabled {{/if}}" type="button" {{if busy}} disabled {{/if}}>${value}</button>
</script>
<header id="title">
  <h1>Todos</h1>
  <span class="info">(dev branch)</span>
</header>

<div id="wrapper" class="hbox flex">
  <div id="sidebar" class="vbox">
    <div>
      <div id="todo-controls">
        <span id="button-checkall"></span>
        <span id="button-uncheckall"></span>
        <span id="button-unsaved"></span>
        <span id="button-refresh"></span>
      </div>
    </div>
  </div>
  <div class="vdivide"></div>
  <div id="views" class="vbox flex">
    <div id="tasks" class="vbox flex">
      <div id="create-todo">
        <div class="new-todo" id="new-todo">
          <input type="text" placeholder="What needs to be done?">
          <span class="ui-tooltip-top" style="display:none;">Press Enter to save this task</span>
          <div id="ballon" class="count right"><span class="countVal"></span></div>
        </div>
      </div>
      
      <div class="items vbox flex autoflow"></div>
      
      <footer>
        <button class="clear right">Clear completed</button>
      </footer>
    </div>
  </div>
</div>
