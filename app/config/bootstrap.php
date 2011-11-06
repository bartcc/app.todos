<?php
/**
 * This file is loaded automatically by the app/webroot/index.php file after the core bootstrap.php
 *
 * This is an application wide file to load any function that is not used within a class
 * define. You can also use this to include or require any files in your application.
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
 * @subpackage    cake.app.config
 * @since         CakePHP(tm) v 0.10.8.2117
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

/**
 * The settings below can be used to set additional paths to models, views and controllers.
 * This is related to Ticket #470 (https://trac.cakephp.org/ticket/470)
 *
 * App::build(array(
 *     'plugins' => array('/full/path/to/plugins/', '/next/full/path/to/plugins/'),
 *     'models' =>  array('/full/path/to/models/', '/next/full/path/to/models/'),
 *     'views' => array('/full/path/to/views/', '/next/full/path/to/views/'),
 *     'controllers' => array(/full/path/to/controllers/', '/next/full/path/to/controllers/'),
 *     'datasources' => array('/full/path/to/datasources/', '/next/full/path/to/datasources/'),
 *     'behaviors' => array('/full/path/to/behaviors/', '/next/full/path/to/behaviors/'),
 *     'components' => array('/full/path/to/components/', '/next/full/path/to/components/'),
 *     'helpers' => array('/full/path/to/helpers/', '/next/full/path/to/helpers/'),
 *     'vendors' => array('/full/path/to/vendors/', '/next/full/path/to/vendors/'),
 *     'shells' => array('/full/path/to/shells/', '/next/full/path/to/shells/'),
 *     'locales' => array('/full/path/to/locale/', '/next/full/path/to/locale/')
 * ));
 *
 */

/**
 * As of 1.3, additional rules for the inflector are added below
 *
 * Inflector::rules('singular', array('rules' => array(), 'irregular' => array(), 'uninflected' => array()));
 * Inflector::rules('plural', array('rules' => array(), 'irregular' => array(), 'uninflected' => array()));
 *
 */
if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') {
  $protocol = 'https://';
} else {
  $protocol = 'http://';
}
define('DIR_REL_HOST', str_replace('/index.php?', '', Configure::read('App.baseUrl')));
define('DIR_HOST', $protocol . preg_replace('/:80$/', '', env('HTTP_HOST')) . DIR_REL_HOST);
define('BASE_URL', Configure::read('App.baseUrl'));
define('WEB_URL', '/' . APP_DIR . '/' . WEBROOT_DIR);
define('UPLOADS', ROOT . DS . 'uploads');
define('PHOTOS', UPLOADS . DS . 'photos');
if (!defined('SIMPLE_JSON')) {
	define('SIMPLE_JSON', '/elements/simple_json');
}
if (!defined('BLANK_RESPONSE')) {
	define('BLANK_RESPONSE', '/elements/blank_json');
}
if (!defined('SALT')) {
    define('SALT', 'urrasjksdjkbsdakbjvgikjbgfiabrg');
}

function pre() {
	$args = func_get_args();
	foreach($args as $arg) {
		pr($arg);
	}
}

function __p($options) {
  $defaults = array(
      'width' => 180,
      'height' => 150,
      'square' => 2, // 1 => new Size ; 2 => old Size, 3 => aspect ratio
      'quality' => 80,
      'sharpening' => 1,
      'anchor_x' => 50,
      'anchor_y' => 50,
      'force' => false
  );
  $o = array_merge($defaults, $options);
  $args = join(',', array($o['uid'], $o['id'], $o['fn'], $o['width'], $o['height'], $o['square'], $o['quality'], $o['sharpening'], $o['anchor_x'], $o['anchor_y'], (int) $o['force']));
  include_once(ROOT . DS . 'app' . DS . 'controllers' . DS . 'components' . DS . 'salt.php');
  $salt = new SaltComponent();
  $crypt = $salt->convert($args);
  $path = PHOTOS . DS . $o['uid'] . DS . $o['id'] . DS . 'lg' . DS . $o['fn'];
  $m = filemtime($path);
  return BASE_URL . '/q/a:' . $crypt . '/m:' . $m;
}

function computeSize($file, $new_w, $new_h, $scale) {
	$dims = getimagesize($file);
	$old_x = $dims[0];
	$old_y = $dims[1];
	$original_aspect = $old_x/$old_y;
	$new_aspect = $new_w/$new_h;
	if ($scale == 2) {
		$x = $old_x;
		$y = $old_y;
	} else if ($scale == 1) {
		$x = $new_w;
		$y = $new_h;
	} else {
		if ($original_aspect >= $new_aspect) {
			if ($new_w > $old_x) {
				$x = $old_x;
				$y = $old_y;
			}
			$x = $new_w;
			$y = ($new_w*$old_y)/$old_x;
		} else {
			if ($new_h > $old_y) {
				$x = $old_x;
				$y = $old_y;
			}
			$x = ($new_h*$old_x)/$old_y;
			$y = $new_h;
		}
	}
	return array($x, $y);
}

function allowableFile($fn) {
  if (eregi('\.flv$|.\f4v$|\.mov$|\.mp4$|\.m4a$|\.m4v$|\.3gp$|\.3g2$|\.swf$|\.jpg$|\.jpeg$|\.gif$|\.png$', $fn)) {
    return true;
  }
  return false;
}

function isVideo($fn) {
  if (eregi('\.flv$|\.f4v$|\.mov$|\.mp4$|\.m4a$|\.m4v$|\.3gp$|\.3g2$', $fn)) {
    return true;
  } else {
    return false;
  }
}

function isSwf($fn) {
  if (eregi('\.swf$', $fn)) {
    return true;
  } else {
    return false;
  }
}

function isImage($fn) {
  return!isNotImg($fn);
}

function isNotImg($fn) {
  if (isSwf($fn) || isVideo($fn)) {
    return true;
  } else {
    return false;
  }
}