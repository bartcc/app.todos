<?php

App::uses('AppController', 'Controller');

class PhotosController extends AppController {

  public $name = 'Photos';

  public function beforeFilter() {
    $this->Auth->allowedActions = array('uri');
    parent::beforeFilter();
  }

  public function index() {
    $this->Photo->recursive = 0;
    $this->set('photos', $this->paginate());
  }

  public function view($id = null) {
    if (!$id) {
      $this->flash(__('Invalid photo', true), array('action' => 'index'));
    }
    $this->set('photo', $this->Photo->read(null, $id));
  }

  public function add() {
    if (!empty($this->data)) {
      $this->Photo->create();
      $this->request->data['Photo']['id'] = null;
      if ($this->Auth->user()) {
        $merged = array_merge($this->request->data['Photo'], array('user_id' => $this->Auth->user('id')));
        $this->request->data = $merged;
        if ($this->Photo->save($this->request->data)) {
          $this->flash(__('Image saved.', true), array('action' => 'index'));
          $this->set('_serialize', array('id' => $this->Photo->id));
          $this->render(SIMPLE_JSON);
        } else {
          
        }
      }
    }
    $albums = $this->Photo->Album->find('list');
    $tags = $this->Photo->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  public function edit($id = null) {
    if (!$id && empty($this->request->data)) {
      $this->flash(sprintf(__('Invalid photo', true)), array('action' => 'index'));
    }
    if (!empty($this->request->data)) {

      if ($this->Photo->save($this->request->data)) {
        $this->Session->setFlash(__('The photo has been saved', true));
      } else {
        $this->Session->setFlash(__('The album could not be saved. Please, try again.', true));
      }
    }
    if (empty($this->request->data)) {
      $this->request->data = $this->Photo->read(null, $id);
    }
    $albums = $this->Photo->Album->find('list');
    $tags = $this->Photo->Tag->find('list');
    $this->set(compact('albums', 'tags'));
  }

  public function delete($id = null) {
    if (!$id) {
      $this->flash(sprintf(__('Invalid image', true)), array('action' => 'index'));
    }
    if ($this->Photo->delete($id)) {
      // remove image from filesystem
      $this->remove($id);
      $this->flash(__('Image deleted', true), array('action' => 'index'));
    } else {
      $this->flash(__('Image was not deleted', true), array('action' => 'index'));
      $this->redirect(array('action' => 'index'));
    }
  }

  public function remove($id) {
    $this->autoRender = false;

    if($this->Auth->user('id')) {

      $user_id = $this->Auth->user('id');
      
      App::import('Component', 'File');
      $file = new FileComponent();

      $path = PHOTOS . DS . $user_id . DS . $id;
      $lg_path = $path . DS . 'lg';
      $cache_path = $path . DS . 'cache';
      
      $oldies = glob($lg_path . DS . '*');
      foreach ($oldies as $o) {
        unlink($o);
      }
      $oldies = glob($cache_path . DS . '*');
      foreach ($oldies as $o) {
        unlink($o);
      }
      rmdir($lg_path);
      rmdir($cache_path);
      rmdir($path);
    }
  }

  
  public function recent($max = 10) {
    $this->autoRender = false;
    $this->Photo->recursive = -1;
    $recent = $this->Photo->find('all', array(
        'Photo.created >' => date('Y-m-d', strtotime('-20 weeks')),
        'order' => array('Photo.created DESC'),
        'limit' => $max
      )
    );
//    $this->log($recent, LOG_DEBUG);
    $json = $this->set('_serialize', $recent);
    $this->render(SIMPLE_JSON);
  }

  public function uri($width = 150, $height = 150, $square = 2) {
    if ($this->Auth->user('id')) {

      $user_id = $uid = $this->Auth->user('id');

      if (!empty($this->data)) {
        $json = array();
        foreach ($this->data as $data) {
          $id = $data['id'];
          $path = PHOTOS . DS . $uid . DS . $id . DS . 'lg' . DS . '*.*';
          $files = glob($path);
          if (!empty($files[0])) {
            $fn = basename($files[0]);
            $options = compact(array('uid', 'id', 'fn', 'width', 'height', 'square'));
            if($square == 4)
              $src = p($options);
            else
              $src = __p($options);

            $return = array($id => array('src' => $src));
            $json[] = $return;
          }
        }
        $this->set('_serialize', $json);
        $this->render(SIMPLE_JSON);
      }
    } else {
      $json = array('flash' => '<strong style="color:red">No valid user</strong>');
      $this->set('_serialize', $json);
      $this->response->header("WWW-Authenticate: Negotiate");
      $this->render(SIMPLE_JSON);
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