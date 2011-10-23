<?php

class DirectorAppController extends AppController {

  var $name = 'DirectorApp';
  var $uses = array('Gallery', 'Album', 'Image');

  function beforeFilter() {
    $this->autoRender = true;
    $this->layout = 'director_layout';
    Cache::clear();
    //$this->Auth->allowedActions = array('index');
  }

  function index() {
    header("Pragma: no-cache");
    header("Cache-Control: no-store, no-cache, max-age=0, must-revalidate");
    header("Expires: Sat, 26 Jul 1997 05:00:00 GMT"); 
    
    $this->Gallery->recursive = 1;
    $this->Album->recursive = 1;
    $this->Image->recursive = 1;
    
    $galleries = $this->Gallery->findAllByUser_id((string) $this->Auth->user('id'));
    $albums = $this->Album->findAllByUser_id((string)($this->Auth->user('id')));
    $images = $this->Image->findAllByUser_id((string)($this->Auth->user('id')));
    $this->set(compact('galleries', 'albums', 'images'));
  }
}

?>