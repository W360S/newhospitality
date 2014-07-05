<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: manifest.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
return array(
    // Package -------------------------------------------------------------------
    'package' => array(
        'type' => 'module',
        'name' => 'bang',
        'version' => '0.0.1',
        'path' => 'application/modules/Bang',
        'repository' => 'null',
        'meta' => array(
            'title' => 'Bang',
            'description' => 'Bangs module for hospitality.vn ',
            'author' => 'Bang Ngoc Vu',
            'date' => 'Friday, 09 Jul 2010 18:33:08 +0000',
            'copyright' => 'Copyright 2014 BangVN'
        ),
        'actions' => array(
            'install',
            'upgrade',
            'refresh',
            'enable',
            'disable',
        ),
        'callback' => array(
            'path' => 'application/modules/Bang/settings/install.php',
            'class' => 'Bang_Installer',
        ),
        'directories' => array(
            'application/modules/Bang',
        ),
        'files' => array(
            'application/languages/en/bang.csv',
        ),
    ),
    // Hooks ---------------------------------------------------------------------
    'hooks' => array(
    /*
      array(
      'event' => 'onUserDeleteBefore',
      'resource' => 'Feedback_Plugin_Core',
      ),
      array(
      'event' => 'onRenderLayoutDefault',
      'resource' => 'Feedback_Plugin_Core',
      ),
     */
    ),
    // Items ---------------------------------------------------------------------
    'items' => array(
        'bang_request'
    /*
      'feedback',
      'feedback_album',
      'feedback_image',
      'vote',
      'blockuser',
      'blockip',
      'user',
      'categories',
      'severities',
      'status'
     * 
     */
    ),
    // Routes --------------------------------------------------------------------
    'routes' => array()
        )
?>
