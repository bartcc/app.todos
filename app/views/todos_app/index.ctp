<header id="title" class="hbox">
    <h1><a href="/">Todos</a></h1>
    <div id="logout" class="flex tright" style="margin-top: 8px;"></div>
</header>
<div id="wrapper" class="hbox flex">
    <div id="sidebar" class="vbox">
        <div class="vbox flex">
            <div id="todo-controls" class="vbox flex">
                <span id="button-storage"></span>
                <span id="button-checkall"></span>
                <span id="button-uncheckall"></span>
                <span id="button-unsaved"></span>
                <span id="button-refresh"></span>
            </div>
            <div class="hbox">
                <footer class="vbox flex">
                    <div style="height: 33px;">
                        <button id="refresh-db" class="light" style="width: 100%" onclick="window.location.href = base_url + 'mysql/restore'">Restore</button>
                    </div>
                </footer>
            </div>
        </div>
    </div>
    <div class="vdivide"></div>
    <div id="main" class="vbox flex">
        <div id="tasks" class="vbox flex">
            <div id="create-todo" class="hbox">
                <div class="new-todo hbox flex" id="new-todo">
                    <input type="text" placeholder="What needs to be done?">
                    <span class="ui-tooltip-top" style="display:none;">Press Enter to save this task</span>
                    <div id="todo-stats" class="count flex tright"><span class="countVal"></span></div>
                </div>
            </div>

            <div id="todo-list" class="items vbox flex autoflow"></div>

            <footer class="hbox">
                <div id="storage-mode"><span></span></div>
                <div class="flex" style="height: 33px;">
                    <button class="light clear">Clear completed</button>
                </div>
            </footer>
        </div>
    </div>
</div>
<div id="login" style="display: none">
    <div class="dialogue-wrap transparent" id="messenger">
        <div class="dialogue">
            <div style="width:525px; min-width:500px;" class="morph dialogue-content" id="morph_messenger-wrap">
                <div class="bg verticaltop" id="draggable-messenger-wrap">
                    <header>
                        <fieldset class="right">
                            <button id="close" class="light window input">x</button>
                        </fieldset>
                    </header>
                    <div class="dialogue-inner-wrap">
                        <div class="drag-handle">
                            <div>
                                <h1>Login</h1>
                                <div id="flash"><span></span></div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="dialogue-scroll">
                            <fieldset>
                                <div class="left">
                                    <label>User</label>
                                    <input id="username" type="text">
                                </div>
                                <div class="left">
                                    <label>Password</label>
                                    <input id="password" type="password">
                                </div>
                            </fieldset>
                        </div>
                    </div>
                    <footer>
                        <span>
                            <fieldset>
                                <?php echo $this->Form->button('Guest Login', array('type' => 'button', 'class' => 'light', 'id' => 'guestLogin')); ?>
                                <?php echo $this->Form->button('Local Storage', array('type' => 'button', 'class' => '_local light', 'id' => 'local')); ?>
                                <?php echo $this->Form->button('Cancel', array('type' => 'button', 'class' => 'light', 'id' => 'cancel')); ?>
                                <?php echo $this->Form->button('Login', array('type' => 'submit', 'class' => 'light glyphicon glyphicon-log-in disabled', 'disabled' => 'true', 'id' => 'login')); ?>
                            </fieldset>
                        </span>
                    </footer>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- Templates -->

<script type="text/template" id="item-template">
    <div class="item <%= done ? 'done' : '' %>">
        <div class="display">
            <input class="check" type="checkbox" <%= done ? 'checked="checked"' : '' %> />
            <span class="todo-content"></span><a class="destroy"></a>
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
        <span class="word"><%= remaining == 1 ? 'item' : 'items' %></span> left
    </span>
    <% } %>
</script>

<script type="text/template" id="button-checkall-template">
    <button title="Check all Todos" class="primary_lg <%=remaining==0 ? 'disabled' : '' %>" <%=remaining==0 ? 'disabled' : '' %>><%=value%></button>
</script>

<script type="text/template" id="button-uncheckall-template">
    <button title="Uncheck all Todos" class="primary_lg <%=done==0 ? 'disabled' : '' %>" <%=done==0 ? 'disabled' : '' %>><%=value%></button>
</script>

<script type="text/template" id="button-unsaved-template">
    <button title="Save all local changes" class="primary_lg <%=unsaved==0 ? 'disabled' : 'alert' %>" <%=unsaved==0 ? 'disabled' : '' %>><%=value%></button>
</script>

<script type="text/template" id="button-refresh-template">
    <button title="Reloads a fresh set from server" class="primary_lg <%=busy ? 'disabled' : '' %>" <%=busy ? 'disabled' : '' %>><%=value%></button>
</script>

<script type="text/template" id="button-storage-template">
    <button title="<%=value%>" class="primary_lg" style=""></button>
</script>

<script type="text/template" id="storage-status-template">
    <span><%=value%></span>
</script>

<script type="text/template" id="button-logout-template">
    <% if (value) { %>
    <button class="dark clear _logout">Logout <%=value%></button>
    <% } %>
</script>

<script type="text/template" id="flash-template">
    <%=value %>
</script>

<script type="text/template" id="dialog-template">
    <div class="demo">
        <div id="dialog-modal" title="<%=title%>">
            <p><%=content%></p>
        </div>
    </div>
</script>
