<?php

App::uses('AppModel', 'Model');

class Gallery extends AppModel {

  public $name = 'Gallery';
  public $displayField = 'name';
  
  public $hasMany = array(
      'GalleriesAlbum'
  );
}

?>