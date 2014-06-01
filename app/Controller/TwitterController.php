<?php

App::import('Vendor', 'OAuth/OAuthClient');

class TwitterController extends AppController {
  
    public function index() {
        $this->log('Twitter::index', LOG_DEBUG);
        $client = $this->createClient();
        $requestToken = $client->getRequestToken('https://api.twitter.com/oauth/request_token', 'http://' . $_SERVER['HTTP_HOST'] . '/twitter/callback');
        $this->log($requestToken, LOG_DEBUG);
        if ($requestToken) {
            $this->Session->write('twitter_request_token', $requestToken);
            $this->redirect('https://api.twitter.com/oauth/authorize?oauth_token=' . $requestToken->key);
            $this->log($this->Session, LOG_DEBUG);
        } else {
            // an error occured when obtaining a request token
        }
    }

    public function callback() {
        $requestToken = $this->Session->read('twitter_request_token');
        $client = $this->createClient();
        $accessToken = $client->getAccessToken('https://api.twitter.com/oauth/access_token', $requestToken);
        $this->log($requestToken, LOG_DEBUG);
        $this->log($accessToken, LOG_DEBUG);

        if ($accessToken) {
            $client->post($accessToken->key, $accessToken->secret, 'https://api.twitter.com/1/statuses/update.json', array('status' => 'hello world!'));
        }
    }

    private function createClient() {
        return new OAuthClient('NgMFbSk4QZhqVKv9IVAp9G23y', 'n0AnbXyMPSZKQBPRihhZP2MHjHAWJHIrDhWZTdPiC3oXaS9QBE');
    }
}
?>
