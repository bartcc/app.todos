<?php
class TestsController extends AppController {

	var $name = 'Tests';
	var $helpers = array('Ajax', 'Js');

	function index() {
		$this->Test->recursive = 0;
		//$this->set('tests', $this->paginate());
        $this->set('value', $this->Test->find('list', array('fields' => array('Test.id', 'Test.name'))));
        $this->render(SIMPLE_JSON, 'ajax');
	}

	function view($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid test', true));
			$this->redirect(array('action' => 'index'));
		}
		$this->set('test', $this->Test->read(null, $id));
	}

	function add() {
		if (!empty($this->data)) {
			$this->Test->create();
			if ($this->Test->save($this->data)) {
				$this->Session->setFlash(__('The test has been saved', true));
				$this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The test could not be saved. Please, try again.', true));
			}
		}
	}

	function edit($id = null) {
		if (!$id && empty($this->data)) {
			$this->Session->setFlash(__('Invalid test', true));
			$this->redirect(array('action' => 'index'));
		}
		if (!empty($this->data)) {
			if ($this->Test->save($this->data)) {
				$this->Session->setFlash(__('The test has been saved', true));
				$this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The test could not be saved. Please, try again.', true));
			}
		}
		if (empty($this->data)) {
			$this->data = $this->Test->read(null, $id);
		}
	}

	function delete($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid id for test', true));
			$this->redirect(array('action'=>'index'));
		}
		if ($this->Test->delete($id)) {
			$this->Session->setFlash(__('Test deleted', true));
			$this->redirect(array('action'=>'index'));
		}
		$this->Session->setFlash(__('Test was not deleted', true));
		$this->redirect(array('action' => 'index'));
	}
}
?>