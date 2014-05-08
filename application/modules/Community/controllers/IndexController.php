<?php

class Community_IndexController extends Core_Controller_Action_Standard
{
    public function init()
    {
        // Kiem tra quyen co duoc xem trang nay
        // Neu chua dang nhap thi day ve trang login
        if (! $this->_helper->requireUser()->isValid())
        {
            return;
        }
        $subject = Engine_Api::_()->user()->getViewer();
        Engine_Api::_()->core()->setSubject($subject);
    }

    public function indexAction()
    {        
        //$this->_helper->content->render();
        $this->_helper->content
                ->setContentName(46) // page_id
                // ->setNoRender()
                ->setEnabled();
    }
}
