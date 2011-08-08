<?php

class MysqlController extends AppController {

  var $name = 'Mysql';
  var $helpers = array();
  var $uses = array();

  function beforeFilter() {
    $this->autoRender = FALSE;
    $this->Auth->allowedActions = array('exec');
    parent::beforeFilter();
  }

  function exec() {
    $allowed_actions = array('dump', 'restore', 'connect');
    
    $action = array_splice($this->passedArgs, 0, 1);
    $action = $action[0];
    $args = implode(' ', $this->passedArgs);
    
    if(!in_array($action, $allowed_actions)) {
      echo 'command not in list of allowed commands';
      die(' ');
    }
    
    $mysql = $this->mysql($action, $args);
    echo $mysql;
    die(' ');
  }
  
  function mysql($action, $args = '') {
    if($action == 'dump') {
      $postfix = 'mysqldump';
      $io = '>';
    } elseif ($action == 'restore') {
      $postfix = 'mysql';
      $io = '<';
    } elseif (isempty($action)) {
      $cmd = 'mysql connect 192.168.1.16 2>&1';
      $op = `$cmd`;
      return $op;
    }
    
    
    $cmd = sprintf('%1s -uaxel -pkakadax -h 192.168.1.16 todos_backbone %2s E:/Sites/php/mysql_backup/file.sql 2>&1', $postfix, $io);
//    $cmd = sprintf('%1s -uaxel -pkakadax -h 192.168.1.11 todos_backbone %2s /Users/axel/file.sql', $postfix, $io);
    $this->log($cmd, LOG_DEBUG);
    $op = `$cmd`;
    return $op;
  }
}
