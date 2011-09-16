class App extends Spine.Controller
  
  elements:
    '#sidebar-wrapper'    : 'sidebarEl'
    '#galleries'   : 'galleriesEl'
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
    @galleries = new Galleries
      el: @galleriesEl

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
        $(@galleries.el).height()/2
      disabled: false
      axis: 'y'
      min: 30
      max: @proxy ->
        (@galleries.el).height()*2/3
      goSleep: @proxy ->
        @galleries.activeControl?.click()
      
$ ->
  window.App = new App(el: $('body'))
  App.galleries.editorBtn.click()
  Gallerie.fetch()
