<?php

class GalleriesController extends AppController {

  var $name = 'Galleries';
  var $helpers = array('Ajax', 'Js');
  var $components = array('RequestHandler');

  function beforeFilter() {
    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }
  
  function index() {
    $this->Gallery->recursive = 1;
    $json = $this->Gallery->find('all', array('fields' => array('id', 'name', 'author', 'description')));
    //$this->log($json, LOG_DEBUG);
    //$this->log($json, LOG_DEBUG);
    $this->set('json', $json);
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid album', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('json', $this->Gallery->read(null, $id));
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function add() {
    // validate the record to make sure we have all the data
    if (empty($this->data['Gallery']['id'])) {
      // we got bad data so set up an error response and exit
      header('HTTP/1.1 400 Bad Request');
      header('X-Reason: received empty gallery name');
      exit;
    }

    $this->Gallery->create();
    $this->Gallery->save($this->data);
    $this->set('json', $this->data['Gallery']);
    $this->render(SIMPLE_JSON, 'ajax');
  }

  function edit($id = null) {

    if (empty($id)) {
      return;
    }

    if ($this->Gallery->save($this->data)) {
      $this->set('json', $this->data['Gallery']);
      $this->render(SIMPLE_JSON, 'ajax');
    }
  }

  function delete($id = null) {

    if (!$id) {
      exit;
    }
    $this->Gallery->delete($id);
  }


}

?>