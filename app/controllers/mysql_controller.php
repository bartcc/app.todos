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
    
    $args = $this->passedArgs;
    
    $action = $args[0];
    
    $db     = isset($args[1]) ? $args[1] : NULL;
    
    // get the controller
    $refer_url = $this->referer('/', true);
    $router = Router::parse($refer_url);
    $controller = !empty($router['controller']) ? $router['controller'] : DEFAULT_CONTROLLER;
    $args = implode(' ', $this->passedArgs);
    
    if(!in_array($action, $allowed_actions)) {
      echo 'command not in list of allowed commands';
      header("Location: http://".$_SERVER['HTTP_HOST'].str_replace('//', '/', '/'.BASE_URL.'/' . $controller));
    }
    
    $mysql = $this->mysql($action, $db);
    header("Location: http://".$_SERVER['HTTP_HOST'].str_replace('//', '/', '/'.BASE_URL.'/' . $controller));
  }
  
  function mysql($action, $db) {
      
    // use default Database in case we haven't one
    $db = !isset($db) ? DEFAULT_DB : $db;
    
    
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
    $cmd = sprintf('%1s --defaults-extra-file='.MYSQLCONFIG.'/my.cnf ' . $db . ' %2s ' . MYSQLUPLOAD . '/' . $db . '.sql 2>&1', $postfix, $io);
//    $cmd = sprintf('%1s --login-path=local todos_backbone %2s ' . MYSQLUPLOAD . '/file.sql 2>&1', $postfix, $io);
    $op = `$cmd`;
    return $op;
  }
}
