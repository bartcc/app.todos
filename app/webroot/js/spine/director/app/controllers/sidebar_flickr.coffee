Spine    = require("spine")
$        = Spine.$
Extender = require("plugins/controller_extender")

require("plugins/tmpl")

class SidebarFlickr extends Spine.Controller

  @extend Extender

  elements:
    '.items'                : 'items'
    '.inner'                : 'inner'
    '.expander'             : 'expander'

  events:
    'click      .expander'        : 'expand'
    'click'                       : 'expand'
    'click      .opt-FlickrRecent' : 'navRecent'
    'click      .opt-FlickrInter'  : 'navInter'

  template: (items) ->
    $("#sidebarFlickrTemplate").tmpl(items)

  constructor: ->
    super
    @render()

  render: ->
    @log 'render'
    items = 
      name: 'flickr'
      sub: [
        name: 'Recent Photos'
        klass: 'opt-FlickrRecent'
        icon: 'picture'
      ,
        name: 'Interesting Stuff'
        klass: 'opt-FlickrInter'
        icon: 'picture'
      ]
      
    @html @template(items)

  expand: (e) ->
    parent = $(e.target).closest('li')
    parent.toggleClass('open')
    @navigate '/flickr/' if parent.hasClass('open')

    e.stopPropagation()
    e.preventDefault()

  navRecent: (e) ->
    @log 'flickr recent clicked'
    @navigate '/flickr', 'recent/1'
    
    e.stopPropagation()
    e.preventDefault()

  navInter: (e) ->
    @log 'flickr interesting clicked'
    @navigate '/flickr', 'inter/1'
    
    e.stopPropagation()
    e.preventDefault()

module?.exports = SidebarFlickr