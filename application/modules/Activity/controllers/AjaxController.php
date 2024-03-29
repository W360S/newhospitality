<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Activity
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: AjaxController.php 9806 2012-10-30 23:54:12Z matthew $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Activity
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Activity_AjaxController extends Core_Controller_Action_Standard
{
  public function feedAction()
  {    
    // Get config options for activity
    $config = array(
      'action_id' => (int) $this->_getParam('action_id'),
      'max_id' => (int) $this->_getParam('maxid'),
      'min_id' => (int) $this->_getParam('minid'),
      'limit' => (int) $this->_getParam('limit'),
    );
    
    $viewer = Engine_Api::_()->user()->getViewer();

    if( !isset($subject) && Engine_Api::_()->core()->hasSubject() ) {
      $subject = Engine_Api::_()->core()->getSubject();
    }

    if( !empty($subject) ) {
      $activity = Engine_Api::_()->getDbtable('actions', 'activity')->getActivityAbout($subject, $viewer, $config);
      $this->view->subjectGuid = $subject->getGuid(false);
    } else {
      $activity = Engine_Api::_()->getDbtable('actions', 'activity')->getActivity($viewer, $config);
      $this->view->subjectGuid = null;
    }

    $feed = array();
    foreach( $activity as $action ) {
      $attachments = array();
      if( $action->attachment_count > 0 ) {
        foreach( $action->getAttachments() as $attachment ) {
          $attachments[] = array(
            'meta' => $attachment->meta->toArray(),
            'item' => $attachment->item->toRemoteArray(),
          );
        }
      }
      $feed[] = array(
        'typeinfo' => $action->getTypeInfo()->toArray(),
        'action' => $action->toArray(),
        'subject' => $action->getSubject()->toRemoteArray(),
        'object' => $action->getObject()->toRemoteArray(),
        'attachments' => $attachments
      );
    }
    $this->view->feed = $feed;
  }
}