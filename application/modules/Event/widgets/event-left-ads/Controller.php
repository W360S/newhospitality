<?php

/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Event
 * 
 * @author     bangvn
 */
class Event_Widget_EventLeftAdsController extends Engine_Content_Widget_Abstract {

    public function indexAction() {
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