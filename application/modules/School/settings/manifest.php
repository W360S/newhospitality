<?php return array (
  'package' => 
  array (
    'type' => 'module',
    'name' => 'school',
    'version' => '4.0.0',
    'path' => 'application/modules/School',
    'meta' => 
    array (
      'title' => 'Schools',
      'description' => 'About school education.',
      'author' => 'huynhnv',
    ),
    'callback' => 
    array (
      'class' => 'Engine_Package_Installer_Module',
    ),
    'actions' => 
    array (
      0 => 'install',
      1 => 'upgrade',
      2 => 'refresh',
      3 => 'enable',
      4 => 'disable',
    ),
    'directories' => 
    array (
      0 => 'application/modules/School',
    ),
    'files' => 
    array (
      0 => 'application/languages/en/school.csv',
    ),
  ),
  // Hooks ---------------------------------------------------------------------
  'hooks' => array(
    
    array(
      'event' => 'onUserDeleteAfter',
      'resource' => 'School_Plugin_Core'
    )
  ),
  // Items ---------------------------------------------------------------------
  'items' => array(
    'school',
    'school_school',
    'school_artical'
  ),
  'routes' => array(
    
    
      'view-school' => array(
      'route' => 'school/inform/:id/*',
      'defaults' => array(
        'module' => 'school',
        'controller' => 'index',
        'action' => 'view',
			  ),

      'reqs' => array(
        'id' => '\d+',
      )),
      'view-school-artical' => array(
      'route' => 'school/articles/:id/*',
      'defaults' => array(
        'module' => 'school',
        'controller' => 'article',
        'action' => 'view',
			  ),

      'reqs' => array(
        'id' => '\d+',
      )),
      'view-all-article' => array(
      'route' => 'school/viewall/:id/*',
      'defaults' => array(
        'module' => 'school',
        'controller' => 'index',
        'action' => 'view-all',
			  ),

      'reqs' => array(
        'id' => '\d+',
      )),
      
  )
); ?>