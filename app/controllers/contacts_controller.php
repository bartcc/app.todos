<?php

class ContactsController extends AppController {

  var $name = 'Contacts';
  var $helpers = array('Ajax', 'Js');
  var $components = array('RequestHandler');

  function beforeFilter() {
    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }
  
  function index() {
    $this->Contact->recursive = 0;
    $json = $this->Contact->find('all', array('fields' => array('id', 'first_name', 'last_name', 'email', 'mobile', 'work', 'address', 'notes')));
    $this->set('json', $json);
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid contact', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('json', $this->Contact->read(null, $id));
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function add() {
    // validate the record to make sure we have all the data
    if (!isset($this->data['Contacts']['id'])) {
      // we got bad data so set up an error response and exit
      header('HTTP/1.1 400 Bad Request');
      header('X-Reason: Received an array of records when ' .
              'expecting just one');
      exit;
    }

    $this->Contact->create();
    $this->Contact->save($this->data);
    $this->set('json', $this->data['Contact']);
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function edit($id = null) {

    if (empty($id)) {
      return;
    }
    if ($this->Contact->save($this->data)) {
      $this->set('json', $this->data['Contact']);
      $this->render(SIMPLE_JSON, 'ajax');
    }
  }

  function delete($id = null) {

    if (!$id) {
      exit;
    }
    $this->Contact->delete($id);
  }
}

?>