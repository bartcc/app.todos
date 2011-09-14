class App extends Spine.Controller
  
  elements:
    "#sidebar"    : "sidebarEl"
    "#tasks"      : "tasksEl"

  constructor: ->
    super
    @sidebar = new Sidebar
      el: @sidebarEl
    @main = new Main
      el: @tasksEl
      
$ ->
  window.App = new App(el: $('body'))
  Task.trigger('refresh:list');