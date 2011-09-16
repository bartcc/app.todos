<?php

class TodosController extends AppController {

  var $name = 'Todos';
  var $helpers = array('Ajax', 'Js', 'Session');
  var $components = array('RequestHandler');

  function index() {
    $this->Todo->recursive = 0;
    $json = $this->Todo->find('all', array('fields' => array('id', 'done', 'order', 'content')));
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
    // validate the record to make sure we have all the data
    
    if (empty($this->data['Todo']['order'])) {
      // we got bad data so set up an error response and exit
      header('HTTP/1.1 400 Bad Request');
      header('X-Reason: Received an array of records when ' .
              'expecting just one');
      exit;
    }

    $this->Todo->create();
    $this->Todo->save($this->data);
    $id = $this->Todo->id;
    $this->data = $this->data + array('id' => (string) $id);
    $this->set('json', $this->data['Todo']);
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function edit($id = null) {

    if (empty($id)) {
      return;
    } else {
      settype($id, 'integer');
    }

    if ($this->Todo->save($this->data)) {
      $this->set('json', $this->data['Todo']);
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

}

?>