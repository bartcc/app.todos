<?php

class ContactsAppController extends AppController {

  var $name = 'ContactsApp';
  var $uses = array();

  function beforeFilter() {
    $this->autoRender = true;
    $this->layout = 'contacts_layout';
  }

  function index() {}

}

?>