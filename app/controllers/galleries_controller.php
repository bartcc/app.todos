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
    $g = $this->Gallery->read(null, $id);
    $this->set('gallery', $this->Gallery->read(null, $id));
  }

  function add() {
    $this->log($this->data, LOG_DEBUG);
    if (!empty($this->data)) {
      $this->Gallery->create();
      if ($this->Gallery->save($this->data)) {
        $this->Session->setFlash(__('The gallery has been saved', true));
      } else {
        $this->Session->setFlash(__('The gallery could not be saved. Please, try again.', true));
      }
    }
    $albums = $this->Gallery->Album->find('list');
    $this->set(compact('albums'));
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->Session->setFlash(__('Invalid gallery', true));
      $this->redirect(array('action' => 'index'));
    }
    if (!empty($this->data)) {
      $this->log($this->data, LOG_DEBUG);
      if ($this->Gallery->save($this->data)) {
        $this->Session->setFlash(__('The gallery has been saved', true));
      } else {
        $this->Session->setFlash(__('The gallery could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->data)) {
      $this->data = $this->Gallery->read(null, $id);
    }
    $albums = $this->Gallery->Album->find('list');
    $this->set(compact('albums'));
  }

  function delete($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for gallery', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->Gallery->delete($id)) {
      $this->Session->setFlash(__('Gallery deleted', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->Session->setFlash(__('Gallery was not deleted', true));
    $this->redirect(array('action' => 'index'));
  }

}

?>