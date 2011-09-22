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
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <?php echo $this->Html->charset(); ?>
    <title>
      <?php __('CakePHP: Evaluating Spine.js:'); ?>
      <?php echo $title_for_layout; ?>
    </title>
    <?php
    echo $this->Html->meta('icon');

    echo $this->Html->css('spine/director/application');

    echo $this->Html->script('lib/json2');

    echo $this->Html->script('lib/jquery/jquery-1.6.2');
    echo $this->Html->script('lib/jquery/jquery.tmpl');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.core');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.widget');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.mouse');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.draggable');
    echo $this->Html->script('lib/jquery/ui/effects/jquery.effects.core');
    echo $this->Html->script('lib/jquery/ui/effects/jquery.effects.slide');
    echo $this->Html->script('lib/underscore');

    echo $this->Html->script('spine/lib/spine');
    echo $this->Html->script('spine/lib/local');
    echo $this->Html->script('spine/lib/ajax');
    echo $this->Html->script('spine/lib/filter');
    echo $this->Html->script('spine/lib/extender');
    echo $this->Html->script('spine/lib/manager');
    echo $this->Html->script('spine/lib/tmpl');

    echo $this->Html->script('spine/app/director/plugins/manager');
    echo $this->Html->script('spine/app/director/plugins/controller');
    echo $this->Html->script('spine/app/director/models/galleries_albums');
    echo $this->Html->script('spine/app/director/models/albums_images');
    echo $this->Html->script('spine/app/director/models/image');
    echo $this->Html->script('spine/app/director/models/album');
    echo $this->Html->script('spine/app/director/models/gallerie');
    echo $this->Html->script('spine/app/director/controllers/gallerieList');
    echo $this->Html->script('spine/app/director/controllers/albumList');
    echo $this->Html->script('spine/app/director/controllers/sidebar');
    echo $this->Html->script('spine/app/director/controllers/editor');
    echo $this->Html->script('spine/app/director/controllers/album');
    echo $this->Html->script('spine/app/director/controllers/upload');
    echo $this->Html->script('spine/app/director/controllers/grid');
    echo $this->Html->script('spine/app/director/controllers/albums');
    echo $this->Html->script('spine/app/director/application');
    ?>

    <?php
    echo $html->scriptStart();
    //$this->log($js->object($albums), LOG_DEBUG) ;
    ?>
    var base_url = '<?php echo $html->url('/'); ?>';
    
    $(function() {
      var galleries = <?php echo $js->object($galleries); ?>;
      var albums = <?php echo $js->object($albums); ?>;
      var images = <?php echo $js->object($images); ?>;
      //var galleries_album = <?php echo $js->object($galleries_album); ?>;
      //var albums_image = <?php echo $js->object($albums_image); ?>;
      Image.refresh(images);
      Album.refresh(albums);
      Gallery.refresh(galleries);
    })
    <?php
    echo $html->scriptEnd();

    echo $scripts_for_layout;
    ?>
  </head>
  <body>
    <?php echo $content_for_layout; ?>
    <?php echo $this->element('sql_dump'); ?>
  </body>
</html>