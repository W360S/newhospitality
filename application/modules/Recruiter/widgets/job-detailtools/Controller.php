<?php

/*
  @author: huynhnv
  @function: tools job

 */

class Recruiter_Widget_JobDetailtoolsController extends Engine_Content_Widget_Abstract {

    public function indexAction() {
        $user = Engine_Api::_()->user()->getViewer();
        if (!$user->getIdentity()) {
            $this->setNoRender();
        }
        //dem so cong viec duoc giai quyet
        $this->view->user_id = $user->getIdentity();
        $this->view->params = Zend_Controller_Front::getInstance()->getRequest()->getParams();
    }

}
