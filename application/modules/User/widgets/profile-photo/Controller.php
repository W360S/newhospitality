<?php

/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Controller.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class User_Widget_ProfilePhotoController extends Engine_Content_Widget_Abstract {

    public function indexAction() {
        // Don't render this if not authorized
        $viewer = Engine_Api::_()->user()->getViewer();
        if (!Engine_Api::_()->core()->hasSubject()) {
            //return $this->setNoRender();
            if ($viewer) {
                # code...
                $this->view->user = $viewer;
            } else {
                return $this->setNoRender();
            }
        } else {
            // Get subject and check auth
            $subject = Engine_Api::_()->core()->getSubject('user');
            //if( !$subject->authorization()->isAllowed($viewer, 'view') ) {
            //  return $this->setNoRender();
            //}

            $this->view->user = $subject;
        }
    }

}
