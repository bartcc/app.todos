Spine = require('spine')
ToolbarView = require("controllers/toolbar_view")

class FlickrView extends Spine.Controller

  elements:
    '.links'      : 'links'
    '.content'    : 'content'
    '.toolbar'    : 'toolbarEl'
    
  events:
    'click .recent'   : 'navRecent'
    'click .inter'    : 'navInter'
    'click .links'    : 'click'
    'click .optPrev'  : 'prevPage'
    'click .optNext'  : 'nextPage'
    
  template: (items) ->
    $('#flickrTemplate').tmpl items
    
  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items
    
  introTemplate: ->
    $('#flickrIntroTemplate').tmpl()
    
  constructor: ->
    super
    @type = 'recent'
    @perpage = 100
    @spec = 
      recent:
        min     : 1
        page    : 1
        pages   : 5
        per_page: @perpage
      inter:
        min     : 1
        page    : 1
        pages   : 5
        per_page: @perpage
    @toolbar = new ToolbarView
      el: @toolbarEl
      template: @toolsTemplate
      
    Spine.bind('show:flickrView', @proxy @show)
    @bind('flickr:recent', @proxy @recent)
    @bind('flickr:inter', @proxy @interestingness)
      
  render: (items) ->
    console.log 'FlickrView::render'
    if items
      @content.html @template items
    else
      @content.html @introTemplate()
    
  activated: ->
    
  show: () ->
    App.trigger('canvas', @)
    if arguments.length
      @setup(arguments[0], arguments[1])
    else @render()
    
  url: ->
    protocol = if window.location.protocol is 'https:'
      'https://secure'
    else
      'http://api'
    protocol + '.flickr.com/services/rest/'
                
  data:
    format  : 'json',
    method  : 'flickr.photos.getRecent',
    api_key : '7617adae70159d09ba78cfec73c13be3'
    
  setup: (mode, page) ->
    console.log 'FlickrView::setup'
    @type = mode
    switch mode
      when 'recent'
        toolsList = ['FlickrRecent', 'Back']
        options =
          page  : page || @spec[mode].page
          method: 'flickr.photos.getRecent'
      when 'inter'
        toolsList = ['FlickrInter', 'Back']
        options =
          page  : page || @spec[mode].page
          method: 'flickr.interestingness.getList'
      else
        return @render()
    options = $().extend @spec[mode], options
    @changeToolbar toolsList if toolsList
    @ajax(options)
    
  ajax: (options) ->
    console.log 'FlickrView::ajax'
    data = $().extend @data, options
    $.ajax(
      url: @url()
      data: data
      dataType: 'jsonp',
      jsonp: 'jsoncallback'
    )
    .done(@doneResponse)
    .fail(@failResponse)
    
  doneResponse: (result) =>
    # update our own spec object with flickrs response
    @updateSpecs result
    @render result.photos.photo
    
  failResponse: (args...) ->
    console.log args
    
  changeToolbar: (list) ->
    @toolbar.change list
    @refreshElements()
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    target = $(e.target).parent()[0]
    options = index: target
    links = $('a', @links)
    blueimp.Gallery(links, options)
    
  prevPage: (e) ->
    e.stopPropagation()
    e.preventDefault()
    type = @type
    @spec[type].page = if (t = ((@spec[type].page || 1)-1)) >= 1 then t else 1
    @navigate '/flickr', type, @spec[type].page
  
  nextPage: (e) ->
    e.stopPropagation()
    e.preventDefault()
    type = @type
    @spec[type].page = if (t = ((@spec[type].page || 1)+1)) <= @spec[type].pages then t else @spec[type].pages
    @navigate '/flickr', type, @spec[type].page
    
  details: (type) ->
    page = (Number) @spec[type].page
    perpage = (Number) @spec[type].per_page
    from: ((page-1) * perpage) + 1
    to: ((page-1) * perpage) + perpage
    
  updateSpecs: (res) ->
    type = @type
    $().extend @spec[type], res.photos
    # prevent flickr from choking on nested objects
    delete @spec[type].photo

  recent: (page) ->
    @setup('recent', page)
    
  interestingness: (page) ->
    @setup('inter', page)
    
  navRecent: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @navigate '/flickr', 'recent/1'
    
  navInter: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @navigate '/flickr', 'inter/1'
    
module.exports = FlickrView