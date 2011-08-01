<?php

class GitsController extends AppController {

  var $name = 'Gits';
  var $helpers = array();
  var $uses = array();

  function beforeFilter() {
    $this->autoRender = FALSE;
    parent::beforeFilter();
  }

  function checkout($redir) {

    if(empty ($this->passedArgs['branch'])) return;
    
    $branch = $this->passedArgs['branch'];
    $git = $this->run_git($branch);
    $this->log($git, LOG_DEBUG);
    
    if(isset ($redir) && $redir == $this->params['action']) {
      $this->redirect(array('controller' => $redir));
    } else {
      $this->redirect('/');
    }
    die( );
  }
  
  function run_git($branch) {
    if (defined('SERVER_IIS') && SERVER_IIS === true) {
      $op = `"D:\Program Files\Git\bin\git.exe" checkout $branch 2>&1`;
    } else {
      $op = `git checkout $branch 2>&1`;
    }
    return $op;
  }
}
