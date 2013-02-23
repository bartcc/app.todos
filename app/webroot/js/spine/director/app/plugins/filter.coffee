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