class App extends Spine.Controller
  
  elements:
    '#sidebar-wrapper'    : 'sidebarEl'
    '#directors'   : 'directorsEl'
    '#editor'     : 'editorEl'
    '#album'      : 'albumEl'
    '#upload'     : 'uploadEl'
    '#grid'       : 'gridEl'
    '.vdraggable' : 'vDrag'
    '.hdraggable' : 'hDrag'

  constructor: ->
    super
    @sidebar = new Sidebar
      el: @sidebarEl
    @editor = new Editor
      el: @editorEl
    @album = new Album
      el: @albumEl
    @upload = new Upload
      el: @uploadEl
    @grid = new Grid
      el: @gridEl
    @directors = new Directors
      el: @directorsEl

    @vmanager = new Spine.Manager(@sidebar)
    @vmanager.initDrag @vDrag,
      initSize: @proxy ->
        $(@sidebar.el).width()/2
      disabled: false
      axis: 'x'
      min: 250
      max: @proxy ->
        $(@el).width()/2

    @hmanager = new Spine.Manager(@editor, @upload, @album, @grid)
    @hmanager.initDrag @hDrag,
      initSize: @proxy ->
        $(@directors.el).height()/2
      disabled: false
      axis: 'y'
      min: 30
      max: @proxy ->
        (@directors.el).height()*2/3
      goSleep: @proxy ->
        @directors.activeControl?.click()
      
$ ->
  window.App = new App(el: $('body'))
  App.directors.editorBtn.click()
  Director.fetch()
