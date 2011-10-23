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
<html class="smheight" xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <?php echo $this->Html->charset(); ?>
    <title>
      <?php __('CakePHP: Evaluating Spine.js:'); ?>
      <?php echo $title_for_layout; ?>
    </title>
    <?php
    echo $this->Html->meta('icon');

    echo $this->Html->css('spine/director/application');
    echo $this->Html->css('spine/director/window');

    //echo $this->Html->script('lib/json2');

    echo $this->Html->script('lib/jquery/jquery-1.6.2');
    echo $this->Html->script('lib/jquery/jquery.tmpl');
    echo $this->Html->script('lib/jquery/ui/jquery-ui-1.8.16');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.core');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.widget');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.mouse');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.draggable');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.droppable');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.sortable');
    echo $this->Html->script('lib/jquery/ui/effects/jquery.effects.core');
    echo $this->Html->script('lib/jquery/ui/effects/jquery.effects.slide');
    echo $this->Html->script('lib/underscore');

    echo $this->Html->script('spine/lib/spine');
    echo $this->Html->script('spine/lib/local');
    echo $this->Html->script('spine/lib/ajax');
    echo $this->Html->script('spine/lib/filter');
    echo $this->Html->script('spine/lib/manager');
    echo $this->Html->script('spine/lib/tmpl');

    echo $this->Html->script('spine/app/director/plugins/manager');
    echo $this->Html->script('spine/app/director/plugins/controller');
    echo $this->Html->script('spine/app/director/plugins/drag');
    echo $this->Html->script('spine/app/director/plugins/model_extender');
    echo $this->Html->script('spine/app/director/plugins/ajax_relations');
    echo $this->Html->script('spine/app/director/plugins/toolbars');
    echo $this->Html->script('spine/app/director/models/galleries_albums');
    echo $this->Html->script('spine/app/director/models/albums_images');
    echo $this->Html->script('spine/app/director/models/gallery');
    echo $this->Html->script('spine/app/director/models/image');
    echo $this->Html->script('spine/app/director/models/album');
    echo $this->Html->script('spine/app/director/models/user');
    echo $this->Html->script('spine/app/director/models/error');
    echo $this->Html->script('spine/app/director/controllers/loader');
    echo $this->Html->script('spine/app/director/controllers/main');
    echo $this->Html->script('spine/app/director/controllers/login');
    echo $this->Html->script('spine/app/director/controllers/gallery_list');
    echo $this->Html->script('spine/app/director/controllers/album_list');
    echo $this->Html->script('spine/app/director/controllers/sidebar');
    echo $this->Html->script('spine/app/director/controllers/gallery');
    echo $this->Html->script('spine/app/director/controllers/album');
    echo $this->Html->script('spine/app/director/controllers/upload');
    echo $this->Html->script('spine/app/director/controllers/grid');
    echo $this->Html->script('spine/app/director/controllers/albums_show_view');
    echo $this->Html->script('spine/app/director/controllers/albums_edit_view');
    echo $this->Html->script('spine/app/director/application');
    ?>

    <?php
    //$this->log($js->object($galleries), LOG_DEBUG);
    echo $html->scriptStart();
    //$this->log($js->object($albums), LOG_DEBUG) ;
    ?>
    var base_url = '<?php echo $html->url('/'); ?>';
    
    $(function() {
      var galleries = <?php echo $js->object($galleries); ?>;
      var albums = <?php echo $js->object($albums); ?>;
      var images = <?php echo $js->object($images); ?>;
      Image.refresh(images);
      Album.refresh(albums);
      Gallery.refresh(galleries);
    })
    <?php
    echo $html->scriptEnd();

    echo $scripts_for_layout;
    ?>
  </head>
  <body class="views smheight">
    <?php echo $content_for_layout; ?>
    <?php echo $this->element('sql_dump'); ?>
  </body>
</html>