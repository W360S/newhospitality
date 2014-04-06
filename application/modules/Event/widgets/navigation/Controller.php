<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Event
 * 
 * @author     huynhnv
 */

class Event_Widget_NavigationController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
  	$this->getNavigation();
  }
  public function getNavigation($filter = false)
  {
    $this->view->navigation = $navigation = new Zend_Navigation();
    $navigation->addPages(array(
      array(
        'label' => "Upcoming Events",
        'route' => 'event_general',
      ),
      array(
        'label' => "Past Events",
        'route' => 'event_past'
	    )));
  

    $viewer = Engine_Api::_()->user()->getViewer();
    if ($viewer->getIdentity()) {
      $navigation->addPages(array(
        array(
          'label' => 'My Events',
          'route'=> 'event_general',
          'action' => 'manage',
          'controller' => 'index',
          'module' => 'event'
        ),
        /*
	array(
          'label' => 'Create New Event',
          'route'=>'event_general',
          'action' => 'create',
          'controller' => 'index',
          'module' => 'event'
	      )
	      */
	));
    }
    return $navigation;     
  }
}
