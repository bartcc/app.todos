Spine = require('spine')
$     = Spine.$

class OverviewHeader extends Spine.Controller
  constructor: ->
    super
    @bind('active', @proxy @active)
    
  template: () ->
    $('#overviewHeaderTemplate').tmpl()
    
  render: () ->
    @html @template()
    
  active: ->
    @render()
    
module.exports = OverviewHeader