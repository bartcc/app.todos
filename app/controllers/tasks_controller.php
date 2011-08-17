<?php

class TasksController extends AppController {

  var $name = 'Tasks';
  var $helpers = array('Ajax', 'Js', 'Session');
  var $components = array('RequestHandler');
  
  function beforeFilter() {
    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }
  
  function index() {
    $this->Task->recursive = 0;
    $json = $this->Task->find('all', array('fields' => array('id', 'done', 'name', 'order'), 'order' => array('order')));
    $this->set('json', $json);
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid todo', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('json', $this->Task->read(null, $id));
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function add() {
    $payload = $this->getPayLoad();
    // validate the record to make sure we have all the data
    if (!isset($payload->name)) {
      // we got bad data so set up an error response and exit
      header('HTTP/1.1 400 Bad Request');
      header('X-Reason: Received an array of records when ' .
              'expecting just one');
      exit;
    }

    $id = $this->cleanValue($payload->id);
    $name = $this->cleanValue($payload->name);
    $done = $payload->done;
    $order = $payload->order;
    $this->data = array('name' => $name, 'done' => $done, 'id' => $id, 'order' => $order);
    $this->Task->create();
    $this->Task->save($this->data);
    $this->set('json', $this->data);
    $this->render(SIMPLE_JSON, 'ajax');
//        header('HTTP/1.1 204 No Content');
//        header("Location: http://".$_SERVER['HTTP_HOST'].'/todos/'.$id);
  }

  function edit($id = null) {

    if (empty($id)) {
      return;
    }

    $payload = $this->getPayLoad();
    $name = $this->cleanValue($payload->name);
    $done = $payload->done;
    $order = $payload->order;
    $this->data = array('id' => $id, 'name' => $name, 'done' => $done, 'order' => $order);
    if ($this->Task->save($this->data)) {
      $this->set('json', $this->data);
      $this->render(SIMPLE_JSON, 'ajax');
    }
  }

  function delete($id = null) {

    if (!$id) {
      exit;
    }
    $this->Task->delete($id);
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

  // Escape special meaning character for MySQL
  // Must be used AFTER a session was opened
  private function cleanValue($value) {
    if (get_magic_quotes_gpc()) {
      $value = stripslashes($value);
    }

    if (!is_numeric($value)) {
      $value = mysql_real_escape_string($value);
    }
    return $value;
  }

  private function flatten_array($arr) {

    $out = array();
    debug($arr);
    foreach ($arr as $key => $val) {
      $val['Task']['done'] = $val['Task']['done'] == 1;
      array_push($out, $val['Task']);
    }
    return $out;
  }

}

?>