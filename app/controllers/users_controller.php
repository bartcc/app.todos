<?php

class UsersController extends AppController {

  var $name = 'Users';

  function beforeFilter() {
    $this->disableCache();
    $this->Auth->allowedActions = array('login', 'logout', 'auth');

    $this->Cookie->name = 'TODOS';
    $this->Cookie->time = 3600; // 1 hour

    parent::beforeFilter();
  }
    
  function login() {
    $user = $this->Auth->user();
    if($this->RequestHandler->isAjax()) {
      if ($user) {
        $this->User->Group->recursive = 0;
        $group = $this->User->Group->findById($this->Auth->user('group_id'));
        $groupname = $group['Group']['name'];
        $merged = array_merge($this->data['User'], array('id' => $this->Auth->user('id'), 'username' => $this->Auth->user('username'), 'name' => $this->Auth->user('name'), 'password' => '', 'sessionid' => $this->Session->id(), 'groupname' => $groupname, 'flash' => '<strong style="color:green">You\'re successfully logged in as ' . $this->Auth->user('name') . '</strong>', 'success' => 'true'));
        $json = $merged;
        $this->set(compact('json'));
        $this->render(SIMPLE_JSON);
      } elseif (isset($this->data)) {
        $merged = array_merge($this->data['User'], array('id' => '', 'username' => '', 'name' => '', 'password' => '', 'sessionid' => '', 'flash' => '<strong style="color:red">Login failed</strong>'));
        $json = $merged;
        $this->set(compact('json'));
        $this->header("HTTP/1.1 403 Forbidden");
        $this->render(SIMPLE_JSON);
      }
    }
  }

  function logout() {
    $this->Auth->logout();
    if (!$this->params['isAjax']) {
      $this->redirect(array('controller' => 'users', 'action' => 'login'));
    } else {
      $merged = array_merge($this->data['User'], array('id' => '', 'username' => '', 'name' => '', 'password' => '', 'sessionid' => '', 'flash' => '<strong>You\'re logged out successfully</strong>'));
      $json = $merged;
      $this->set(compact('json'));
      $this->render(SIMPLE_JSON);
    }
  }

  function auth() {
    if ($this->params['isAjax'] && $this->Auth->user()) {
      $user = $this->Auth->user();
      $merged = array_merge($this->data['User'], $user['User']);
      $json = $merged;
    } elseif (isset($this->data)) {
      $json = $this->data['User'];
    }
    $this->set(compact('json'));
    $this->render(SIMPLE_JSON);
  }

  function add() {
    $this->log($data, LOG_DEBUG);
  }
}

?>