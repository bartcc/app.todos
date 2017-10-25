class Tasks extends Spine.Controller
  
    tag: 'li'

    events:
        "click .item"                   :  "blur"
        "change   input[type=checkbox]" :"toggle"
        "click    .destroy"             :"destroy"
        "dblclick .view"                :"edit"
        "keypress input[type=text]"     :"blurOnEnter"
        "blur     input[type=text]"     :"close"

    elements:
        ".items"                        :"list"
        "input[type=text]"              :"input"
        ".item"                         :"wrapper"
        
    constructor: ->
        super
        @item.bind("update",  @proxy(@render))
        @item.bind("destroy", @proxy(@remove))

    template: (item) ->
        $("#taskTemplate").tmpl item
    
    display: (item) ->
        patt = /(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?/g
        content = item.name
    
        res = content.match(patt)
        regex_content = content
        protocol = "http://"
        container = $('<div></div>')
    
    
        if (res)
      
            while (matches = patt.exec(regex_content)) isnt null
                href = if matches[0].indexOf(protocol) isnt -1 then matches[0] else protocol + matches[0]
        
                anchorEl = $('<a></a>').attr(
                    'href': href
                    'target': '_blank'
                )
      
                part=content.split(matches[0])
                content=part.slice(1).join(matches[0]); # handle rest of content by readding matches on multiple occurences
                anchorContent = anchorEl.html(matches[0])
        
                container.append(part[0]).append(anchorContent)
      
            container.append(content) # add rest of the content  
        
        else container.text(content)
        
        item.html = container.html()
        item
    
    render: ->
        @item.reload()
        isEqual = _.isEqual(@item.savedAttributes, @item.attributes())
    
        element = @template @display @item 
        @el.prop('id', 'todo-'+@item.id).addClass('hover')
        @el.html(element).toggleClass('unsaved', !isEqual)
        @refreshElements()
        @

    toggle: ->
        @item.done = !@item.done
        @item.save()

    destroy: ->
        @item.remove()

    edit: ->
        @wrapper.addClass("editing")
        @input.focus()

    blur: (e) ->
        $(e.target).attr('tabindex', 0).focus()

    blurOnEnter: (e) ->
        if (e.keyCode is 13 ) then e.target.blur()

    close: ->
        @wrapper.removeClass("editing")
        @item.updateAttributes
            name: @input.val()

    remove: ->
        @el.remove()