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
      header("Location: http://".$_SERVER['HTTP_HOST'].str_replace('//', '/', '/'.BASE_URL.'/todos_app'));
    }
    
    $mysql = $this->mysql($action, $args);
    header("Location: http://".$_SERVER['HTTP_HOST'].str_replace('//', '/', '/'.BASE_URL.'/todos_app'));
  }
  
  function mysql($action, $args = '') {
    if($action == 'dump') {
      $postfix = MYSQL_CMD_PATH . 'mysqldump';
      $io = '>';
    } elseif ($action == 'restore') {
      $postfix = MYSQL_CMD_PATH . 'mysql';
      $io = '<';
    } elseif (isempty($action)) {
      $cmd = 'mysql connect localhost 2>&1';
      $op = `$cmd`;
      return $op;
    }
    $this->log(ROOT, LOG_DEBUG);
    $cmd = sprintf('%1s --defaults-extra-file='.MYSQLCONFIG.'/my.cnf todos_backbone %2s ' . MYSQLUPLOAD . '/file.sql 2>&1', $postfix, $io);
//    $cmd = sprintf('%1s --login-path=local todos_backbone %2s ' . MYSQLUPLOAD . '/file.sql 2>&1', $postfix, $io);
    $op = `$cmd`;
    return $op;
  }
}
