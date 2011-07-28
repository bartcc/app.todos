<?php
class TodosAppSpineController extends AppController {

	var $name = 'TodosAppSpine';
    var $uses = array();
    
    function beforeFilter() {
        $this->autoRender = true;
        $this->layout = 'todos_app_spine_layout';
    }
    
    function index() {}

}
?>