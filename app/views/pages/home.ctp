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
            <div class="logo">
                <img src="https://webpremiere.de/files/public-docs/logos/webpremiere-logo-1.svg">
            </div>
            <p>
                Pick an App
            </p>
            <hr>
            <div class="download-info button-wrapper flex flex-wrap">
                    <div>
                        <a href="/todos_app" class="btn btn-primary btn-large" type="" target="_top">Backbone's Todos</a>
                        <i class="info">Todos App (Backbone.js)</i>
                    </div>
                    <div>
                        <a href="/tasks_app" class="btn btn-info btn-large" type="" target="_top">Spine's Todos</a>
                        <i class="info">Todos App (Spine.js)</i>
                    </div>
                    <div>
                        <a href="/contacts_app" class="btn btn-success btn-large" type="" target="_top"><span itemprop="name">Contacts App</span></a>
                        <i class="info">Contacts App (Spine.js)</i>
                    </div>
                    <div>
                        <a href="http://ssv.<?php echo HOST; ?>.<?php echo TOPLEVEL; ?>" class="btn btn-danger btn-large" type="" target="_top"><span itemprop="name">Sportverein</span></a>
                        <i class="info">Webpräsenz Sportverein</i>
                    </div>
                    <div>
                        <a href="http://serials.<?php echo HOST; ?>.<?php echo TOPLEVEL; ?>" class="btn btn-warning btn-large" type="" target="_top"><span itemprop="name">Datastore</span></a>
                        <i class="info">Store Data</i>
                    </div>
                    <div>
                        <a href="" class="" type="" target="_top"><span itemprop="name"></span></a>
                        <i class="info"></i>
                    </div>
                    <div>
                        <a href="http://gap.<?php echo HOST; ?>.<?php echo TOPLEVEL; ?>" class="btn btn-large" type="">More...</a>
                    </div>
            </div>
        </div>
    </header>
</div>
<footer class="footer">
    <div class="footer__bg_copyright"><a href="https://www.flickr.com/photos/95403249@N06/35456881653" target="_blank"><span class="title h3">Vestrahorn Islande</span><span class="author h2">von RUFF Etienne</span></a></div>
    <div class="footer__content">
        <?php echo 'powered'; ?> <a href="/" target="_self"><img class="logo" src="https://webpremiere.de/files/public-docs/logos/webpremiere-logo-1.svg" alt="webPremiere"></a>
    </div>
</footer>