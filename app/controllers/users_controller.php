<?php
class UsersController extends AppController {

	var $name = 'Users';

 function beforeFilter() {
    $this->disableCache();
    $this->Auth->allowedActions = array('login', 'logout', 'auth');
    
    $this->payload = $this->getPayLoad();
    
    if(isset($this->payload->username) && isset($this->payload->password)) {
      $this->data['User']['username'] = $this->payload->username;
      $this->data['User']['password'] = $this->payload->password;
      $this->response = $this->data;
    }
    
    $this->Cookie->name = 'TODOS';
    $this->Cookie->time = 3600; // 1 hour

    parent::beforeFilter();
  }
  
  function login() {
    $user = $this->Auth->user();
    if ($user) {
      $merged = array_merge($this->response['User'], array('id' => $this->Auth->user('id'), 'username' => $this->Auth->user('username'), 'name' => $this->Auth->user('name'), 'password' => '', 'sessionid' => $this->Session->id(), 'flash' => 'You are logged in'));
      $json = $merged;
      $this->set(compact('json'));
      $this->render(SIMPLE_JSON);
    } elseif (isset($this->response)) {
      $merged = array_merge($this->response['User'], array('id' => '', 'username' => '', 'name' => '', 'password' => '', 'sessionid' => '', 'flash' => 'Login failed'));
      $json = $merged;
      $this->set(compact('json'));
      $this->header("HTTP/1.1 403 Forbidden");
      $this->render(SIMPLE_JSON);
    }
  }
  
  function logout() {
    if ($this->params['isAjax']) {
      $this->Auth->logout();
    }
    $merged = array_merge($this->response['User'], array('id' => '', 'username' => '', 'name' => '', 'password' => '', 'sessionid' => ''));
    $json = $merged;
    $this->set(compact('json'));
    $this->render(SIMPLE_JSON);
  }
  
  function auth() {
    if ($this->params['isAjax'] && $this->Auth->user()) {
      $user = $this->Auth->user();
      $merged = array_merge($this->response['User'], $user['User']);
      $json = $merged;
    } elseif (isset($this->response)) {
      $json = $this->response['User'];
    }
    $this->set(compact('json'));
    $this->render(SIMPLE_JSON);
  }
  
  function add() {
    $this->log($data, LOG_DEBUG);
    
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
}
 
?>