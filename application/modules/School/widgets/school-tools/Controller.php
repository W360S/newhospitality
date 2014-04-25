<?php
/*
@author: huynhnv
@function: tools schools

*/ 
class School_Widget_SchoolToolsController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $user= Engine_Api::_()->user()->getViewer();
        if(!$user->getIdentity()){
            $this->setNoRender();
        }
        //dem so cong viec duoc giai quyet
        $table_module= Engine_Api::_()->getDbtable('modules', 'user');
        $select_module= $table_module->select()->where('user_id = ?', $user->getIdentity())
                            ->where('name_module =?', 'school')
        ;
        $module_schools= $table_module->fetchRow($select_module);
        
        if(count($module_schools)==0){
            $this->setNoRender();
        }
        if(count($module_schools)){
            
            $table = Engine_Api::_()->getItemTable('school_artical');
          
            $select_pending= $table->select()->where('approved =?', 0)->where('reject =?', 0);
            //$this->view->page = $page = $this->_getParam('page', 1);
            //jobs pending
            $paginator_pending = $table->fetchAll($select_pending);
            $this->view->article_pending= count($paginator_pending);
            //jobs approved
            
            $select_approved= $table->select()->where('resolved_by =?', $user->getIdentity())->where('approved =?', 1)->where('reject =?', 0);
            $paginator_approved = $table->fetchAll($select_approved);
            $this->view->article_approved= count($paginator_approved);
            //jobs reject
            $select_reject= $table->select()->where('reject =?', $user->getIdentity());
            $paginator_reject = $table->fetchAll($select_reject);
            $this->view->article_reject= count($paginator_reject);
            //Zend_Debug::dump($paginator_pending);
    
        }
    }
}