<?php

class AlbumsController extends AppController {

  var $name = 'Albums';

  function beforeFilter() {
    //$this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }

  function index() {
    $this->Album->recursive = 0;
    $this->set('albums', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid album', true));
    }
    $this->set('album', $this->Album->read(null, $id));
  }

  function add() {
    if (!empty($this->data)) {
      $this->Album->create();
      $this->data['Album']['id'] = null;
      if ($this->Album->save($this->data)) {
        $this->Session->setFlash(__('The album has been saved', true));
        $this->set('json', array('id' => $this->Album->id));
        $this->render(SIMPLE_JSON);
      } else {
        $this->Session->setFlash(__('The album could not be saved. Please, try again.', true));
      }
    }
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->Session->setFlash(__('Invalid album', true));
      $this->redirect(array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->Album->save($this->data)) {
        $this->Session->setFlash(__('The album has been saved', true));
        $this->render(BLANK_RESPONSE);
      } else {
        $this->Session->setFlash(__('The album could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->data)) {
      $this->data = $this->Album->read(null, $id);
    }
  }

  function delete($id = null) {
    if (!$id) {
      $this->Session->setFlash(__('Invalid id for album', true));
      $this->redirect(array('action' => 'index'));
    }
    if ($this->Album->delete($id)) {
      $this->Session->setFlash(__('Album deleted', true));
      $this->render(BLANK_RESPONSE);
    }
    $this->Session->setFlash(__('Album was not deleted', true));
    $this->redirect(array('action' => 'index'));
  }

}

?>