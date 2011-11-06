<?php

class PhotosController extends AppController {

  var $name = 'Photos';

  function beforeFilter() {
    //$this->Auth->allowedActions = array('index', 'view', 'add', 'edit', 'delete');
    parent::beforeFilter();
  }

  function index() {
    $this->Photo->recursive = 0;
    $this->set('photos', $this->paginate());
  }

  function view($id = null) {
    if (!$id) {
      $this->flash(__('Invalid photo', true), array('action' => 'index'));
    }
    $this->set('photo', $this->Photo->read(null, $id));
  }

  function add() {
    if (!empty($this->data)) {
      $this->Photo->create();
      if ($this->Auth->user()) {
        $merged = array_merge($this->data['Photo'], array('user_id' => $this->Auth->user('id')));
        $this->data = $merged;
        if ($this->Photo->save($this->data)) {
          $this->flash(__('Image saved.', true), array('action' => 'index'));
        } else {
          
        }
      }
    }
    $albums = $this->Photo->Album->find('list');
    $tags = $this->Photo->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  function edit($id = null) {
    if (!$id && empty($this->data)) {
      $this->flash(sprintf(__('Invalid photo', true)), array('action' => 'index'));
    }
    if (!empty($this->data)) {
      if ($this->Auth->user()) {
        $merged = array_merge($this->data['Photo'], array('user_id' => $this->Auth->user('id')));
        $this->data = $merged;
      }
      if ($this->Photo->save($this->data)) {
        $this->flash(__('The image has been saved.', true), array('action' => 'index'));
      } else {
        
      }
    }
    if (empty($this->data)) {
      $this->data = $this->Photo->read(null, $id);
    }
    $albums = $this->Photo->Album->find('list');
    $tags = $this->Photo->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  function delete($id = null) {
    if (!$id) {
      $this->flash(sprintf(__('Invalid image', true)), array('action' => 'index'));
    }
    if ($this->Photo->delete($id)) {
      $this->flash(__('Image deleted', true), array('action' => 'index'));
    }
    $this->flash(__('Image was not deleted', true), array('action' => 'index'));
    $this->redirect(array('action' => 'index'));
  }

  function reset_avatar($id) {
    $this->autoRender = false;

    App::import('Component', 'File');
    $file = new FileComponent();

    $oldies = glob(PHOTOS . DS . $id . DS . 'original.*');
    foreach ($oldies as $o) {
      unlink($o);
    }
    $oldies = glob(PHOTOS . DS . $id . DS . 'cache' . DS . '*');
    foreach ($oldies as $o) {
      unlink($o);
    }
    if ($this->Product->read(null, $id)) {
      $this->Product->saveField('image', null);
    }
  }

  function uri($width = 150, $height = 150, $square = 2) {
    $this->log('PhotosController::uri', LOG_DEBUG);
//    $this->log($this->data, LOG_DEBUG);
    if($this->Auth->user() && !empty($this->data)) {
      $user_id = $uid = $this->Auth->user('id');
      
      $array = array();
      foreach($this->data['Photo'] as $data) {
//        $this->log($data['id'], LOG_DEBUG);
        $id = $data['id'];
        $path = PHOTOS . DS . $uid . DS . $id . DS . 'lg' . DS . '*.*';
        //$options = array('width' => $width, 'height' => $height, 'square' => $square);
        $files = glob($path);
//        $this->log($files, LOG_DEBUG);
        if (!empty($files[0])) {
          //$this->log($files[0], LOG_DEBUG);
          $fn = basename($files[0]);
          //extract($this->_previewOptions(300, 300));
          $options = compact(array('uid', 'id', 'fn', 'width', 'height', 'square'));
          $src = __p($options);
          $array[] = $src;
        }
      }
      $json = $array;
      $this->set(compact('json'));
      $this->render(SIMPLE_JSON, 'ajax');
    } else {
      exit(' ');
    }
    
  }

  private function _previewOptions($w = 300, $h = 300) {
    return array('width' => $w, 'height' => $h, 'square' => 3);
  }

  private function _use_preview($id, $use = false) {
    App::import('Component', 'File');
    $file = new FileComponent();

    define('TEMP_PATH', PHOTOS . DS . 'tmp');
    define('DEST_PATH', PHOTOS . DS . $id);
    $temp_files = glob(TEMP_PATH . DS . '*');
    if (count($temp_files) < 1)
      return;

    $fn = basename($temp_files[0]);
    $path_to_temp = TEMP_PATH . DS . $fn;
    $ext = $file->returnExt($fn);
    if ($use) {
      if (!is_dir(PHOTOS)) {
        $file->makeDir(PHOTOS);
      }
      if (!is_dir(DEST_PATH)) {
        $file->makeDir(DEST_PATH);
      } else {
        $oldies = glob(DEST_PATH . DS . 'original.*');
        foreach ($oldies as $o) {
          unlink($o);
        }
        $oldies = glob(DEST_PATH . DS . 'cache' . DS . '*');
        foreach ($oldies as $o) {
          unlink($o);
        }
      }

      $source = TEMP_PATH . DS . $fn;
      $dest = DEST_PATH . DS . $fn;
      copy($source, $dest);

      $this->Product->id = $id;
      $this->Product->saveField('image', $fn);
    }

    foreach ($temp_files as $o) {
      unlink($o);
    }
  }

}

?>