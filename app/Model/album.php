<?php

App::uses('AppModel', 'Model');

class Album extends AppModel {

  public $name = 'Album';
  public $displayField = 'title';
  
  public $hasMany = array(
      'AlbumsPhoto', 'GalleriesAlbum'
  );
}

?>