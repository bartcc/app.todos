<?php
/**
 * This file is loaded automatically by the app/webroot/index.php file after core.php
 *
 * This file should load/create any application wide configuration settings, such as 
 * Caching, Logging, loading additional configuration files.
 *
 * You should also use this file to include any files that provide global functions/constants
 * that your application uses.
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Config
 * @since         CakePHP(tm) v 0.10.8.2117
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

/**
 * Cache Engine Configuration
 * Default settings provided below
 *
 * File storage engine.
 *
 * 	 Cache::config('default', array(
 *		'engine' => 'File', //[required]
 *		'duration'=> 3600, //[optional]
 *		'probability'=> 100, //[optional]
 * 		'path' => CACHE, //[optional] use system tmp directory - remember to use absolute path
 * 		'prefix' => 'cake_', //[optional]  prefix every cache file with this string
 * 		'lock' => false, //[optional]  use file locking
 * 		'serialize' => true, // [optional]
 * 		'mask' => 0666, // [optional] permission mask to use when creating cache files
 *	));
 *
 * APC (http://pecl.php.net/package/APC)
 *
 * 	 Cache::config('default', array(
 *		'engine' => 'Apc', //[required]
 *		'duration'=> 3600, //[optional]
 *		'probability'=> 100, //[optional]
 * 		'prefix' => Inflector::slug(APP_DIR) . '_', //[optional]  prefix every cache file with this string
 *	));
 *
 * Xcache (http://xcache.lighttpd.net/)
 *
 * 	 Cache::config('default', array(
 *		'engine' => 'Xcache', //[required]
 *		'duration'=> 3600, //[optional]
 *		'probability'=> 100, //[optional]
 *		'prefix' => Inflector::slug(APP_DIR) . '_', //[optional] prefix every cache file with this string
 *		'user' => 'user', //user from xcache.admin.user settings
 *		'password' => 'password', //plaintext password (xcache.admin.pass)
 *	));
 *
 * Memcache (http://memcached.org/)
 *
 * 	 Cache::config('default', array(
 *		'engine' => 'Memcache', //[required]
 *		'duration'=> 3600, //[optional]
 *		'probability'=> 100, //[optional]
 * 		'prefix' => Inflector::slug(APP_DIR) . '_', //[optional]  prefix every cache file with this string
 * 		'servers' => array(
 * 			'127.0.0.1:11211' // localhost, default port 11211
 * 		), //[optional]
 * 		'persistent' => true, // [optional] set this to false for non-persistent connections
 * 		'compress' => false, // [optional] compress data in Memcache (slower, but uses less memory)
 *	));
 *
 *  Wincache (http://php.net/wincache)
 *
 * 	 Cache::config('default', array(
 *		'engine' => 'Wincache', //[required]
 *		'duration'=> 3600, //[optional]
 *		'probability'=> 100, //[optional]
 *		'prefix' => Inflector::slug(APP_DIR) . '_', //[optional]  prefix every cache file with this string
 *	));
 */
Cache::config('default', array('engine' => 'File'));

/**
 * The settings below can be used to set additional paths to models, views and controllers.
 *
 * App::build(array(
 *     'Plugin' => array('/full/path/to/plugins/', '/next/full/path/to/plugins/'),
 *     'Model' =>  array('/full/path/to/models/', '/next/full/path/to/models/'),
 *     'View' => array('/full/path/to/views/', '/next/full/path/to/views/'),
 *     'Controller' => array('/full/path/to/controllers/', '/next/full/path/to/controllers/'),
 *     'Model/Datasource' => array('/full/path/to/datasources/', '/next/full/path/to/datasources/'),
 *     'Model/Behavior' => array('/full/path/to/behaviors/', '/next/full/path/to/behaviors/'),
 *     'Controller/Component' => array('/full/path/to/components/', '/next/full/path/to/components/'),
 *     'View/Helper' => array('/full/path/to/helpers/', '/next/full/path/to/helpers/'),
 *     'Vendor' => array('/full/path/to/vendors/', '/next/full/path/to/vendors/'),
 *     'Console/Command' => array('/full/path/to/shells/', '/next/full/path/to/shells/'),
 *     'Locale' => array('/full/path/to/locale/', '/next/full/path/to/locale/')
 * ));
 *
 */

/**
 * Custom Inflector rules, can be set to correctly pluralize or singularize table, model, controller names or whatever other
 * string is passed to the inflection functions
 *
 * Inflector::rules('singular', array('rules' => array(), 'irregular' => array(), 'uninflected' => array()));
 * Inflector::rules('plural', array('rules' => array(), 'irregular' => array(), 'uninflected' => array()));
 *
 */

/**
 * Plugins need to be loaded manually, you can either load them one by one or all of them in a single call
 * Uncomment one of the lines below, as you need. make sure you read the documentation on CakePlugin to use more
 * advanced ways of loading plugins
 *
 * CakePlugin::loadAll(); // Loads all plugins at once
 * CakePlugin::load('DebugKit'); //Loads a single plugin named DebugKit
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
if (!defined('SALT')) {
    define('SALT', 'urrasjksdjkbsdakbjvgikjbgfiabrg');
}

function pre() {
	$args = func_get_args();
	foreach($args as $arg) {
		pr($arg);
	}
}

function p_() {
  $args = func_get_args();
  $src = $args[0];
  $aid = $args[1];
  if (strpos($aid, 'avatar-') !== false) {
    $bits = explode('-', $aid);
    $aid = $bits[1];
    $m = filemtime(ALBUMS . DS . 'avatars' . DS . $aid . DS . $src);
  } else {
    $m = filemtime(ALBUMS . DS . 'album-' . $aid . DS . 'lg' . DS . $src);
  }
  $args = join(',', $args);
  $crypt = convert($args);
  return DIR_HOST . '/p.php?a=' . $crypt . '&amp;m=' . $m;
}

function p($options) {
  $defaults = array(
      'width' => 176,
      'height' => 132,
      'square' => 1, // 1 => new Size ; 2 => old Size, 3 => aspect ratio
      'quality' => 80,
      'sharpening' => 1,
      'anchor_x' => 50,
      'anchor_y' => 50,
      'force' => false
  );
  $o = array_merge($defaults, $options);
  $args = join(',', array($o['uid'], $o['id'], $o['fn'], $o['width'], $o['height'], $o['square'], $o['quality'], $o['sharpening'], $o['anchor_x'], $o['anchor_y'], (int) $o['force']));
  include_once(ROOT . DS . 'app' . DS . 'Controller' . DS . 'Component' . DS . 'SaltComponent.php');
  $salt = new SaltComponent();
  $crypt = $salt->convert($args);
  $path = PHOTOS . DS . $o['uid'] . DS . $o['id'] . DS . 'lg' . DS . $o['fn'];
  $m = filemtime($path);
  return BASE_URL . '/q/a:' . $crypt . '/m:' . $m;
}

function __p($options) {
  $defaults = array(
      'width' => 176,
      'height' => 132,
      'square' => 1, // 1 => new Size ; 2 => old Size, 3 => aspect ratio
      'quality' => 80,
      'sharpening' => 1,
      'anchor_x' => 50,
      'anchor_y' => 50,
      'force' => false
  );
  $o = array_merge($defaults, $options);
  $args = join(',', array($o['uid'], $o['id'], $o['fn'], $o['width'], $o['height'], $o['square'], $o['quality'], $o['sharpening'], $o['anchor_x'], $o['anchor_y'], (int) $o['force']));
  include_once(ROOT . DS . 'app' . DS . 'Controller' . DS . 'Component' . DS . 'SaltComponent.php');
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