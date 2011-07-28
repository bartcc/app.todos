<?php
class ImagesController extends AppController {

	var $name = 'Images';
	var $helpers = array('Ajax', 'Js');
	var $components = array('RequestHandler');
    
    function index() {
		$this->Image->recursive = 0;
        $json = $this->Image->find('all', array('fields' => array('id', 'name', 'exposure', 'description', 'tags')));
		$this->set('json', $json);
        $this->render(SIMPLE_JSON, 'ajax');
	}
    
	function view($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid contact', true));
			$this->redirect(array('action' => 'index'));
		}
		$this->set('json', $this->Image->read(null, $id));
        $this->render(SIMPLE_JSON, 'ajax');
	}

	function add() {
        $payload = $this->getPayLoad();
        // validate the record to make sure we have all the data
        if(!isset($payload->id)) {
            // we got bad data so set up an error response and exit
            header('HTTP/1.1 400 Bad Request');
            header('X-Reason: Received an array of records when ' .
                   'expecting just one');
            exit;
        }
        
        $id = $this->cleanValue($payload->id);
        $name = $this->cleanValue($payload->name);
        $description = $this->cleanValue($payload->description);
        $exposure = $this->cleanValue($payload->exposure);
        $tags = $this->cleanValue($payload->tags);
        $this->data = array(
            'id' => $id,
            'name' => $name,
            'exposure' => $exposure,
            'description' => $description,
            'tags' => $tags,
        );
        $this->Image->create();
        $this->Image->save($this->data);
        $this->set('json', $this->data);
        $this->render(SIMPLE_JSON, 'ajax');
//        header('HTTP/1.1 204 No Content');
//        header("Location: http://".$_SERVER['HTTP_HOST'].'/todos/'.$id);
	}

	function edit($id = null) {
        
        if(empty ($id)) {
            return;
        }

        $payload = $this->getPayLoad();
		$id = $this->cleanValue($payload->id);
        $name = $this->cleanValue($payload->name);
        $description = $this->cleanValue($payload->description);
        $exposure = $this->cleanValue($payload->exposure);
        $tags = $this->cleanValue($payload->tags);
        $this->data = array(
            'id' => $id,
            'name' => $name,
            'exposure' => $exposure,
            'description' => $description,
            'tags' => $tags,
        );
        if ($this->Image->save($this->data)){
            $this->set('json', $this->data);
            $this->render(SIMPLE_JSON, 'ajax');
		}
        
	}

	function delete($id = null) {
		
        if(!$id){
            exit;
        }
        $this->Image->delete($id);
        
	}
    
    private function getPayLoad() {
        $payload = FALSE;
        if (isset($_SERVER['CONTENT_LENGTH']) && $_SERVER['CONTENT_LENGTH'] > 0) {
            $payload = '';
            $httpContent = fopen('php://input', 'r');
            while ($data = fread($httpContent, 1024)) {
                $payload .= $data;
            }
            fclose($httpContent);
        }

        // check to make sure there was payload and we read it in
        if(!$payload)
            return FALSE;

        // translate the JSON into an associative array
        $obj = json_decode($payload);
        return $obj;
    }
    
    // Escape special meaning character for MySQL
    // Must be used AFTER a session was opened
    private function cleanValue($value) {
        if(get_magic_quotes_gpc()) {
            $value = stripslashes($value);
        }

        if(!is_numeric($value)) {
            $value = mysql_real_escape_string($value);
        }
        return $value;
    }
    
    private function flatten_array($arr) {

        $out = array();
        debug($arr);
        foreach ($arr as $key => $val) {
            $val['Contact']['done'] = $val['Contact']['done'] == 1;
            array_push($out, $val['Contact']);
        }
        return $out;
    }
}
?>