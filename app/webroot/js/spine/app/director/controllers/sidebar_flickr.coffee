class SidebarFlickr extends Spine.Controller

  elements:
    '.items'                : 'items'
    '.inner'                : 'inner'

  events:
    'click      .expander'  : 'expand'
    'click'                 : 'expand'

  template: (items) ->
    $("#sidebarFlickrTemplate").tmpl(items)

  constructor: ->
    super
    @render()

  render: ->
    items = 
      name: 'Flickr'
      sub: [
        name: 'Recent (disabled)'
      ,
        name: 'User (disabled)'
      ]
      
    @html @template(items)

  expand: (e) ->
    parent = $(e.target).parents('li')
    icon = $('.expander', parent)
    content = $('.sublist', parent)

    icon.toggleClass('expand')
      
    if content.is(':visible') then content.hide() else content.show()

    e.stopPropagation()
    e.preventDefault()
    
  renderSublist: (gallery = Gallery.record) ->
    console.log 'SidebarList::renderOneSublist'
    return unless gallery
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
    albums = Album.filterRelated(gallery.id, filterOptions)
    for album in albums
      album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    albums.push {flash: 'no albums'} unless albums.length
    
    galleryEl = @children().forItem(gallery)
    gallerySublist = $('ul', galleryEl)
    gallerySublist.html @sublistTemplate(albums)
    
    @updateTemplate gallery