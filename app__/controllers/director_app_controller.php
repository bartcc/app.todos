<?php

class DirectorAppController extends AppController {

  var $name = 'DirectorApp';
  var $uses = array('Gallery', 'Album', 'Photo');

  function beforeFilter() {
    $this->autoRender = true;
    $this->layout = 'director_layout';
  }

  function index() {
    
    $this->Gallery->recursive = 1;
    $this->Album->recursive = 1;
    $this->Photo->recursive = 1;
    
    $galleries = $this->Gallery->findAllByUser_id((string) $this->Auth->user('id'));
    $albums = $this->Album->findAllByUser_id((string)($this->Auth->user('id')));
    $photos = $this->Photo->findAllByUser_id((string)($this->Auth->user('id')));
    $this->set(compact('galleries', 'albums', 'photos'));
  }
}

?>