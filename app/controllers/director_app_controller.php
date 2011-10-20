<?php

class DirectorAppController extends AppController {

  var $name = 'DirectorApp';
  var $uses = array('Gallery', 'Album', 'Image');

  function beforeFilter() {
    $this->autoRender = true;
    $this->layout = 'director_layout';
    //$this->Auth->allowedActions = array('index');
  }

  function index() {
    $this->Gallery->recursive = 1;
    $this->Album->recursive = 1;
    $this->Image->recursive = 1;
//    $galleries = $this->Gallery->find('all', array('fields' => array('id', 'name', 'author', 'description')));
//    $albums = $this->Album->find('all', array('fields' => array('id', 'name', 'title', 'description')));
//    $images = $this->Image->find('all', array('fields' => array('id', 'title', 'exif', 'description')));
    
    $galleries = $this->Gallery->findAllByUser_id((string) $this->Auth->user('id'));
    $albums = $this->Album->findAllByUser_id((string)($this->Auth->user('id')));
    $images = $this->Image->findAllByUser_id((string)($this->Auth->user('id')));
    $this->set(compact('galleries', 'albums', 'images'));
//    $this->log('galleries', LOG_DEBUG);
//    $this->log($galleries, LOG_DEBUG);
//    $this->log('albums', LOG_DEBUG);
//    $this->log($albums, LOG_DEBUG);
//    $this->log($images, LOG_DEBUG);
  }
}

?>