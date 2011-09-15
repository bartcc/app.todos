<?php

class KodaksController extends AppController {

  var $name = 'Kodaks';
  var $uses = array();
  var $disableSessions = true;

  function beforeFilter() {
    $this->disableCache();
    $this->Auth->allowedActions = array('develop');
    parent::beforeFilter();
  }

  function beforeRender() {
    parent::beforeRender();
  }

  private function returnExt($file) {
    $pos = strrpos($file, '.');
    return strtolower(substr($file, $pos + 1, strlen($file)));
  }

  private function n($var, $default = false) {
    $var = trim($var);
    if (is_numeric($var)) {
      return $var;
    } else if ($default) {
      return $default;
    } else {
      exit;
    }
  }

  function index() {
    $this->autoRender = false;
    $this->layout = false;
  }

  function develop() {
    $this->autoRender = false;
    $this->layout = false;
    $val = $this->params['named']['a'];
    //$this->log($this->params, LOG_DEBUG);
    if (strpos($val, 'http://') !== false || substr($val, 0, 1) == '/') {
      header('Location: ' . $val);
      exit;
    } else {
      $val = str_replace(' ', '.2B', $val);
    }

    if (!defined('UPLOAD_DIR')) {
      define('UPLOAD_DIR', 'uploads');
    }

    App::import('Component', 'Salt');
    $salt = new SaltComponent();
    $val = str_replace(' ', '.2B', $val);
    $crypt = $salt->convert($val, false);
    $a = explode(',', $crypt);
    //$this->log($a, LOG_DEBUG);
    $file = $fn = basename($a[0]);
    // Make sure supplied filename contains only approved chars
    if (preg_match("/[^A-Za-z0-9._-]/", $file)) {
      header('HTTP/1.1 403 Forbidden');
      exit;
    }

    $id = $a[1];
    $w = $this->n($a[2]);
    $h = $this->n($a[3]);
    $q = $this->n($a[4], 100);
    $sq = $this->n($a[5]);
    $sh = $this->n($a[6], 0);
    $x = $this->n($a[7], 50);
    $y = $this->n($a[8], 50);
    $force = $this->n($a[9], 0);

    if ($sq != 1) {
      list($w, $h) = computeSize(PRODUCTIMAGES . DS . $id . DS . $fn, $w, $h, $sq);
      $w = $this->n($w);
      $h = $this->n($h);
    }

    $ext = $this->returnExt($file);

    if (strpos($id, 'avatar') !== false) {
      $bits = explode('-', $id);
      $id = $bits[1];
      define('PATH', PRODUCTIMAGES . DS . 'avatars' . DS . $id);
      $original = PATH . DS . $file;
      $base_dir = PATH;
    } else {
      define('PATH', PRODUCTIMAGES . DS . $id);
      $original = PATH . DS . $file;
      $base_dir = PATH . DS . 'cache';
    }

    if ($sq == 2) {
      $base_dir = PATH;
      $path_to_cache = $original;
    } else {
      $fn .= "_{$w}_{$h}_{$sq}_{$q}_{$sh}_{$x}_{$y}";
      $fn .= ".$ext";
      $base_dir = PATH . DS . 'cache';
      $path_to_cache = PATH . DS . 'cache' . DS . $fn;
    }

    // Make sure dirname of the cached copy is sane
    if (dirname($path_to_cache) !== $base_dir) {
      header('HTTP/1.1 403 Forbidden');
      exit;
    }

    $noob = false;

    if (!file_exists($path_to_cache)) {
      $noob = true;
      if ($sq == 2) {
        copy($original, $path_to_cache);
      } else {
        if (!defined('MAGICK_PATH')) {
          define('MAGICK_PATH_FINAL', 'convert');
        } else if (strpos(strtolower(MAGICK_PATH), 'c:\\') !== false) {
          define('MAGICK_PATH_FINAL', '"' . MAGICK_PATH . '"');
        } else {
          define('MAGICK_PATH_FINAL', MAGICK_PATH);
        }
        if (!defined('FORCE_GD')) {
          define('FORCE_GD', 0);
        }
        if (!is_dir(dirname($path_to_cache))) {
          $parent_perms = substr(sprintf('%o', fileperms(dirname(dirname($path_to_cache)))), -4);
          $old = umask(0);
          mkdir(dirname($path_to_cache), octdec($parent_perms));
          umask($old);
        }

        App::import('Component', 'Darkroom');
        $d = new DarkroomComponent();
        $d->develop($original, $path_to_cache, $w, $h, $q, $sh, $sq, $x, $y, $force);
      }
    }

    $specs = getimagesize($path_to_cache);
    $mtime = filemtime($path_to_cache);
    $etag = md5($path_to_cache . $mtime);
    if (!$noob) {
      if (isset($_SERVER['HTTP_IF_NONE_MATCH']) && ($_SERVER['HTTP_IF_NONE_MATCH'] == $etag)) {
        header("HTTP/1.1 304 Not Modified");
        exit;
      }

      if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) && (strtotime($_SERVER['HTTP_IF_MODIFIED_SINCE']) >= filemtime($path_to_cache))) {
        header("HTTP/1.1 304 Not Modified");
        exit;
      }
    }

    $disabled_functions = explode(',', ini_get('disable_functions'));



    header('Content-type: ' . $specs['mime']);
    header('Content-length: ' . filesize($path_to_cache));
    header('Cache-Control: public');
    header('Expires: ' . gmdate('D, d M Y H:i:s', strtotime('+1 year')));
    header('Last-Modified: ' . gmdate('D, d M Y H:i:s', filemtime($path_to_cache)));
    header('ETag: ' . $etag);
    if (is_callable('readfile') && !in_array('readfile', $disabled_functions)) {
      readfile($path_to_cache);
    } else {
      die(file_get_contents($path_to_cache));
    }
  }

}

?>