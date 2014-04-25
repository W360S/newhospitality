<?php 
class Resumes_Widget_SuggestResumeController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        //get profile company
        $user_id= Engine_Api::_()->user()->getViewer()->getIdentity();
        $table_recruiter =Engine_Api::_()->getDbtable('recruiters', 'recruiter');
        $select_recruiter = $table_recruiter->select();
        $select_recruiter->from($table_recruiter, array('recruiter_id'));
        $recruiter = $table_recruiter->fetchRow($select_recruiter);
        $profile = Engine_Api::_()->getItem('recruiter', $recruiter->recruiter_id);
        $string= $profile->company_name." ".$profile->description;
        $table= Engine_Api::_()->getDbtable('resumes', 'resumes');
        $rName= $table->info('name');
        $db = $table->getAdapter();
        $select= $table->select()
                    ->where('enable_search > ?', 0)
                    ->where('approved =?', 1)
                    ->order('view_count DESC')
                    ->where(new Zend_Db_Expr($db->quoteInto('MATCH(' . $rName . '.`title`) AGAINST (? IN BOOLEAN MODE)', $string)))
                
                    ;
       
        $this->view->paginator= $paginator= Zend_Paginator::factory($select);
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        //$resumes= $table->fetchAll($select);
        if(count($paginator)==0){
            $this->setNoRender();
        }
        //$this->view->resumes= $resumes;
                    
    }
}