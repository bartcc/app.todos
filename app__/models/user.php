<?php
class User extends AppModel {
  
	var $name = 'User';
	var $useDbConfig = 'director_spine';
 var $validate = array(
  'username' => array(
      'rule' => 'isUnique',
      'message' => 'This username has already been taken.'
  )
 );

 
	var $belongsTo = array(
		'Group' => array(
			'className' => 'Group',
			'foreignKey' => 'group_id',
			'conditions' => '',
			'fields' => '',
			'order' => ''
		)
	);
}
?>