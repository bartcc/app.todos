<?php

class Photo extends AppModel {

  var $name = 'Photo';
  var $useDbConfig = 'director_spine';
  var $displayField = 'title';
  
  var $hasMany = array(
      'AlbumsPhoto'
  );

}

?>