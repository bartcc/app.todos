Spine = require('spine')
$     = Spine.$

class OverviewHeader extends Spine.Controller
  constructor: ->
    super
    
  template: () ->
    $('#overviewHeaderTemplate').tmpl()
    
  render: () ->
    @html @template()
    
  activated: ->
    @render()
    
module.exports = OverviewHeader