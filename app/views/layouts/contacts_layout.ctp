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

    echo $this->Html->css('spine/contacts/application');

    echo $this->Html->script('lib/json2');

    echo $this->Html->script('lib/jquery/jquery-1.7.1');
    echo $this->Html->script('lib/jquery/jquery.tmpl');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.core');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.widget');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.mouse');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.draggable');
    echo $this->Html->script('lib/jquery/ui/effects/jquery.effects.core');
    echo $this->Html->script('lib/jquery/ui/effects/jquery.effects.slide');
    echo $this->Html->script('lib/underscore');

    echo $this->Html->script('spine/lib/spine_1.0.5');
    echo $this->Html->script('spine/lib/local');
    echo $this->Html->script('spine/lib/ajax');
    echo $this->Html->script('spine/lib/filter');
    echo $this->Html->script('spine/lib/manager');
    echo $this->Html->script('spine/lib/tmpl');

    echo $this->Html->script('spine/app/contacts/plugins/manager');
    echo $this->Html->script('spine/app/contacts/models/contact');
    echo $this->Html->script('spine/app/contacts/controllers/list');
    echo $this->Html->script('spine/app/contacts/controllers/sidebar');
    echo $this->Html->script('spine/app/contacts/controllers/editor');
    echo $this->Html->script('spine/app/contacts/controllers/album');
    echo $this->Html->script('spine/app/contacts/controllers/upload');
    echo $this->Html->script('spine/app/contacts/controllers/grid');
    echo $this->Html->script('spine/app/contacts/controllers/contacts');
    echo $this->Html->script('spine/app/contacts/application');
    ?>

    <?php
    echo $html->scriptStart();
    ?>
    var base_url = '<?php echo $html->url('/'); ?>';
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