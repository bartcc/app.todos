<?php

class BitmapsController extends AppController {

  var $name = 'Bitmaps';

  function beforeFilter() {
    //$this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }
  
  function index() {
    $this->Bitmap->recursive = 0;
    $this->set('bitmaps', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->flash(__('Invalid bitmap', true), array('action' => 'index'));
    }
    $this->set('bitmap', $this->Bitmap->read(null, $id));
  }

  function add() {
    if (!empty($this->data)) {
      $this->Bitmap->create();
      if ($this->Bitmap->save($this->data)) {
        $this->flash(__('Image saved.', true), array('action' => 'index'));
      } else {
        
      }
    }
    $albums = $this->Bitmap->Album->find('list');
    $tags = $this->Bitmap->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->flash(sprintf(__('Invalid bitmap', true)), array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->Bitmap->save($this->data)) {
        $this->flash(__('The image has been saved.', true), array('action' => 'index'));
      } else {
        
      }
    }
    if (empty($this->data)) {
      $this->data = $this->Bitmap->read(null, $id);
    }
    $albums = $this->Bitmap->Album->find('list');
    $tags = $this->Bitmap->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  function delete($id = null) {
    if (!$id) {
      $this->flash(sprintf(__('Invalid image', true)), array('action' => 'index'));
    }
    if ($this->Bitmap->delete($id)) {
      $this->flash(__('Image deleted', true), array('action' => 'index'));
    }
    $this->flash(__('Image was not deleted', true), array('action' => 'index'));
    $this->redirect(array('action' => 'index'));
  }

}

?>