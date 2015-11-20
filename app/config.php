<?php
    
    // true  --> Emails gehen zu Testadressen
	// false --> emails sind scharf
    $useDevEmailAddress = false;
    
    // E-Mails gehen bei Testzwecken zu diesen Adressen
    $devEmailAddress = array();
    
    // Email Kunde
    $storeEmail = array();
    
	/* ------------------------------------------------------------------------------------------------------ */
	/*  */
    /* ------------------------------------------------------------------------------------------------------ */
	$develop = $_SERVER['SERVER_ADDR'] == '192.168.8.128' || $_SERVER['SERVER_NAME'] == 'draft';
    
    // Datenbank
    if ($develop) {
        // Dev
        $dbConfig = array(
                          'driver'   => 'pdo_mysql',
                          'charset'  => 'UTF8',
                          'dbhost'   => 'localhost',
                          'dbname'   => '',
                          'user'     => '',
                          'password' => '',
                          );
    } else {
        // Live
        $dbConfig = array(
                          'driver'   => 'pdo_mysql',
                          'charset'  => 'UTF8',
                          'dbhost'   => 'localhost',
                          'dbname'   => '',
                          'user'     => '',
                          'password' => '',
                          );
    }
    /* ------------------------------------------------------------------------------------------------------ */
	
	$config = array(
		'dbConfig' => $dbConfig
	);
