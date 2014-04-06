<?php
/**
 * Ilinkbay
 *
 * @category   Application_Extensions
 * @package    EventProfile
 * @author     huynhnv
 */

class Event_Widget_DetailEventController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    // Don't render this if not authorized
    $viewer = Engine_Api::_()->user()->getViewer();
    if( !Engine_Api::_()->core()->hasSubject() ) {
      return $this->setNoRender();
    }

    // Get subject and check auth
    $subject = Engine_Api::_()->core()->getSubject('event');
    if( !$subject->authorization()->isAllowed($viewer, 'view') ) {
      return $this->setNoRender();
    }

    $this->view->subject = $subject;
  }
}