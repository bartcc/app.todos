Spine = require('spine')

class FlickrView extends Spine.Controller

  elements:
    '.links'      : 'links'
    '.content'    : 'content'
    
  events:
    'click .links': 'click'
    
  constructor: ->
    super
    
  template: (items) ->
    $('#flickrTemplate').tmpl items
    
  render: (items) ->
    @content.html @template items
    
  url: ->
    protocol = if window.location.protocol is 'https:'
      'https://secure'
    else
      'http://api'
    protocol + '.flickr.com/services/rest/'
                
  data:
    format: 'json',
    method: 'flickr.interestingness.getList',
    api_key: '7617adae70159d09ba78cfec73c13be3'
    
  ajax: ->
    console.log 'FlickrView::ajax'
    $.ajax(
      url: @url()
      data: @data
      dataType: 'jsonp',
      jsonp: 'jsoncallback'
    ).done(@callback)
    
  callback: (result) =>
    links = []
    linksContainer = @links
    $.each(result.photos.photo, (index, photo) ->
      baseUrl = 'http://farm' + photo.farm + '.static.flickr.com/' + photo.server + '/' + photo.id + '_' + photo.secret
      links.push
        href: baseUrl + '_c.jpg',
        title: photo.title
    )
    # Initialize the Gallery
#    blueimp.Gallery(links,
#      container: '#blueimp-image-carousel',
#      carousel: true
#    )
    
    @render result.photos.photo
    
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    target = $(e.target).parent()[0]
    options = index: target
    links = $('a', @links)
    gallery = blueimp.Gallery(links, options)
  
module.exports = FlickrView