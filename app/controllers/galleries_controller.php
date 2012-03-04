<?php

class GalleriesController extends AppController {

  var $name = 'Galleries';

  function beforeFilter() {
    //$this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }

  function index() {
    $this->Gallery->recursive = 1;
    $this->set('galleries', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid gallery', true));
    }
    $this->set('gallery', $this->Gallery->read(null, $id));
  }

  function add() {
    $this->log('GalleriesController::add', LOG_DEBUG);
    if (!empty($this->data)) {
      $this->Gallery->create();
//      $this->data['Gallery']['id'] = null;
      if ($this->Gallery->save($this->data)) {
        $this->Session->setFlash(__('The gallery has been saved', true));
        $this->set('json', array('id' => $this->Gallery->id));
        $this->render(SIMPLE_JSON);
      } else {
        $this->Session->setFlash(__('The gallery could not be saved. Please, try again.', true));
      }
    }
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->Session->setFlash(__('Invalid gallery', true));
      $this->redirect(array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->Gallery->saveAll($this->data)) {
        $this->Session->setFlash(__('The gallery has been saved', true));
        $this->render(BLANK_RESPONSE);
      } else {
        $this->Session->setFlash(__('The gallery could not be saved. Please, try again.', true));
      }
    }
  }

  function delete($id = null) {
    $this->log('GalleriesController::delete', LOG_DEBUG);
    $this->log($id, LOG_DEBUG);
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for gallery', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->Gallery->delete($id)) {
      $this->Session->setFlash(__('Gallery deleted', true));
      $this->render(BLANK_RESPONSE);
    }
  }

}

?>