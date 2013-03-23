<?php
/**
 *
 * PHP versions 4 and 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2010, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2010, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       cake
 * @subpackage    cake.cake.console.libs.templates.skel.views.layouts
 * @since         CakePHP(tm) v 0.10.0.1076
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <?php echo $this->Html->charset(); ?>
    <title>
      <?php __('CakePHP: Evaluating Spine.js:'); ?>
      <?php echo $title_for_layout; ?>
    </title>
    <?php
    echo $this->Html->meta('icon');
    
    echo $this->Html->css('themes/jquery-ui/ui-darkness/jquery-ui-1.8.16.custom');
    echo $this->Html->css('twitter/bootstrap/bootstrap.min');
    echo $this->Html->css('blueimp/image-gallery/bootstrap-image-gallery.min');
    echo $this->Html->css('blueimp/fileupload/jquery.fileupload-ui');
    echo $this->Html->css('html5sortable/jquery.sortable');
    echo $this->Html->css('base');
//    echo $this->Html->css('spine/director/modal');
//    echo $this->Html->css('spine/director/application');
    echo $this->Html->css('/js/spine/director/public/application');

    echo $this->Html->scriptStart();
    ?>
      var base_url = '<?php echo $this->Html->url('/'); ?>';
    <?php
    echo $this->Html->scriptEnd();
    echo $this->Html->script('spine/director/public/application');
    ?>

    <?php
    echo $this->Html->scriptStart();
    ?>
    
    var exports = this;
    $(function() {
      var route   = location.hash || localStorage.hash
      var galleries = <?php echo $this->Js->object($galleries); ?>;
      var albums = <?php echo $this->Js->object($albums); ?>;
      var photos = <?php echo $this->Js->object($photos); ?>;
      
      Spine = require('spine');
      Model = Spine.Model
      User    = require("models/user");
      Main    = require("index");
      Spine.Route = require('spine/lib/route');
      Gallery= require('models/gallery')
      Album = require('models/album')
      Photo= require('models/photo')
      
      exports.App = new Main({el: $("body")});
      
      Gallery.refresh(galleries, {clear: true});
      Album.refresh(albums, {clear: true});
      Photo.refresh(photos, {clear: true});
      
      User.ping();
      Spine.Route.setup()
      App.navigate(route);
    });

    
    <?php
    
    echo $this->Html->scriptEnd();

    echo $scripts_for_layout;
    ?>
  </head>
  <body id="" class="views">
    <?php echo $content_for_layout; ?>
    <?php echo $this->element('sql_dump'); ?>
  </body>
</html>