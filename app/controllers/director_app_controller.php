<?php

class DirectorAppController extends AppController {

  var $name = 'DirectorApp';
  var $uses = array();

  function beforeFilter() {
    $this->autoRender = true;
    $this->layout = 'director_layout';
    $this->Auth->allowedActions = array('index');
  }

  function index() {}

}

?>