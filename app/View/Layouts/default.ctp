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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<?php echo $this->Html->charset(); ?>
	<title>
		<?php __('CakePHP: Welcome to CakePHP: '); ?>
		<?php echo $title_for_layout; ?>
	</title>
	<?php
		echo $this->Html->meta('icon');
  echo $this->Html->meta("keywords", "spine, spinejs, spine.js, javascript, application, sample, example, photo, album, gallery,twitter, bootstrap, html5, web, app, apps, image, upload, drag and drop");
  echo $this->Html->meta("description", "Photo Library, Photo Director, Sample Application made with Spine.js, Web App");
  
  echo $this->Html->css('twitter/bootstrap/css/bootstrap');
  echo $this->Html->css('app');
        
		echo $scripts_for_layout;
	?>
</head>
<body>
	<?php echo $content_for_layout; ?>
	<?php echo $this->element('sql_dump'); ?>
<meta itemprop="screenshot" content="https://lh4.googleusercontent.com/fSJzWPiTcYQ6qLgxlqEfJuVD4hfnaGQJatRzWXn8kj96=w483-h367-no">
<span itemprop="publisher" itemscope itemtype="http://schema.org/Organization">
<meta itemprop="name" content="Axel Nitzschner"></span>
<span itemprop="author" itemscope itemtype="http://schema.org/Person">
<meta itemprop="name" content="Axel Nitzschner"></span>
<meta itemprop="url" content="http://gap.webpremiere.de/director_app, http://gap.webpremiere.de/users/login">
<meta itemprop="operatingSystem" content="Mac OS X, Windows">
<meta itemprop="applicationCategory" content="Photo Manager, Photo Library">
<meta itemprop="image" content="https://lh4.googleusercontent.com/fSJzWPiTcYQ6qLgxlqEfJuVD4hfnaGQJatRzWXn8kj96=w483-h367-no">
</body>
</html>