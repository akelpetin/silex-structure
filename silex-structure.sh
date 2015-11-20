#!/usr/bin/env sh
# Create composer.json
cat > composer.json <<EOF
{
    "require": {
        "silex/silex": "~1.3"
    },
    "autoload": {
        "psr-0": { "": "src/" }
    }
}
EOF
# Get composer.phar if not installed
#curl -sS https://getcomposer.org/installer | php
# Set dependencies
#php composer.phar require symfony/config --no-update
#php composer.phar require symfony/twig-bridge --no-update
#php composer.phar require symfony/form --no-update
#php composer.phar require symfony/security-csrf --no-update
#php composer.phar require symfony/translation --no-update
#php composer.phar require symfony/validator --no-update
#php composer.phar require swiftmailer/swiftmailer --no-update
#php composer.phar require twig/twig --no-update
#php composer.phar install
# Create .gitignore
cat > .gitignore <<EOF
.idea/
*.DS_Store
*_notes
composer.phar
vendor/
phploy.phar
deploy.ini
EOF
# Create app directory and files
mkdir app
cat > app/app.php <<EOF
<?php

\$app = new Silex\Application();

// DEBUG
\$app['debug'] = \$develop;

// Doctrine service
/*\$app->register(
    new Silex\Provider\DoctrineServiceProvider(),
    array(
        'db.options' => \$dbConfig,
    )
);*/

// Twig service
\$app->register(
    new Silex\Provider\TwigServiceProvider(),
    array(
        'twig.path' => __DIR__.'/../views'
    )
);

// Translator service
\$app->register(
    new Silex\Provider\TranslationServiceProvider(),
    array(
        'locale_fallback' => 'de',
    )
);

// Validator service
//\$app->register(new Silex\Provider\ValidatorServiceProvider());

// Url generator service
\$app->register(new Silex\Provider\UrlGeneratorServiceProvider());

// Form service
\$app->register(new Silex\Provider\FormServiceProvider());

// Security
/*\$app->register(
    new Silex\Provider\SecurityServiceProvider(),
    array(
        'security.firewalls'      => array(
            'main' => array(
                'pattern'     => '^/',
                'anonymous'   => true,
                'form'        => array(
                    'login_path'                => '/login',
                    'check_path'                => '/user/login_check',
                    'always_use_default_target' => true,
                    'default_target_path'       => '/login/redirect',
                    'use_referer'               => false
                ),
                'logout'      => array('logout_path' => '/user/logout', 'target_url' => '/'),
                'users'       => \$app->share(
                    function () use (\$app) {
                        return new User\UserProvider(\$app['db']);
                    }
                ),
                'switch_user' => array('parameter' => '_switch_user', 'role' => 'ROLE_ALLOWED_TO_SWITCH'),
            ),
        ),
        'security.role_hierarchy' => array('ROLE_ADMIN' => array('ROLE_USER', 'ROLE_ALLOWED_TO_SWITCH')),
        'security.access_rules'   => array(
            array('^/admin', 'ROLE_ADMIN'), // , 'https'
            array('^/user', 'ROLE_USER'),
            array('^/', 'IS_AUTHENTICATED_ANONYMOUSLY'),
        )
    )
);*/

// Session service
//\$app->register(new Silex\Provider\SessionServiceProvider());

if (\$develop) {
    \$transport = \Swift_SmtpTransport::newInstance('smtp.url', 587)
        ->setUsername(base64_decode('username'))
        ->setPassword(base64_decode('password'))
    ;
} else {
    \$transport = \Swift_MailTransport::newInstance();
}

// Swiftmailer
\$app->register(new Silex\Provider\SwiftmailerServiceProvider(), array(
    'swiftmailer.use_spool' => false,
    'swiftmailer.transport' => \$transport
));

// Set app values
\$app['config'] = \$config;

