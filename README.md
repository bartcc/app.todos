#Modified Spine / Backbone Todos

Summary of 2 Todo examples based on [Spine](http://github.com/maccman/spine) and [Backbone](http://documentcloud.github.com/backbone/) JavaScript libraries.

Both examples work in conjunction with CakePHP framework as the backend. 

#Live Demo

Checkout the live [Backbone based demo](http://app.anito.de/index.php?/todos_app) and [Spine based demo](http://app.anito.de/index.php?/tasks_app)

#Features

* Todo CRUD
* Server Storage persistens
* Toggle Local Storage <-> Server Storage persistens (Backbone only)
* Mark all Tasks done/undone in memory and sync later
* Drag'n Drop to reorder Tasks

#Usage

1. Checkout the Git repository
2. Create MySql Databases todos_backbone and/or todos_spine
3. Save database.php.default as database.php, fill in your login and password values
4. Setup your MySql server using *.sql files located in root directory
5. Check out js files under /app/webroot/js/spine/app/todos respectively /app/webroot/js/backbone/app/todos
   to see how everything works

#Screenshot

![Todos](https://lh3.googleusercontent.com/-ryuRC4ZyLzQ/TjHpoxjakoI/AAAAAAAAAC8/gSzlyIbsTaE/s512/Bildschirmfoto%2525202011-07-29%252520um%25252000.58.06.png)