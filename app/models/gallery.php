<?php

class Gallery extends AppModel {

  var $name = 'Gallery';
  var $useDbConfig = 'director_spine';
  var $displayField = 'name';
  var $validate = array(
      'name' => array(
          'notempty' => array(
              'rule' => array('notempty'),
          //'message' => 'Your custom message here',
          //'allowEmpty' => false,
          //'required' => false,
          //'last' => false, // Stop validation after this rule
          //'on' => 'create', // Limit validation to 'create' or 'update' operations
          ),
      ),
  );
  //The Associations below have been created with all possible keys, those that are not needed can be removed

  var $hasAndBelongsToMany = array(
      'Album' => array(
          'className' => 'Album',
          'joinTable' => 'galleries_albums',
          'foreignKey' => 'gallery_id',
          'associationForeignKey' => 'album_id',
          'unique' => true,
          'conditions' => '',
          'fields' => '',
          'order' => '',
          'limit' => '',
          'offset' => '',
          'finderQuery' => '',
          'deleteQuery' => '',
          'insertQuery' => ''
      )
  );

  function afterFind($results) {
    
    foreach ($results as $key => $val) {
      //$results[$key] = $val[$this->alias];
    }
    return $results;
  }

}

?>