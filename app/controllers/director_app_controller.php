<?php

class DirectorAppController extends AppController {

  var $name = 'DirectorApp';
  var $uses = array('Gallery', 'Album', 'Image');

  function beforeFilter() {
    Configure::write('debug', 0);
    $this->autoRender = true;
    $this->layout = 'director_layout';
    $this->Auth->allowedActions = array('index');
  }

  function index() {
    $this->Gallery->recursive = 1;
    $this->Album->recursive = 1;
    $this->Image->recursive = 0;
    $galleries = $this->Gallery->find('all', array('fields' => array('id', 'name', 'author', 'description')));
    $albums = $this->Album->find('all', array('fields' => array('id', 'name', 'title', 'description')));
    $images = $this->Image->find('all', array('fields' => array('id', 'title', 'exif', 'description')));
    $this->set(compact('galleries', 'albums', 'images'));
  }
}

?>