// Set twig default values
\$app['twig'] = \$app->share(\$app->extend('twig', function(\Twig_Environment \$twig, \Silex\Application \$app) {
    \$twig->addGlobal('config', \$app['config']);	
	\$twig->addFilter(new Twig_SimpleFilter('fileinclude', function(\$string) {
			
			if (\$_SERVER['HTTP_HOST'] == 'kw1ua121') {
				\$scriptPath = str_replace('index.php', '', \$_SERVER['SCRIPT_NAME']);
				
				return 'http://' . \$_SERVER['HTTP_HOST'] . \$scriptPath . \$string;
			} elseif (strpos(\$_SERVER['REQUEST_URI'], '/web/') !== false) {
			
				\$scheme = 'http://';
			
				if (isset(\$_SERVER['HTTPS'])) {
					if ('on' == strtolower(\$_SERVER['HTTPS']))
						\$scheme = 'https://';
					if ('1' == \$_SERVER['HTTPS'])
						\$scheme = 'https://';
				} elseif (isset(\$_SERVER['SERVER_PORT']) && ('443' == \$_SERVER['SERVER_PORT'])) {
					\$scheme = 'https://';
				}		
			
				return \$scheme . \$_SERVER['HTTP_HOST'] . '/web/' . \$string;
			} else {
				return '/' . \$string;
			}
		})
	);	

    return \$twig;
}));

return \$app;
EOF
cat > app/config.php <<EOF
<?php
    
    // true  --> Emails gehen zu Testadressen
	// false --> emails sind scharf
    \$useDevEmailAddress = false;
    
    // E-Mails gehen bei Testzwecken zu diesen Adressen
    \$devEmailAddress = array();
    
    // Email Kunde
    \$storeEmail = array();
    
	/* ------------------------------------------------------------------------------------------------------ */
	/*  */
    /* ------------------------------------------------------------------------------------------------------ */
	\$develop = \$_SERVER['SERVER_ADDR'] == '192.168.8.128' || \$_SERVER['SERVER_NAME'] == 'draft';
    
    // Datenbank
    if (\$develop) {
        // Dev
        \$dbConfig = array(
                          'driver'   => 'pdo_mysql',
                          'charset'  => 'UTF8',
                          'dbhost'   => 'localhost',
                          'dbname'   => '',
                          'user'     => '',
                          'password' => '',
                          );
    } else {
        // Live
        \$dbConfig = array(
                          'driver'   => 'pdo_mysql',
                          'charset'  => 'UTF8',
                          'dbhost'   => 'localhost',
                          'dbname'   => '',
                          'user'     => '',
                          'password' => '',
                          );
    }
    /* ------------------------------------------------------------------------------------------------------ */
	
	\$config = array(
		'dbConfig' => \$dbConfig
	);
EOF
cat > app/controller.php <<EOF
<?php
    
    // Mount login redirect
    //\$app->mount('/login/redirect', new Controller\LoginRedirect());
    
    // Mount cart
    /*\$cartController = new Controller\CartController();
    \$app->mount('/cart', \$cartController);*/
    
    /* ------------------------------------------------------------------------------------------------------ */
    
    // Index
    \$app->get('/', function () use (\$app) {
              
            return \$app['twig']->render('Default/index.twig', array());
        }
    )
    ->bind('index');
EOF
# Create src directory
mkdir src
# Create views directory
mkdir views
mkdir views/Default
mkdir views/Page
# Create header and footer
touch views/Page/header.twig
touch views/Page/footer.twig
# Create layout.twig
touch views/layout.twig
cat > views/layout.twig <<EOF
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>{% block title %}Draft{% endblock %}</title>

<!-- Bootstrap -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

<!-- Favicon -->
<link rel="shortcut icon" href="{{ 'favicon.ico'|fileinclude }}" />
<link rel="apple-touch-icon" sizes="60x60" href="{{ 'images/apple-icon-60x60.png'|fileinclude }}">
<link rel="apple-touch-icon" sizes="120x120" href="{{ 'images/apple-icon-120x120.png'|fileinclude }}">
<link rel="icon" type="image/png" sizes="32x32" href="{{ 'images/favicon-32x32.png'|fileinclude }}">
<link rel="icon" type="image/png" sizes="16x16" href="{{ 'images/favicon-16x16.png'|fileinclude }}">

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->
</head>
<body>

<div class="container">

	{% include 'Page/header.twig' %}

	{% block content %}
	{% endblock %}

	{% include 'Page/footer.twig' %}

</div>


</body>
</html>
EOF
# index
cat > views/Default/index.twig <<EOF
{% extends "layout.twig" %}

{% block content %}

<h1>INDEX</h1>

{% endblock %}

EOF
# Create web directory and index.php
mkdir web
cat > web/index.php <<EOF
<?php
require_once __DIR__ . '/../vendor/autoload.php';

require __DIR__ . '/../app/config.php';
\$app = require __DIR__ . '/../app/app.php';
require __DIR__ . '/../app/controller.php';

\$app->run();
EOF