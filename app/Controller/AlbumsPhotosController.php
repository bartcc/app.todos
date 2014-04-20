<?php
App::uses('AppController', 'Controller');

class AlbumsPhotosController extends AppController {

  var $name = 'AlbumsPhotos';

  function beforeFilter() {
//    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
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
    if (!empty($this->request->data)) {
      $this->AlbumsPhoto->create();
      $data = $this->request->data;
      $this->log($data, LOG_DEBUG);
      $data['id'] = null;
      if ($this->AlbumsPhoto->saveAll($data)) {
        $this->Session->setFlash(__('The albums photo has been saved', true));
        $this->set('_serialize', array('id' => $this->AlbumsPhoto->id));
        $this->render(SIMPLE_JSON);
      } else {
        $this->Session->setFlash(__('The albums photo could not be saved. Please, try again.', true));
      }
    }
  }

  function edit($id = null) {
    if (!$id && empty($this->request->data)) {
      $this->Session->setFlash(__('Invalid albums photo', true));
      $this->redirect(array('action' => 'index'));
    }
    if (!empty($this->request->data)) {
      if ($this->AlbumsPhoto->save($this->request->data)) {
        $this->Session->setFlash(__('The albums photo has been saved', true));
      } else {
        $this->Session->setFlash(__('The albums photo could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->request->data)) {
      $this->request->data = $this->AlbumsPhoto->read(null, $id);
    }
  }

  function delete($id = null) {
//    $this->log($id, LOG_DEBUG);
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for albums photo', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->AlbumsPhoto->delete($id)) {
      $this->set('_serialize', array('id' => $this->AlbumsPhoto->id));
      $this->render(SIMPLE_JSON);
//      $this->Session->setFlash(__('Albums photo deleted', true));
    }
  }

}

?>