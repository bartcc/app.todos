<?php

class Todo extends AppModel {

  var $name = 'Todo';
  var $useDbConfig = 'todos_backbone';

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