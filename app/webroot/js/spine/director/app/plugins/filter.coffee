Spine = require("spine")
$      = Spine.$
Model  = Spine.Model

Filter =

  extended: ->

    extend =
      options:
        func: 'select'

      filter: (query, options) ->
        opts = $.extend({}, @options, options)
        return @all() unless query
        @select (item) ->
          item[opts.func] query, opts
          
      filterRelated: (id, options) ->
        joinTableItems = Model[options.joinTable].filter(id, options)
        if options.sorted
          return @sortByOrder @filter joinTableItems
        else
          return @filter joinTableItems
          
      nameSort: (a, b) ->
        aa = (a or '').name?.toLowerCase()
        bb = (b or '').name?.toLowerCase()
        return if aa == bb then 0 else if aa < bb then -1 else 1
          
      sortSelectionListByOrder: ->
        list = @selectionList()
        list.sort (a, b) ->
          aInt = parseInt(Album.exists(a).order)
          bInt = parseInt(Album.exists(b).order)
          if aInt < bInt then -1 else if aInt > bInt then 1 else 0

      sortByOrder: (arr) ->
        arr.sort (a, b) ->
          aInt = parseInt(a.order)
          bInt = parseInt(b.order)
          if aInt < bInt then -1 else if aInt > bInt then 1 else 0

      sortByReverseOrder: (arr) ->
        arr.sort (a, b) ->
          aInt = parseInt(a.order)
          bInt = parseInt(b.order)
          if aInt < bInt then 1 else if aInt > bInt then -1 else 0

      sortByName: (arr) ->
        arr.sort (a, b) ->
          a = a._name
          b = b._name
          if a < b then -1 else if a > b then 1 else 0

    include =
    
      select: (query) ->
        query = query?.toLowerCase()
        atts = (@selectAttributes or @attributes).apply @
        for key, value of atts
          value = value?.toLowerCase()
          unless (value?.indexOf(query) is -1)
            return true
        false

    @extend extend
    @include include


module?.exports = Model.Filter = Filter