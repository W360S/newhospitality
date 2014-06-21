<?php return array (
  'package' => 
  array (
    'type' => 'module',
    'name' => 'experts',
    'version' => '4.0.0',
    'path' => 'application/modules/Experts',
    'meta' => 
    array (
      'title' => 'viethospitality experts',
      'description' => 'module viethospitality experts',
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
      0 => 'application/modules/Experts',
    ),
    'files' => 
    array (
      0 => 'application/languages/en/experts.csv',
    ),
    
  ),
  
  // hook
  'hooks' => array(
    array(
      'event' => 'onUserDeleteBefore',
      'resource' => 'Experts_Plugin_Core',
    ),
  ),  
  // Items
  'items' => array(
    'experts',
    'question',
    'experts_question',
    'experts_answer',
    'experts_expert'
  ),  
  // Routes --------------------------------------------------------------------
  'routes' => array(
    'experts_edit' => array(
      'route' => 'admin/experts/manage-experts/edit/expert_id/:expert_id',
      'defaults' => array(
        'module' => 'experts',
        'controller' => 'admin-manage-experts',
        'action' => 'edit',
      ),
      'reqs' => array(
        'expert_id' => '\d+'
      )
    ),
    'experts_delete' => array(
      'route' => 'admin/experts/manage-experts/delete/expert_id/:expert_id',
      'defaults' => array(
        'module' => 'experts',
        'controller' => 'admin-manage-experts',
        'action' => 'delete',
      ),
      'reqs' => array(
        'expert_id' => '\d+'
      )
    ),
    'experts_delete_image' => array(
      'route' => 'admin/experts/manage-experts/delete/expert_id/:expert_id/photo_id/:photo_id',
      'defaults' => array(
        'module' => 'experts',
        'controller' => 'admin-manage-experts',
        'action' => 'delete-image',
      ),
      'reqs' => array(
        'expert_id' => '\d+',
        'photo_id' => '\d+',
      )
    ),
    'experts_delete_attachment' => array(
      'route' => 'admin/experts/manage-experts/delete/expert_id/:expert_id/file_id/:file_id',
      'defaults' => array(
        'module' => 'experts',
        'controller' => 'admin-manage-experts',
        'action' => 'delete-file',
      ),
      'reqs' => array(
        'expert_id' => '\d+',
        'file_id' => '\d+',
      )
    ),
    'my_expert_manage' => array(
      'route' => 'experts/my-experts/manage/expert_id/:expert_id',
      'defaults' => array(
        'module' => 'experts',
        'controller' => 'my-experts',
        'action' => 'manage',
      ),
      'reqs' => array(
        'expert_id' => '\d+'
      )
    )
    
   ),
); ?>