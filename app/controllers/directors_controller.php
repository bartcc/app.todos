<?php

class DirectorsController extends AppController {

  var $name = 'Directors';
  var $helpers = array('Ajax', 'Js');
  var $components = array('RequestHandler');

  function beforeFilter() {
    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }
  
  function index() {
    $this->Director->recursive = 0;
    $json = $this->Director->find('all', array('fields' => array('id', 'first_name', 'last_name', 'email', 'mobile', 'work', 'address', 'notes')));
    $this->set('json', $json);
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid album', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('json', $this->Director->read(null, $id));
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function add() {
    $payload = $this->getPayLoad();
    // validate the record to make sure we have all the data
    if (!isset($payload->id)) {
      // we got bad data so set up an error response and exit
      header('HTTP/1.1 400 Bad Request');
      header('X-Reason: Received an array of records when ' .
              'expecting just one');
      exit;
    }

    $id = $this->cleanValue($payload->id);
    $first_name = $this->cleanValue($payload->first_name);
    $last_name = $this->cleanValue($payload->last_name);
    $email = $this->cleanValue($payload->email);
    $mobile = $this->cleanValue($payload->mobile);
    $work = $this->cleanValue($payload->work);
    $address = $this->cleanValue($payload->address);
    $notes = $this->cleanValue($payload->notes);
    $this->data = array(
        'id' => $id,
        'first_name' => $first_name,
        'last_name' => $last_name,
        'email' => $email,
        'mobile' => $mobile,
        'work' => $work,
        'address' => $address,
        'notes' => $notes
    );
    $this->Director->create();
//        $this->data = array('id' => $this->Director->id);
    $this->Director->save($this->data);
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
    $id = $this->cleanValue($payload->id);
    $first_name = $this->cleanValue($payload->first_name);
    $last_name = $this->cleanValue($payload->last_name);
    $email = $this->cleanValue($payload->email);
    $mobile = $this->cleanValue($payload->mobile);
    $work = $this->cleanValue($payload->work);
    $address = $this->cleanValue($payload->address);
    $notes = $this->cleanValue($payload->notes);
    $this->data = array(
        'id' => $id,
        'first_name' => $first_name,
        'last_name' => $last_name,
        'email' => $email,
        'mobile' => $mobile,
        'work' => $work,
        'address' => $address,
        'notes' => $notes
    );
    if ($this->Director->save($this->data)) {
      $this->set('json', $this->data);
      $this->render(SIMPLE_JSON, 'ajax');
    }
  }

  function delete($id = null) {

    if (!$id) {
      exit;
    }
    $this->Director->delete($id);
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
      $val['Director']['done'] = $val['Director']['done'] == 1;
      array_push($out, $val['Director']);
    }
    return $out;
  }

}

?>