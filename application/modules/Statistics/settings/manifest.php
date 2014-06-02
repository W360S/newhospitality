<?php return array (
  'package' => 
  array (
    'type' => 'module',
    'name' => 'statistics',
    'version' => '4.0.0',
    'path' => 'application/modules/Statistics',
    'meta' => 
    array (
      'title' => 'statistics',
      'description' => 'statistics',
      'author' => 'quangnvh',
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
      0 => 'application/modules/Statistics',
    ),
    'files' => 
    array (
      0 => 'application/languages/en/statistics.csv',
    ),
  ),
  'items'=> array(
    'statistics_content'
    ),
  // Routes --------------------------------------------------------------------
  'routes' => array(
    // Admin
    'statistics_edit' => array(
      'route' => '/admin/statistics/manage/edit/:statistic_id',
      'defaults' => array(
        'module' => 'statistics',
        'controller' => 'admin-manage',
        'action' => 'edit'
      ),
      'reqs' => array(
        'statistic_id' => '\d+'
      ),
    ),
    'statistics_view' => array(
      'route' => '/admin/statistics/manage/view/:statistic_id',
      'defaults' => array(
        'module' => 'statistics',
        'controller' => 'admin-manage',
        'action' => 'view'
      ),
      'reqs' => array(
        'statistic_id' => '\d+'
      ),
    ),
    'contact_edit' => array(
      'route' => '/admin/statistics/manage/edit-contact/:contact_id',
      'defaults' => array(
        'module' => 'statistics',
        'controller' => 'admin-manage',
        'action' => 'edit-contact'
      ),
      'reqs' => array(
        'contact_id' => '\d+'
      ),
    ),
    'contact_view' => array(
      'route' => '/admin/statistics/manage/view-contact/:contact_id',
      'defaults' => array(
        'module' => 'statistics',
        'controller' => 'admin-manage',
        'action' => 'view-contact'
      ),
      'reqs' => array(
        'contact_id' => '\d+'
      ),
    ),
    'contact_view' => array(
      'route' => '/statistics/index/help/:category_id',
      'defaults' => array(
        'module' => 'statistics',
        'controller' => 'index',
        'action' => 'help'
      ),
      'reqs' => array(
        'category_id' => '\d+'
      )
    )
  ),
  
); ?>