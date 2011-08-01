<?php

class GitsController extends AppController {

  var $name = 'Gits';
  var $helpers = array();
  var $uses = array();

  function beforeFilter() {
    $this->autoRender = FALSE;
    parent::beforeFilter();
  }

  function exec($redir = '/') {

    if(empty ($this->passedArgs['branch'])) return;
    
    $branch = $this->passedArgs['branch'];
    $git = $this->run_git($branch);
    
    if($redir != $this->params['action']) {
      $this->redirect(array('controller' => $redir));
    }
    
    $this->redirect($redir);
  }
  
  function run_git($branch) {
    $op = `git checkout $branch 2>&1`;
    return $op;
  }
}
