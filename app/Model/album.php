<?php

App::uses('AppModel', 'Model');

class Album extends AppModel {

  public $name = 'Album';
  public $useDbConfig = 'cakephp_spine';
  public $displayField = 'title';
  
  public $hasMany = array(
      'AlbumsPhoto', 'GalleriesAlbum'
  );
}

?>