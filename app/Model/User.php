<?php

App::uses('AppModel', 'Model');

/**
 * User Model
 *
 * @property Group $Group
 */
class User extends AppModel {

  /**
   * Display field
   *
   * @var string
   */
  public $displayField = 'name';
  public $useDbConfig = 'director_spine';
  //The Associations below have been created with all possible keys, those that are not needed can be removed

  public $validate = array(
      'username' => array(
          'rule' => 'isUnique',
          'message' => 'This username has already been taken.'
      )
  );

  /**
   * belongsTo associations
   *
   * @var array
   */
  public $belongsTo = array(
      'Group' => array(
          'className' => 'Group',
          'foreignKey' => 'group_id',
          'conditions' => '',
          'fields' => '',
          'order' => ''
      )
  );

}
