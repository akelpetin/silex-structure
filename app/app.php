<?php

$app = new Silex\Application();

// DEBUG
$app['debug'] = $develop;

// Doctrine service
/*$app->register(
    new Silex\Provider\DoctrineServiceProvider(),
    array(
        'db.options' => $dbConfig,
    )
);*/

// Twig service
$app->register(
    new Silex\Provider\TwigServiceProvider(),
    array(
        'twig.path' => __DIR__.'/../views'
    )
);

// Translator service
$app->register(
    new Silex\Provider\TranslationServiceProvider(),
    array(
        'locale_fallback' => 'de',
    )
);

// Validator service
//$app->register(new Silex\Provider\ValidatorServiceProvider());

// Url generator service
$app->register(new Silex\Provider\UrlGeneratorServiceProvider());

// Form service
$app->register(new Silex\Provider\FormServiceProvider());

// Security
/*$app->register(
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
                'users'       => $app->share(
                    function () use ($app) {
                        return new User\UserProvider($app['db']);
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
//$app->register(new Silex\Provider\SessionServiceProvider());

if ($develop) {
    $transport = \Swift_SmtpTransport::newInstance('smtp.url', 587)
        ->setUsername(base64_decode('username'))
        ->setPassword(base64_decode('password'))
    ;
} else {
    $transport = \Swift_MailTransport::newInstance();
}

// Swiftmailer
$app->register(new Silex\Provider\SwiftmailerServiceProvider(), array(
    'swiftmailer.use_spool' => false,
    'swiftmailer.transport' => $transport
));

// Set app values
$app['config'] = $config;

// Set twig default values
$app['twig'] = $app->share($app->extend('twig', function(\Twig_Environment $twig, \Silex\Application $app) {
    $twig->addGlobal('config', $app['config']);	
	$twig->addFilter(new Twig_SimpleFilter('fileinclude', function($string) {
			
			if ($_SERVER['HTTP_HOST'] == 'kw1ua121') {
				$scriptPath = str_replace('index.php', '', $_SERVER['SCRIPT_NAME']);
				
				return 'http://' . $_SERVER['HTTP_HOST'] . $scriptPath . $string;
			} elseif (strpos($_SERVER['REQUEST_URI'], '/web/') !== false) {
			
				$scheme = 'http://';
			
				if (isset($_SERVER['HTTPS'])) {
					if ('on' == strtolower($_SERVER['HTTPS']))
						$scheme = 'https://';
					if ('1' == $_SERVER['HTTPS'])
						$scheme = 'https://';
				} elseif (isset($_SERVER['SERVER_PORT']) && ('443' == $_SERVER['SERVER_PORT'])) {
					$scheme = 'https://';
				}		
			
				return $scheme . $_SERVER['HTTP_HOST'] . '/web/' . $string;
			} else {
				return '/' . $string;
			}
		})
	);	

    return $twig;
}));

return $app;
