<?php

class GalleriesAlbumsController extends AppController {

  var $name = 'GalleriesAlbums';

  function beforeFilter() {
    //$this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }

  function index() {
    $this->GalleriesAlbum->recursive = 0;
    $this->set('galleriesAlbums', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid galleries album', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('galleriesAlbum', $this->GalleriesAlbum->read(null, $id));
  }

  function add() {
    if (!empty($this->data)) {
      $this->GalleriesAlbum->create();
//      $this->log($this->data, LOG_DEBUG);
      $this->data['GalleriesAlbum']['id'] = null;
      if ($this->GalleriesAlbum->saveAll($this->data)) {
        $this->Session->setFlash(__('The galleries album has been saved', true));
        $this->set('json', array('id' => $this->GalleriesAlbum->id));
        $this->render(SIMPLE_JSON);
      } else {
        $this->Session->setFlash(__('The galleries album could not be saved. Please, try again.', true));
      }
    }
    $galleries = $this->GalleriesAlbum->Gallery->find('list');
    $albums = $this->GalleriesAlbum->Album->find('list');
    $this->set(compact('galleries', 'albums'));
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->Session->setFlash(__('Invalid galleries album', true));
      $this->redirect(array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->GalleriesAlbum->save($this->data)) {
        $this->Session->setFlash(__('The galleries album has been saved', true));
        $this->redirect(array('action' => 'index'));
      } else {
        $this->Session->setFlash(__('The galleries album could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->data)) {
      $this->data = $this->GalleriesAlbum->read(null, $id);
    }
    $galleries = $this->GalleriesAlbum->Gallery->find('list');
    $albums = $this->GalleriesAlbum->Album->find('list');
    $this->set(compact('galleries', 'albums'));
  }

  function delete($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for galleries album', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->GalleriesAlbum->delete($id)) {
      $this->Session->setFlash(__('Galleries album deleted', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->Session->setFlash(__('Galleries album was not deleted', true));
    $this->redirect(array('action' => 'index'));
  }

}

?>