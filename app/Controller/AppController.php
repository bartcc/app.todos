<?php

/**
 * Application level Controller
 *
 * This file is application-wide controller file. You can put all
 * application-wide controller-related methods here.
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
 * @package       app.Controller
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
App::uses('Controller', 'Controller');

/**
 * Application Controller
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @package       app.Controller
 * @link http://book.cakephp.org/2.0/en/controllers.html#the-app-controller
 */
class AppController extends Controller {

  public $helpers = array('Session', 'Html', 'Js');
  public $components = array('RequestHandler', 'Session', 'Auth', 'Cookie');

  function beforeFilter() {
    if ($this->request->is('ajax')) {
      $this->autoRender = FALSE;
      $this->Auth->autoRedirect = FALSE;
      
      $data = $this->request->input('json_decode');
      if(!empty($data)) {
        $data = $this->object2Array($data);
        $this->request->data = $data;
      }
      $this->_data = $this->data;
    }
  }
  
  function object2array($obj) {
    $_arr = is_object($obj) ? get_object_vars($obj) : $obj;
    $arr = null;
    foreach ($_arr as $key => $val) {
      $val = (is_array($val) || is_object($val)) ? $this->object2array($val) : $val;
      $arr[$key] = $val;
    }
    return $arr;
  }

  // Escape special meaning character for MySQL
  // Must be used AFTER a session was opened
  private function cleanValue($value) {
    if (get_magic_quotes_gpc()) {
      $value = stripslashes($value);
    }

    if (!is_numeric($value)) {
      $value = mysql_real_escape_string($value);
    }
    return $value;
  }

  private function flatten_array($arr) {

    $out = array();
//    debug($arr);
    foreach ($arr as $key => $val) {
      $val['Contact']['done'] = $val['Contact']['done'] == 1;
      array_push($out, $val['Contact']);
    }
    return $out;
  }

}
