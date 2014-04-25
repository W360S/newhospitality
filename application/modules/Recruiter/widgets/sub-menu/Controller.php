<?php 
class Recruiter_Widget_SubMenuController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        
        $table= Engine_Api::_()->getDbtable('recruiters', 'recruiter');
        $select= $table->select()
                        ->where('user_id =?', Engine_Api::_()->user()->getViewer()->getIdentity())
                        ;
        $profile= $table->fetchRow($select);
        //Zend_Debug::dump(count($profile));
        $this->view->profile= $profile;
    }
}