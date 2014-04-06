<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Group
 * 
 * @author     huynhnv
 */
 

class Group_Widget_NagativeController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
  	  $this->getNavigation();
	
  }
  public function getNavigation()
  {
    $this->view->navigation = $navigation = new Zend_Navigation();
    $navigation->addPage(array(
      'label' => 'All Groups',
      'route' => 'group_general',
      'action' => 'browse',
      'controller' => 'index',
      'module' => 'group'
    ));

    if( Engine_Api::_()->user()->getViewer()->getIdentity() ) {
      $navigation->addPages(array(
        array(
          'label' => 'My Groups',
          'route' => 'group_general',
          'action' => 'manage',
          'controller' => 'index',
          'module' => 'group'
        ),
        /*
        array(
          'label' => 'Edit Group',
          'route' => 'group_general',
          'action' => 'create',
          'controller' => 'index',
          'module' => 'group'
        )
        */
      ));
    }
	}
}