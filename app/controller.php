<?php
    
    // Mount login redirect
    //$app->mount('/login/redirect', new Controller\LoginRedirect());
    
    // Mount cart
    /*$cartController = new Controller\CartController();
    $app->mount('/cart', $cartController);*/
    
    /* ------------------------------------------------------------------------------------------------------ */
    
    // Index
    $app->get('/', function () use ($app) {
              
            return $app['twig']->render('Default/index.twig', array());
        }
    )
    ->bind('index');
