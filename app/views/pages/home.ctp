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
        Pick your App
      </p>
			<table class="download-info button-wrap">
						<tr style="text-align: center">
								<td>
										<a href="/todos_app" class="btn btn-primary btn-large" type="submit" target="_blank">Backbone's Todos</a>
										<i class="info">Todos App (Backbone.js)</i>
								</td>
								<td>
										<a href="/tasks_app" class="btn btn-info btn-large" type="submit" target="_blank">Spine's Todos</a>
										<i class="info">Todos App (Spine.js)</i>
								</td>
								
						</tr>
						<tr style="text-align: center">
								<td>
										<a href="http://data.<?php echo HOST; ?>.<?php echo TOPLEVEL; ?>" class="btn btn-warning btn-large" type="submit" target="_blank"><span itemprop="name">Datastore</span></a>
										<i class="info">Store Data</i>
								</td>
								<td>

								</td>
						</tr>
						<tr style="text-align: center">
								<td>
										
								</td>
								<td>
										<a href="http://gap.<?php echo HOST; ?>.<?php echo TOPLEVEL; ?>" class="btn btn-large" type="submit">More...</a>
								</td>
						</tr>
				</table>
    </div>
  </header>
</div>