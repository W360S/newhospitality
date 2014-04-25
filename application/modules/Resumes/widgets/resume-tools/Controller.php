<?php
/*
@author: huynhnv
@function: tools resumes

*/ 
class Resumes_Widget_ResumeToolsController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $user= Engine_Api::_()->user()->getViewer();
        if(!$user->getIdentity()){
            $this->setNoRender();
        }
        //dem so cong viec duoc giai quyet
        $table_module= Engine_Api::_()->getDbtable('modules', 'user');
        $select_module= $table_module->select()->where('user_id = ?', $user->getIdentity())
                            ->where('name_module =?', 'resume')
        ;
        $module_resumes= $table_module->fetchRow($select_module);
        
        if(count($module_resumes)==0){
            $this->setNoRender();
        }
        if(count($module_resumes)){
            
            $table = Engine_Api::_()->getItemTable('resume');
          
            $select_pending= $table->select()->where('approved =?', 2)->where('reject =?', 0);
            //$this->view->page = $page = $this->_getParam('page', 1);
            //jobs pending
            $paginator_pending = $table->fetchAll($select_pending);
            $this->view->resume_pending= count($paginator_pending);
            //jobs approved
            
            $select_approved= $table->select()->where('resolved_by =?', $user->getIdentity())->where('approved =?', 1)->where('reject =?', 0);
            $paginator_approved = $table->fetchAll($select_approved);
            $this->view->resume_approved= count($paginator_approved);
            //jobs reject
            $select_reject= $table->select()->where('reject =?', $user->getIdentity());
            $paginator_reject = $table->fetchAll($select_reject);
            $this->view->resume_reject= count($paginator_reject);
            //Zend_Debug::dump($paginator_pending);
    
        }
    }
}