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
      <?php __('CakePHP: Welcome to CakePHP: '); ?>
      <?php echo $title_for_layout; ?>
    </title>
    <?php
    echo $this->Html->meta('icon');
    echo $this->Html->css('spine/director/application_boxmodel');

    //$this->log($js->object($galleries), LOG_DEBUG);
    echo $this->Html->script('lib/jquery/jquery-1.7.1');
    echo $this->Html->script('lib/jquery/jquery.tmpl');
    echo $this->Html->script('spine/lib/spine_1.0.5');
    echo $this->Html->script('spine/lib/local');
    echo $this->Html->script('spine/lib/filter');
    echo $this->Html->script('spine/app/director/models/user');
    echo $this->Html->script('spine/app/director/models/error');
    echo $this->Html->script('spine/app/director/login');

    echo $html->scriptStart();
    ?>

    var base_url = '<?php echo $html->url('/'); ?>';

    <?php
    echo $html->scriptEnd();
    echo $scripts_for_layout;
    ?>
  </head>
  <body class="body">
    <?php echo $content_for_layout; ?>
    <?php echo $this->element('sql_dump'); ?>
  </body>
</html>