<?php
App::uses('AppController', 'Controller');

class GalleriesAlbumsController extends AppController {

  public $name = 'GalleriesAlbums';

  function beforeFilter() {
//    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }

  public function index() {
    $this->GalleriesAlbum->recursive = 0;
    $this->set('galleriesAlbums', $this->paginate());
  }

  public function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid galleries album', true));
      $this->redirect(array('action' => 'index'));
    }
    $this->set('galleriesAlbum', $this->GalleriesAlbum->read(null, $id));
  }

  public function add() {
    if (!empty($this->request->data)) {
      $this->GalleriesAlbum->create();
      $this->request->data['id'] = null;
      if ($this->GalleriesAlbum->saveAll($this->request->data)) {
        $this->Session->setFlash(__('The galleries album has been saved', true));
        $this->set('_serialize', array('id' => $this->GalleriesAlbum->id));
        $this->render(SIMPLE_JSON);
      } else {
        $this->Session->setFlash(__('The galleries album could not be saved. Please, try again.', true));
      }
    }
//    $galleries = $this->GalleriesAlbum->Gallery->find('list');
//    $albums = $this->GalleriesAlbum->Album->find('list');
//    $this->set(compact('galleries', 'albums'));
  }

  public function edit($id = null) {
    if (!$id && empty($this->request->data)) {
      $this->Session->setFlash(__('Invalid galleries album', true));
      $this->redirect(array('action' => 'index'));
    }
    if (!empty($this->request->data)) {
      if ($this->GalleriesAlbum->save($this->request->data)) {
        $this->Session->setFlash(__('The galleries album has been saved', true));
        $this->redirect(array('action' => 'index'));
      } else {
        $this->Session->setFlash(__('The galleries album could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->request->data)) {
      $this->request->data = $this->GalleriesAlbum->read(null, $id);
    }
//    $galleries = $this->GalleriesAlbum->Gallery->find('list');
//    $albums = $this->GalleriesAlbum->Album->find('list');
//    $this->set(compact('galleries', 'albums'));
  }

  public function delete($id = null) {
    $this->GalleriesAlbum->recursive = 0;
    $this->log('GalleriesAlbumsController::delete', LOG_DEBUG);
    $this->log($id, LOG_DEBUG);
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for galleries album', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->GalleriesAlbum->delete($id)) {
      $this->set('_serialize', array('id' => $this->GalleriesAlbum->id));
      $this->render(SIMPLE_JSON);
//      $this->Session->setFlash(__('Galleries album deleted', true));
    }
  }
  
}

?>