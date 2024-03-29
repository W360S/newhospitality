<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: AdminPackagesController.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_AdminPackagesController extends Core_Controller_Action_Admin
{
  public function indexAction()
  {
    // Check auth
    $viewer = Engine_Api::_()->user()->getViewer();
    if( !$viewer || !$viewer->getIdentity() ) {
      return $this->_helper->redirector->gotoRoute(array(), 'admin_default', true);
    }
    $viewerLevel = Engine_Api::_()->getDbtable('levels', 'authorization')->find($viewer->level_id)->current();
    if( null === $viewerLevel || $viewerLevel->flag != 'superadmin' ) {
      return $this->_helper->redirector->gotoRoute(array(), 'admin_default', true);
    }
    
    // Build package url
    $authKeyRow = Engine_Api::_()->getDbtable('auth', 'core')
      ->getKey(Engine_Api::_()->user()->getViewer(), 'package');
    $this->view->authKey = $authKey = $authKeyRow->id;

    $installUrl = rtrim($this->view->baseUrl(), '/') . '/install';
    if( strpos($this->view->url(), 'index.php') !== false ) {
      $installUrl .= '/index.php';
    }
    $installUrl .= '/auth/key' . '?key=' . $authKey . '&uid=' . Engine_Api::_()->user()->getViewer()->getIdentity();
    $this->view->installUrl = $installUrl;

    return $this->_helper->redirector->gotoUrl($installUrl, array('prependBase' => false));
  }
}