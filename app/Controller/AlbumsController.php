<?php
App::uses('AppController', 'Controller');

class AlbumsController extends AppController {

  var $name = 'Albums';

  function beforeFilter() {
    //$this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }

  function index() {
    $this->Album->recursive = 1;
    $albums = $this->Album->findAllByUser_id((string)($this->Auth->user('id')));
    $this->set('_serialize', $albums);
    $this->render(SIMPLE_JSON);
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid album', true));
    }
    $this->set('album', $this->Album->read(null, $id));
  }

  function add() {
    if (!empty($this->request->data)) {
      $this->Album->create();
      $this->request->data['Album']['id'] = null;
      if ($this->Album->save($this->request->data)) {
        $this->Session->setFlash(__('The album has been saved', true));
//        $this->log($this->Album->id, LOG_DEBUG);
        $this->set('_serialize', array('id' => $this->Album->id));
        $this->render(SIMPLE_JSON);
      } else {
        $this->Session->setFlash(__('The album could not be saved. Please, try again.', true));
      }
    }
  }

  function edit($id = null) {
    if (!$id && empty($this->request->data)) {
      $this->Session->setFlash(__('Invalid album', true));
      $this->redirect(array('action' => 'index'));
    }
    
    if (!empty($this->data)) {
      if ($this->Album->saveAssociated($this->data, array('deep' => true))) {
//        $this->log($this->data, LOG_DEBUG);
        $this->set('_serialize', array('id' => $this->Album->id));
        $this->render(SIMPLE_JSON);
        $this->Session->setFlash(__('The album has been saved', true));
      } else {
        $this->Session->setFlash(__('The album could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->request->data)) {
      $this->request->data = $this->Album->read(null, $id);
    }
  }

  function delete($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for album', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->Album->delete($id)) {
      $this->set('_serialize', array('id' => $this->Album->id));
      $this->render(SIMPLE_JSON);
      $this->Session->setFlash(__('Album deleted', true));
    }
    $this->Session->setFlash(__('Album was not deleted', true));
    $this->redirect(array('action' => 'index'));
  }

}

?>