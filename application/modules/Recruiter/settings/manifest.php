<?php return array (
  'package' => 
  array (
    'type' => 'module',
    'name' => 'recruiter',
    'version' => '4.0.0',
    'path' => 'application/modules/Recruiter',
    'meta' => 
    array (
      'title' => 'Recruiter',
      'description' => 'Des Recruiter',
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
      0 => 'application/modules/Recruiter',
    ),
    'files' => 
    array (
      0 => 'application/languages/en/recruiter.csv',
    ),
  ),
  // Hooks ---------------------------------------------------------------------
  'hooks' => array(
    
    array(
      'event' => 'onUserDeleteAfter',
      'resource' => 'Recruiter_Plugin_Core'
    )
  ),
  // Items ---------------------------------------------------------------------
  'items' => array(
    'recruiter',
    'recruiter_job',
    'job',
    'artical',
    'recruiter_job'
  ),
  'routes' => array(
    
    'view-profile' => array(
      'route' => 'profile_company/:id/*',
      'defaults' => array(
        'module' => 'recruiter',
        'controller' => 'index',
        'action' => 'view-profile',
			  ),

      'reqs' => array(
        'id' => '\d+',
      )),
      'view-job' => array(
      'route' => 'recruiter/jobs/:id/*',
      'defaults' => array(
        'module' => 'recruiter',
        'controller' => 'job',
        'action' => 'view-job',
			  ),

      'reqs' => array(
        'id' => '\d+',
      )),
      'admin-view-job' => array(
      'route' => 'recruiter/viewjobs/:id/*',
      'defaults' => array(
        'module' => 'recruiter',
        'controller' => 'job',
        'action' => 'admin-view-job',
			  ),

      'reqs' => array(
        'id' => '\d+',
      ))        
      
  )
  
  
); ?>