<?php
App::uses('AppModel', 'Model');

class Photo extends AppModel {

  public $name = 'Photo';
  public $displayField = 'title';
  public $useDbConfig = 'director_spine';
  
  public $hasMany = array(
      'AlbumsPhoto' => array('dependent' => true),
      'PhotosTag' => array('dependent' => true)
  );
}

?>