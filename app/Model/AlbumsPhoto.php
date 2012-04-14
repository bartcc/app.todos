<?php
App::uses('AppModel', 'Model');

class AlbumsPhoto extends AppModel {

  public $name = 'AlbumsPhoto';
  public $useDbConfig = 'director_spine';
  
  public $belongsTo = array(
      'Album', 'Photo'
  );
}

?>