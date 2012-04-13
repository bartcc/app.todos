<?php

class AlbumsPhotosController extends AppController {

  var $name = 'AlbumsPhotos';

  function beforeFilter() {
    //$this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }
  
  function index() {
    $this->AlbumsPhoto->recursive = 0;
    $this->set('albumsPhotos', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid albums photo', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('albumsPhoto', $this->AlbumsPhoto->read(null, $id));
  }

  function add() {
    if (!empty($this->data)) {
      $this->AlbumsPhoto->create();
      $this->data['AlbumsPhoto']['id'] = null;
      if ($this->AlbumsPhoto->saveAll($this->data)) {
        $this->Session->setFlash(__('The albums photo has been saved', true));
        $this->set('json', array('id' => $this->AlbumsPhoto->id));
        $this->render(SIMPLE_JSON);
      } else {
        $this->Session->setFlash(__('The albums photo could not be saved. Please, try again.', true));
      }
    }
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->Session->setFlash(__('Invalid albums photo', true));
      $this->redirect(array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->AlbumsPhoto->save($this->data)) {
        $this->Session->setFlash(__('The albums photo has been saved', true));
        $this->render(BLANK_RESPONSE);
      } else {
        $this->Session->setFlash(__('The albums photo could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->data)) {
      $this->data = $this->AlbumsPhoto->read(null, $id);
    }
  }

  function delete($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for albums photo', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->AlbumsPhoto->delete($id)) {
      $this->Session->setFlash(__('Albums photo deleted', true));
      $this->render(BLANK_RESPONSE);
    }
  }

}

?>