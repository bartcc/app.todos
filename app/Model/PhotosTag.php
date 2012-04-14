<?php

App::uses('AppModel', 'Model');

class PhotosTag extends AppModel {

  public $name = 'PhotosTag';
  public $useDbConfig = 'director_spine';
  public $belongsTo = array(
      'Photo', 'Tag'
  );

}

?>