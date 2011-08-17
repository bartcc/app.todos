<?php

class Task extends AppModel {

  var $name = 'Task';
  var $useDbConfig = 'todos_spine';

  function afterFind($results) {
    
    foreach ($results as $key => $val) {
      if (isset($val[$this->alias]['done'])) {
        $val[$this->alias]['done'] = (BOOLEAN) $val[$this->alias]['done'];
      }
      $results[$key] = $val[$this->alias];
    }

    return $results;
  }
}

?>