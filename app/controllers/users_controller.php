<?php

class UsersController extends AppController {

  var $name = 'Users';

  function beforeFilter() {
    $this->disableCache();
    $this->Auth->allowedActions = array('login', 'logout', 'auth', 'ping');

    $this->Cookie->name = 'TODOS';
    $this->Cookie->time = 3600; // 1 hour

    $this->User->Group->recursive = 0;
    $group = $this->User->Group->findById($this->Auth->user('group_id'));
    $this->groupname = $group['Group']['name'];
    
    parent::beforeFilter();
  }

  function login() {
    if ($this->RequestHandler->isAjax()) {
      if(!empty($this->data)) {
        $this->Auth->logout();
        $this->Auth->login($this->data);
        $user = $this->Auth->user();
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
    } else {
      $this->layout = 'login_layout';
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

  function index() {
    if ($this->groupname != 'Administrators') {
      $this->redirect(array('action' => 'login'));
    }
    $this->User->recursive = 0;
    $this->set('users', $this->paginate());
  }

  function view($id = null) {
    if ($this->groupname != 'Administrators') {
      $this->redirect(array('action' => 'login'));
    }
    if (!$id) {
      $this->Session->setFlash(__('Invalid user', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('user', $this->User->read(null, $id));
  }

  function add() {
    if ($this->groupname != 'Administrators') {
      $this->redirect(array('action' => 'login'));
    }
    if (!empty($this->data)) {
      $this->User->create();
      if ($this->User->save($this->data)) {
        $this->Session->setFlash(__('The user has been saved', true));
        if ($this->RequestHandler->isAjax()) {
          $this->render(SIMPLE_JSON);
        } else {
          $this->redirect(array('action' => 'index'));
        }
      } else {
        if ($this->RequestHandler->isAjax()) {
          $value = $this->User->invalidFields();
          foreach ($value as $field => $error) {
            $json = array_merge($value, array($field => array('error' => $error)));
          }
          $this->set(compact('json'));
          $this->header("HTTP/1.1 500 Internal Server Error");
          $this->render(SIMPLE_JSON);
        } else {
          $this->Session->setFlash(__('The user could not be saved. Please, try again.', true));
        }
      }
    }
    $groups = $this->User->Group->find('list');
    $this->set(compact('groups'));
  }

  function edit($id = null) {
    if ($this->groupname != 'Administrators') {
      $this->redirect(array('action' => 'login'));
    }
    if (!$id && empty($this->data)) {
      $this->Session->setFlash(__('Invalid user', true));
      $this->redirect(array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->User->save($this->data)) {
        $this->Session->setFlash(__('The user has been saved', true));
        $this->redirect(array('action' => 'index'));
      } else {
        $this->Session->setFlash(__('The user could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->data)) {
      $this->data = $this->User->read(null, $id);
    }
    $groups = $this->User->Group->find('list');
    $this->set(compact('groups'));
  }

  function delete($id = null) {
    if ($this->groupname != 'Administrators') {
      $this->redirect(array('action' => 'login'));
    }
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for user', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->User->delete($id)) {
      $this->Session->setFlash(__('User deleted', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->Session->setFlash(__('User was not deleted', true));
    $this->redirect(array('action' => 'index'));
  }
  
  function ping() {
    $user = $this->Auth->user();
    if($this->RequestHandler->isAjax()) {
      if(!empty($this->data) && !empty($user)) {
        $this->data['User'] = array_merge($this->data['User'], array('id' => $this->Auth->user('id'), 'sessionid' => $this->Session->id(), 'success' => true));
        $this->set('json', $this->data);
        $this->render(SIMPLE_JSON);
      } else {
        $json = array('User' => array('success' => false));
        $json = $this->set(compact('json'));
        $this->render(SIMPLE_JSON);
      }
    }
  }
}

?>