<?php

class Director extends AppModel {

  var $name = 'Director';
  var $useDbConfig = 'director_spine';
  var $displayField = 'first_name';

  function afterFind($results) {
    
    foreach ($results as $key => $val) {
      $results[$key] = $val[$this->alias];
    }
    return $results;
  }
}

?>