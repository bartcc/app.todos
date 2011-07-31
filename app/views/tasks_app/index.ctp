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
    <span class="word">{{if remaining == 1 ? 'item' : 'items' }}</span> left.
  </span>
  {{/if}}
  {{ if done }}
  <span class="todo-clear">
    <a href="#">
      Clear <span class="number-done">{ done }</span>
      completed <span class="word-done">{{ done == 1 ? 'item' : 'items' }}</span>
    </a>
  </span>
  {{/if}}
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
<div id="views">
  <div id="tasks">
    <h1>Life Tasks</h1>

    <form id="create-todo">
      <input id="new-todo" type="text" placeholder="What needs to be done?">
      <span class="ui-tooltip-top" style="display:none;">Press Enter to save this task</span>
    </form>
    <div>
      <div id="todo-controls">
        <fieldset>
          <legend>Client only settings</legend>
          <span id="button-checkall"></span>
          <span id="button-uncheckall"></span>
        </fieldset>
        <fieldset>
          <legend>Synchronize</legend>
          <span id="button-unsaved"></span>
          <span id="button-refresh"></span>
        </fieldset>
      </div>
    </div>
    <div class="items"></div>

    <footer>
      <a class="clear">Clear completed</a>
      <div class="count"><span class="countVal"></span> left</div>
    </footer>
  </div>
</div>