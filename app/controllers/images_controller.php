<?php

class ImagesController extends AppController {

  var $name = 'Images';

  function beforeFilter() {
    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }
  
  function index() {
    $this->Image->recursive = 0;
    $this->set('images', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->flash(__('Invalid image', true), array('action' => 'index'));
    }
    $this->set('image', $this->Image->read(null, $id));
  }

  function add() {
    if (!empty($this->data)) {
      $this->Image->create();
      if ($this->Image->save($this->data)) {
        $this->flash(__('Image saved.', true), array('action' => 'index'));
      } else {
        
      }
    }
    $albums = $this->Image->Album->find('list');
    $tags = $this->Image->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->flash(sprintf(__('Invalid image', true)), array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->Image->save($this->data)) {
        $this->flash(__('The image has been saved.', true), array('action' => 'index'));
      } else {
        
      }
    }
    if (empty($this->data)) {
      $this->data = $this->Image->read(null, $id);
    }
    $albums = $this->Image->Album->find('list');
    $tags = $this->Image->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  function delete($id = null) {
    if (!$id) {
      $this->flash(sprintf(__('Invalid image', true)), array('action' => 'index'));
    }
    if ($this->Image->delete($id)) {
      $this->flash(__('Image deleted', true), array('action' => 'index'));
    }
    $this->flash(__('Image was not deleted', true), array('action' => 'index'));
    $this->redirect(array('action' => 'index'));
  }

}

?>