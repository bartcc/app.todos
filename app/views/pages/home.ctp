<?php
/**
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2012, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       Cake.View.Pages
 * @since         CakePHP(tm) v 0.10.0.1076
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
if (Configure::read('debug') == 0):
	//throw new NotFoundException();
endif;
//App::uses('Debugger', 'Utility');
?>
<div class="container">
  <header class="jumbotron masthead">
    <div class="inner">
      <h1>Sweet...</h1>
      <p>
        Choose your App
      </p>
      <p class="download-info">
        <a href="/todos_app" class="btn btn-primary btn-large" type="submit">Backbone's Todos</a>
        <?php echo MYSQLUPLOAD; ?>
        <a href="/tasks_app" class="btn btn-info btn-large" type="submit">Spine's Todos</a>
        <a href="http://gap.webpremiere.<?php echo TOPLEVEL; ?>" class="btn btn-large" type="submit">More...</a>
      </p>
    </div>
  </header>
</div>