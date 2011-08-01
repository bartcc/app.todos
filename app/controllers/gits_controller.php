<?php

class GitsController extends AppController {

  var $name = 'Gits';
  var $helpers = array();
  var $uses = array();

  function beforeFilter() {
    $this->autoRender = FALSE;
    parent::beforeFilter();
  }

  function exec() {
    $allowed_actions = array('checkout', 'test');
    
    $action = array_splice($this->passedArgs, 0, 1);
    $action = $action[0];
    $args = implode(' ', $this->passedArgs);
    
    if(!in_array($action, $allowed_actions))
      return;
    
    //$func = $action;
    //if(method_exists($this, $func)) {
      $git = $this->git($action, $args);
      $this->log($git, LOG_DEBUG);
    //}
    
    
    $this->redirect('/');
  }
  
  function git($action, $args = '') {
    $this->log('callaing git ' . $action . ' ' . $args, LOG_DEBUG);
    $op = `git $action $args 2>&1`;
    return $op;
  }
}
