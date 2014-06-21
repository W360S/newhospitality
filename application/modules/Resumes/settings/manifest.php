<?php return array (
  'package' => 
  array (
    'type' => 'module',
    'name' => 'resumes',
    'version' => '4.0.0',
    'path' => 'application/modules/Resumes',
    'meta' => 
    array (
      'title' => 'Resumes',
      'description' => 'Resumes ver1',
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
      0 => 'application/modules/Resumes',
    ),
    'files' => 
    array (
      0 => 'application/languages/en/resumes.csv',
    ),
  ),
   // Hooks ---------------------------------------------------------------------
  'hooks' => array(
    
    array(
      'event' => 'onUserDeleteAfter',
      'resource' => 'Resumes_Plugin_Core'
    )
  ),
  // Items ---------------------------------------------------------------------
  'items' => array(
    'resume',
    'experience',
    'education',
    'languageskill',
    'skill',
    'reference',
    'resumes_resume',
    'resumes_experience',
    'resumes_languageskill',
    'resumes_skill',
    'resumes_reference',
    'resumes_education'
  ),
  'routes' => array(
    // 'view-resume' => array(
    //   'route' => 'resumes/resume/view/resume_id/:id/*',
    //   'defaults' => array(
    //     'module' => 'resumes',
    //     'controller' => 'resume',
    //     'action' => 'view',
    //     ),

    //   'reqs' => array(
    //     'id' => '\d+',
    //   )),
    'resume_work' => array(
      'route' => 'resume_work/:id/*',
      'defaults' => array(
        'module' => 'resumes',
        'controller' => 'index',
        'action' => 'resume-work',
			  ),

      'reqs' => array(
        'id' => '\d+',
      )),
      'resume_education' => array(
      'route' => 'resume_education/:id/*',
      'defaults' => array(
        'module' => 'resumes',
        'controller' => 'education',
        'action' => 'index',
			  ),

      'reqs' => array(
        'id' => '\d+',
      ))
    
  )
  
); ?>