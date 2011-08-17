<?php

class Contact extends AppModel {

  var $name = 'Contact';
  var $useDbConfig = 'contacts_spine';
  var $displayField = 'first_name';

  function afterFind($results) {
    
    foreach ($results as $key => $val) {
      $results[$key] = $val[$this->alias];
    }
    return $results;
  }
}

?>