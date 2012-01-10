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
      <?php __('CakePHP: Evaluating Backbone.js:'); ?>
      <?php echo $title_for_layout; ?>
    </title>
    <?php
    echo $this->Html->meta('icon');

    //echo $this->Html->css('cake.generic');

    echo $this->Html->css('backbone/todos/application_boxmodel');
    echo $this->Html->css('themes/jquery-ui/ui-darkness/jquery.ui.custom.css');

    echo $this->Html->script('lib/json2');

    echo $this->Html->script('lib/jquery/jquery-1.7.1.min');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.core');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.widget');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.mouse');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.dialog');
    echo $this->Html->script('lib/jquery/ui/jquery.ui.sortable');

    echo $this->Html->script('lib/underscore');

    echo $this->Html->script('backbone/lib/backbone');
    echo $this->Html->script('backbone/lib/backbone-localstorage');
    echo $this->Html->script('lib/namespace');
    
    echo $this->Html->script('backbone/app/todos/app.intro');
    echo $this->Html->script('backbone/app/todos/models/user');
    echo $this->Html->script('backbone/app/todos/models/todo');
    echo $this->Html->script('backbone/app/todos/models/unsaved_todo');
    echo $this->Html->script('backbone/app/todos/collections/todos');
    echo $this->Html->script('backbone/app/todos/collections/unsaved_todos');
    echo $this->Html->script('backbone/app/todos/views/login');
    echo $this->Html->script('backbone/app/todos/views/logout');
    echo $this->Html->script('backbone/app/todos/views/todo');
    echo $this->Html->script('backbone/app/todos/views/sidebar');
    echo $this->Html->script('backbone/app/todos/views/main');
    echo $this->Html->script('backbone/app/todos/application');

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