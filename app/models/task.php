<?php

class Task extends AppModel {

  var $name = 'Task';
  var $useDbConfig = 'todos_spine';

  function afterFind($results) {
    
    foreach ($results as $key => $val) {
      $results[$key] = $val[$this->alias];
    }
    return $results;
  }
}

?>