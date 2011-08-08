<div id="todoapp">

  <div class="title" style="text-align: center; margin-bottom: 30px;">
    <h1 style="display: inline;">Todos Dev</h1>
    <div id="storage-mode"></div>
  </div>

  <div class="content">
    
    <div id="create-todo">
      <input id="new-todo" placeholder="What needs to be done?" type="text" />
      <span class="ui-tooltip-top" style="display:none;">Press Enter to save this task</span>
    </div>
    <div>
      <fieldset style="padding-bottom: 10px;">
        <legend class="showhide-controls" style="cursor: pointer"><span class="ui-icon ui-icon-triangle"></span><span class="legend" id="main-box">Show/Hide Options</span></legend>
        <div id="todo-controls" class="showhide" style="display: none;">
          <fieldset>
            <legend class="showhide-controls" style="cursor: pointer"><span class="ui-icon ui-icon-triangle"></span><span class="legend" id="storage-box">Storage Mode</span></legend>
            <div class="showhide" style="display: none;">
              <span id="button-storage"></span>
            </div>
          </fieldset>
          <fieldset>
            <legend class="showhide-controls" style="cursor: pointer"><span class="ui-icon ui-icon-triangle"></span><span class="legend" id="client-box">Client only settings</span></legend>
            <div class="showhide" style="display: none;">
              <span id="button-checkall"></span>
              <span id="button-uncheckall"></span>
            </div>
          </fieldset>
          <fieldset>
            <legend class="showhide-controls" style="cursor: pointer"><span class="ui-icon ui-icon-triangle"></span><span class="legend" id="sync-box">Synchronize</span></legend>
            <div class="showhide" style="display: none;">
              <span id="button-unsaved"></span>
              <span id="button-refresh"></span>
            </div>
          </fieldset>
        </div>
      </fieldset>
      <fieldset>
        <legend>Info Panel</legend>
        <div id="todo-stats"></div>
      </fieldset>
    </div>
    <div id="todos">
      <ul id="todo-list"></ul>
    </div>
  </div>

</div>

<ul id="instructions">
  <li>Double-click to edit a todo.</li>
  <li>Click, hold and drag to reorder your todos.</li>
  <li>Yellow background indicates unsaved todos.</li>
</ul>

<div id="credits">
  Created by
  <br />
  <a href="http://jgn.me/">J&eacute;r&ocirc;me Gravel-Niquet</a>
</div>

<!-- Templates -->

<script type="text/template" id="item-template">
  <div class="todo <%= done ? 'done' : '' %>">
    <div class="display">
      <input class="check" type="checkbox" <%= done ? 'checked="checked"' : '' %> />
             <div class="todo-content"></div>
      <span class="todo-destroy"></span>
    </div>
    <div class="edit">
      <input class="todo-input" type="text" value="" />
    </div>
  </div>
</script>

<script type="text/template" id="stats-template">
  <% if (total) { %>
  <span class="todo-count">
    <span class="number"><%= remaining %></span>
    <span class="word"><%= remaining == 1 ? 'item' : 'items' %></span> left.
  </span>
  <% } %>
  <% if (done) { %>
  <span class="todo-clear">
    <a href="#">
      Clear <span class="number-done"><%= done %></span>
      completed <span class="word-done"><%= done == 1 ? 'item' : 'items' %></span>
    </a>
  </span>
  <% } %>
</script>

<script type="text/template" id="button-checkall-template">
  <button title="Check all Todos" class="primary_lg <%=remaining==0 ? 'disabled' : '' %>" type="button" <%=remaining==0 ? 'disabled' : '' %>><%=value%></button>
</script>

<script type="text/template" id="button-uncheckall-template">
  <button title="Uncheck all Todos" class="primary_lg <%=done==0 ? 'disabled' : '' %>" type="button" <%=done==0 ? 'disabled' : '' %>><%=value%></button>
</script>

<script type="text/template" id="button-unsaved-template">
  <button title="Save all local changes" class="primary_lg <%=unsaved==0 ? 'disabled' : '' %>" type="button" <%=unsaved==0 ? 'disabled' : '' %>><%=value%></button>
</script>

<script type="text/template" id="button-refresh-template">
  <button title="Reloads a fresh set from server" class="primary_lg <%=busy ? 'disabled' : '' %>" type="button" <%=busy ? 'disabled' : '' %>><%=value%></button>
</script>

<script type="text/template" id="button-storage-template">
  <button title="Toggle Storage" class="primary_lg" type="button" style="width: 430px;"><%=value%></button>
</script>

<script type="text/template" id="storage-header-template">
  <span style="color: #999; font-weight: bold; color: #FF0000"><%=value%></span>
</script>
