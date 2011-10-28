<?php

class PhotosController extends AppController {

  var $name = 'Photos';

  function beforeFilter() {
    //$this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }
  
  function index() {
    $this->Photo->recursive = 0;
    $this->set('photos', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->flash(__('Invalid photo', true), array('action' => 'index'));
    }
    $this->set('photo', $this->Photo->read(null, $id));
  }

  function add() {
    if (!empty($this->data)) {
      $this->Photo->create();
      if ($this->Photo->save($this->data)) {
        $this->flash(__('Image saved.', true), array('action' => 'index'));
      } else {
        
      }
    }
    $albums = $this->Photo->Album->find('list');
    $tags = $this->Photo->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->flash(sprintf(__('Invalid photo', true)), array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->Photo->save($this->data)) {
        $this->flash(__('The image has been saved.', true), array('action' => 'index'));
      } else {
        
      }
    }
    if (empty($this->data)) {
      $this->data = $this->Photo->read(null, $id);
    }
    $albums = $this->Photo->Album->find('list');
    $tags = $this->Photo->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  function delete($id = null) {
    if (!$id) {
      $this->flash(sprintf(__('Invalid image', true)), array('action' => 'index'));
    }
    if ($this->Photo->delete($id)) {
      $this->flash(__('Image deleted', true), array('action' => 'index'));
    }
    $this->flash(__('Image was not deleted', true), array('action' => 'index'));
    $this->redirect(array('action' => 'index'));
  }

}

?>