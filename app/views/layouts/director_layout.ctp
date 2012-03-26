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
    echo $this->Html->css('spine/director/modal');
    echo $this->Html->css('twitter/bootstrap/bootstrap');
    echo $this->Html->css('blueimp/bootstrap-image-gallery');
    echo $this->Html->css('blueimp/new/jquery.fileupload-ui');
    echo $this->Html->css('html5sortable/jquery.html5sortable');
    echo $this->Html->css('base');
    echo $this->Html->css('spine/director/application');

    echo $html->scriptStart();
    ?>
      var base_url = '<?php echo $html->url('/'); ?>';
    <?php
    echo $html->scriptEnd();
    
    echo $this->Html->script('lib/jquery/jquery-1.7.1');
    echo $this->Html->script('lib/jquery/ui/jquery-ui-1.8.16');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.core');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.widget.min');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.mouse');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.draggable');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.droppable');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.sortable');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.progressbar');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.button');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.slider');
    echo $this->Html->script('lib/jquery/ui/effects/jquery.effects.core');
    echo $this->Html->script('lib/jquery/ui/effects/jquery.effects.slide');
    echo $this->Html->script('lib/jquery/jquery.tmpl');
    echo $this->Html->script('lib/jquery/jquery.html5sortable');
    echo $this->Html->script('lib/twitter/bootstrap.min');
//    echo $this->Html->script('lib/twitter/bootstrap-modal');
//    echo $this->Html->script('lib/twitter/bootstrap-dropdown');
//    echo $this->Html->script('lib/twitter/bootstrap-button');
    echo $this->Html->script('lib/blueimp/tmpl');
    echo $this->Html->script('lib/blueimp/load-image');
    echo $this->Html->script('lib/blueimp/bootstrap-image-gallery');
    echo $this->Html->script('lib/blueimp/jquery.iframe-transport');
    echo $this->Html->script('lib/blueimp/locale');
    echo $this->Html->script('lib/blueimp/jquery.fileupload');
    echo $this->Html->script('lib/blueimp/canvas-to-blob.min');
    echo $this->Html->script('lib/blueimp/jquery.fileupload-ip');
    echo $this->Html->script('lib/blueimp/jquery.fileupload-ui');

    #echo $this->Html->script('spine/lib/spine_0.0.9');
    echo $this->Html->script('spine/lib/spine_1.0.6');
    echo $this->Html->script('spine/lib/ajax_1.0.6');
    echo $this->Html->script('spine/lib/local');
    echo $this->Html->script('spine/lib/manager');
    echo $this->Html->script('spine/lib/tmpl');

    echo $this->Html->script('spine/app/director/plugins/jquery-plugins');
    echo $this->Html->script('spine/app/director/plugins/filter');
    echo $this->Html->script('spine/app/director/plugins/manager');
    echo $this->Html->script('spine/app/director/plugins/controller');
    echo $this->Html->script('spine/app/director/plugins/drag');
    echo $this->Html->script('spine/app/director/plugins/sort');
    echo $this->Html->script('spine/app/director/plugins/base');
    echo $this->Html->script('spine/app/director/plugins/model_extender');
    echo $this->Html->script('spine/app/director/plugins/ajax_relations');
    echo $this->Html->script('spine/app/director/plugins/cache');
    echo $this->Html->script('spine/app/director/plugins/uri');
    echo $this->Html->script('spine/app/director/models/galleries_album');
    echo $this->Html->script('spine/app/director/models/albums_photo');
    echo $this->Html->script('spine/app/director/models/gallery');
    echo $this->Html->script('spine/app/director/models/photo');
    echo $this->Html->script('spine/app/director/models/album');
    echo $this->Html->script('spine/app/director/models/user');
    echo $this->Html->script('spine/app/director/models/error');
    echo $this->Html->script('spine/app/director/models/recent');
    echo $this->Html->script('spine/app/director/models/toolbar');
    echo $this->Html->script('spine/app/director/controllers/toolbar_view');
    echo $this->Html->script('spine/app/director/controllers/loader');
    echo $this->Html->script('spine/app/director/controllers/info');
    echo $this->Html->script('spine/app/director/controllers/overview_view');
    echo $this->Html->script('spine/app/director/controllers/gallery_editor_view');
    echo $this->Html->script('spine/app/director/controllers/galleries_view');
    echo $this->Html->script('spine/app/director/controllers/albums_view');
    echo $this->Html->script('spine/app/director/controllers/photos_view');
    echo $this->Html->script('spine/app/director/controllers/photo_view');
    echo $this->Html->script('spine/app/director/controllers/slideshow_view');
    echo $this->Html->script('spine/app/director/controllers/galleries_header');
    echo $this->Html->script('spine/app/director/controllers/albums_header');
    echo $this->Html->script('spine/app/director/controllers/photos_header');
    echo $this->Html->script('spine/app/director/controllers/photo_header');
    echo $this->Html->script('spine/app/director/controllers/main');
    echo $this->Html->script('spine/app/director/controllers/login');
    echo $this->Html->script('spine/app/director/controllers/sidebar');
    echo $this->Html->script('spine/app/director/controllers/show');
    echo $this->Html->script('spine/app/director/controllers/sidebar_list');
    echo $this->Html->script('spine/app/director/controllers/galleries_list');
    echo $this->Html->script('spine/app/director/controllers/albums_list');
    echo $this->Html->script('spine/app/director/controllers/photos_list');
    echo $this->Html->script('spine/app/director/controllers/gallery_edit_view');
    echo $this->Html->script('spine/app/director/controllers/album_edit_view');
    echo $this->Html->script('spine/app/director/controllers/photo_edit_view');
    echo $this->Html->script('spine/app/director/controllers/upload_edit_view');
    echo $this->Html->script('spine/app/director/application');
    ?>

    <?php
//    $this->log('******************** galleries **********************', LOG_DEBUG);
//    $this->log($galleries, LOG_DEBUG);
//    $this->log('******************** albums **********************', LOG_DEBUG);
//    $this->log($albums, LOG_DEBUG);
    echo $html->scriptStart();
    ?>
    
    $(function() {
      var galleries = <?php echo $js->object($galleries); ?>;
      var albums = <?php echo $js->object($albums); ?>;
      var photos = <?php echo $js->object($photos); ?>;
      Photo.refresh(photos, {clear: true});
      Album.refresh(albums, {clear: true});
      Gallery.refresh(galleries, {clear: true});
    })
    
    <?php
    //$this->log($js->object($galleries), LOG_DEBUG) ;
    echo $html->scriptEnd();

    echo $scripts_for_layout;
    ?>
  </head>
  <body class="views">
    <?php echo $content_for_layout; ?>
    <?php echo $this->element('sql_dump'); ?>
  </body>
</html>