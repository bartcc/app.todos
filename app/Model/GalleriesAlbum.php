<?php

App::uses('AppModel', 'Model');

class GalleriesAlbum extends AppModel {

  public $name = 'GalleriesAlbum';
  public $useDbConfig = 'director_spine';
  
  public $belongsTo = array(
      'Gallery', 'Album'
  );

}

?>