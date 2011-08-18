<?php

class TodosController extends AppController {

  var $name = 'Todos';
  var $helpers = array('Ajax', 'Js', 'Session');
  var $components = array('RequestHandler');

  function index() {
    $this->Todo->recursive = 0;
    $json = $this->Todo->find('all', array('fields' => array('id', 'done', 'order', 'content')));
    //$json = array_merge($json, array('sessionid' => $this->Session->id()));
    $this->set('json', $json);
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid todo', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('json', $this->Todo->read(null, $id));
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function add() {
    $payload = $this->getPayLoad();
    // validate the record to make sure we have all the data
    if (!isset($payload->content) || !isset($payload->done)) {
      // we got bad data so set up an error response and exit
      header('HTTP/1.1 400 Bad Request');
      header('X-Reason: Received an array of records when ' .
              'expecting just one');
      exit;
    }

    $content = $payload->content;
    $order = $payload->order;
    $done = $payload->done ? 1 : 0;
    $this->data = array('content' => $content, 'done' => $done, 'order' => $order);
    $this->Todo->create();
    $this->Todo->save($this->data);
    $id = $this->Todo->id;
    $this->data = $this->data + array('id' => (string) $id);
    $this->set('json', $this->data);
    $this->render(SIMPLE_JSON, 'ajax');
//        header('HTTP/1.1 204 No Content');
//        header("Location: http://".$_SERVER['HTTP_HOST'].'/todos/'.$id);
  }

  function edit($id = null) {

    if (empty($id)) {
      return;
    } else {
      settype($id, 'integer');
    }

    $payload = $this->getPayLoad();
    $content = $payload->content;
    $done = $payload->done;
    $order = $payload->order;
    $this->data = array('id' => (string) $id, 'content' => $content, 'done' => $done, 'order' => $order);
    if ($this->Todo->save($this->data)) {
      $this->set('json', $this->data);
      $this->render(SIMPLE_JSON, 'ajax');
    }
  }

  function delete($id = null) {
    if (!$id) {
      exit;
    }
    settype($id, 'integer');
    $this->Todo->delete($id);
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
      $val['Task']['isDone'] = $val['Task']['isDone'] == 1;
      array_push($out, $val['Task']);
    }
    return $out;
  }

}

?>