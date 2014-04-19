<?php
App::uses('AppModel', 'Model');

class Album extends AppModel {

  public $name = 'Album';
  public $displayField = 'title';
  public $useDbConfig = 'director_spine';
  
  public $hasMany = array(
    'AlbumsPhoto' => array('dependent' => true),
    'GalleriesAlbum' => array('dependent' => true)
  );
}

?>