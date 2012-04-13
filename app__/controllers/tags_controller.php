<?php

class TagsController extends AppController {

  var $name = 'Tags';

  function beforeFilter() {
    $this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }

  function index() {
    $this->Tag->recursive = 0;
    $this->set('tags', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->flash(__('Invalid tag', true), array('action' => 'index'));
    }
    $this->set('tag', $this->Tag->read(null, $id));
  }

  function add() {
    if (!empty($this->data)) {
      $this->Tag->create();
      $this->data['Tag']['id'] = null;
      if ($this->Tag->save($this->data)) {
        $this->flash(__('Tag saved.', true), array('action' => 'index'));
        $this->set('json', array('id' => $this->Tag->id));
        $this->render(SIMPLE_JSON);
      } else {
        
      }
    }
    $photos = $this->Tag->Photo->find('list');
    $this->set(compact('photos'));
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->flash(sprintf(__('Invalid tag', true)), array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->Tag->save($this->data)) {
        $this->flash(__('The tag has been saved.', true), array('action' => 'index'));
      } else {
        
      }
    }
    if (empty($this->data)) {
      $this->data = $this->Tag->read(null, $id);
    }
    $photos = $this->Tag->Photo->find('list');
    $this->set(compact('photos'));
  }

  function delete($id = null) {
    if (!$id) {
      $this->flash(sprintf(__('Invalid tag', true)), array('action' => 'index'));
    }
    if ($this->Tag->delete($id)) {
      $this->flash(__('Tag deleted', true), array('action' => 'index'));
    }
    $this->flash(__('Tag was not deleted', true), array('action' => 'index'));
    $this->redirect(array('action' => 'index'));
  }

}

?>