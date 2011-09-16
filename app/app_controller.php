<?php

/**
 * Application level Controller
 *
 * This file is application-wide controller file. You can put all
 * application-wide controller-related methods here.
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
 * @subpackage    cake.app
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

/**
 * Application Controller
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @package       cake
 * @subpackage    cake.app
 */
class AppController extends Controller {

  var $helpers = array('Session', 'Html', 'Js');
  var $components = array('RequestHandler', 'Session', 'Auth', 'Cookie');
  
  function beforeFilter() {
    if ($this->RequestHandler->isAjax()) {
      $this->autoRender = FALSE;
      $this->Auth->autoRedirect = FALSE;
    }
    
    $data = $this->getPayLoad();
    if(!empty($data)) {
      foreach($data as $key => $value) {
        $this->data[$this->modelClass][$key] = $value;
      }
    }
  }
  
  function beforeRender() {
    if ($this->RequestHandler->isAjax())
      $this->layout = 'ajax';
  }
  
  private function getPayLoad() {
    $payload = FALSE;
    if (isset($_SERVER['CONTENT_LENGTH']) && $_SERVER['CONTENT_LENGTH'] > 0) {
      $payload = '';
      $httpContent = fopen('php://input', 'r');
      while ($data = fread($httpContent, 1024)) {
        $payload .= $data;
      }
      fclose($httpContent);
    }

    // check to make sure there was payload and we read it in
    if (!$payload)
      return FALSE;

    // translate the JSON into an associative array
    $obj = json_decode($payload);
    return $obj;
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
    debug($arr);
    foreach ($arr as $key => $val) {
      $val['Contact']['done'] = $val['Contact']['done'] == 1;
      array_push($out, $val['Contact']);
    }
    return $out;
  }
}
