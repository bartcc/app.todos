<?php
App::uses('AppController', 'Controller');

class GalleriesController extends AppController {

  public $name = 'Galleries';

  function beforeFilter() {
    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }

  public function index() {
    $this->Gallery->recursive = 1;
    $galleries = $this->Gallery->findAllByUser_id((string) $this->Auth->user('id'));
    $this->set('_serialize', $galleries);
    $this->render(SIMPLE_JSON);
  }

  public function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid gallery', true));
    }
    $this->set('gallery', $this->Gallery->read(null, $id));
  }

  public function add() {
//    $this->log('GalleriesController::add', LOG_DEBUG);
    if (!empty($this->request->data)) {
      $this->Gallery->create();
      $this->request->data['Gallery']['id'] = null;
      if ($this->Gallery->save($this->data)) {
        $this->Session->setFlash(__('The gallery has been saved', true));
        $this->set('_serialize', array('id' => $this->Gallery->id));
        $this->render(SIMPLE_JSON);
      } else {
        $this->Session->setFlash(__('The gallery could not be saved. Please, try again.', true));
      }
    }
  }

  public function edit($id = null) {
    if (!$id && empty($this->request->data)) {
      $this->Session->setFlash(__('Invalid gallery', true));
      $this->redirect(array('action' => 'index'));
    }
    
    if (!empty($this->request->data)) {
      if ($this->Gallery->saveAssociated($this->request->data, array('deep' => true))) {
        $this->log($this->data, LOG_DEBUG);
        $this->set('_serialize', array('id' => $this->Gallery->id));
        $this->render(SIMPLE_JSON);
        $this->Session->setFlash(__('The gallery has been saved', true));
      } else {
        $this->Session->setFlash(__('The gallery could not be saved. Please, try again.', true));
      }
    }
  }

  public function delete($id = null) {
//    $this->log('GalleriesController::delete', LOG_DEBUG);
    $this->log('GalleriesController::delete', LOG_DEBUG);
    $this->log($id, LOG_DEBUG);
    
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for gallery', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->Gallery->delete($id)) {
      $this->set('_serialize', array('id' => $this->Gallery->id));
      $this->render(SIMPLE_JSON);
//      $this->Session->setFlash(__('Gallery deleted', true));
    }
  }

}

?>