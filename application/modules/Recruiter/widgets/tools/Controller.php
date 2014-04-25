<?php 
class Recruiter_Widget_ToolsController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $user= Engine_Api::_()->user()->getViewer();
        if(!$user->getIdentity()){
            $this->setNoRender();
        }
        $job_id= Zend_Controller_Front::getInstance()->getRequest()->getParam('id');
        $this->view->job_id= $job_id;
    }
}