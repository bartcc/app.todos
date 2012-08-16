<?php
App::uses('AppController', 'Controller');

class UsersController extends AppController {

  public $name = 'Users';
  public $helpers = array('Form');

  function beforeFilter() {
    $this->Auth->allowedActions = array('login', 'logout', 'auth', 'ping');
    parent::beforeFilter();
  }
  
  function beforeRender() {
    $this->response->disableCache();
    parent::beforeRender();
  }
  
  function _groupName() {
    if($this->Auth->user('id')) {
      $this->User->Group->recursive = 0;
      $group = $this->User->Group->findById($this->Auth->user('group_id'));
      return $group['Group']['name'];
    }
  }
  
  function login() {
//    $this->log($this->Session->read('Auth.redirect'), LOG_DEBUG);
//    $this->log( $this->request->params, LOG_DEBUG);
    if ($this->request->is('ajax')) {
      
      if (!empty($this->data)) {
        $this->Auth->login();
        if($this->Auth->user('id')) {
          $this->set('_serialize', array_merge($this->data, array(
              'id' => $this->Auth->user('id'),
              'username' => $this->Auth->user('username'),
              'name' => $this->Auth->user('name'),
              'password' => '',
              'sessionid' => $this->Session->id(),
              'groupname' => $this->_groupname(),
              'flash' => '<strong style="color:green">You\'re successfully logged in as ' . $this->Auth->user('name') . '</strong>',
              'success' => 'true',
              'redirect' => $this->Session->loginRedirect
              )));
        } else {
          $this->response->header("WWW-Authenticate: Negotiate");
          $this->set('_serialize', array_merge($this->data, array(
              'id' => '',
              'username' => '',
              'name' => '',
              'password' => '',
              'sessionid' => '',
              'flash' => '<strong style="color:red">Login failed</strong>'
              )));
        }
        $this->render(SIMPLE_JSON);
      }
    } else {
      $this->layout = 'login_layout';
    }
  }
  
  function logout() {
    $this->Auth->logout();
    if (!$this->request->is('ajax')) {
      $this->redirect(array('controller' => 'users', 'action' => 'login'));
    } else {
      $json = array_merge($this->data['User'], array('id' => '', 'username' => '', 'name' => '', 'password' => '', 'sessionid' => '', 'flash' => '<strong>You\'re logged out successfully</strong>'));
      $this->set('_serialize', $json);
      $this->render(SIMPLE_JSON);
    }
  }

  function auth() {
    if ($this->request->is('ajax') && $this->Auth->user('id')) {
      $user = $this->Auth->user();
      $json = array_merge($this->request->data['User'], $user['User']);
    } elseif (isset($this->request->data)) {
      $json = $this->request->data['User'];
    }
    $this->set('_serialize', $json);
    $this->render(SIMPLE_JSON);
  }

  function index() {
    if ($this->groupname != 'Administrators') {
//      $this->redirect(array('action' => 'login'));
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
    if (!empty($this->request->data)) {
      $this->User->create();
      if ($this->User->save($this->data)) {
        $this->Session->setFlash(__('The user has been saved', true));
        if ($this->request->is('ajax')) {
          $this->render(SIMPLE_JSON);
        } else {
          $this->redirect(array('action' => 'index'));
        }
      } else {
        if ($this->request->is('ajax')) {
          $value = $this->User->invalidFields();
          foreach ($value as $field => $error) {
            $json = array_merge($value, array($field => array('error' => $error)));
          }
          $this->set('_serialize', $json);
          $this->response->header("HTTP/1.1 500 Internal Server Error");
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
      if ($this->User->save($this->request->data)) {
        $this->Session->setFlash(__('The user has been saved', true));
        $this->redirect(array('action' => 'index'));
      } else {
        $this->Session->setFlash(__('The user could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->request->data)) {
      $this->request->data = $this->User->read(null, $id);
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
    if($this->request->is('ajax')) {
      if(!empty($this->data) && !empty($user)) {
        $this->set('_serialize', array_merge($this->data, array('id' => $this->Auth->user('id'), 'sessionid' => $this->Session->id(), 'success' => true)));
      } else {
        $this->set('_serialize', array('success' => false));
      }
      $this->render(SIMPLE_JSON);
    }
  }
}

?>