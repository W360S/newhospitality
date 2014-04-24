<?php

class Resumes_SearchController extends Core_Controller_Action_Standard
{
    public function indexAction(){
        $category_id= $this->_getParam('category_id');
        $table = Engine_Api::_()->getDbtable('experiences', 'resumes');
        $row = $table->fetchAll(
                        $table
                            ->select()
                            ->distinct()
                            ->from($table,'resume_id')
                            ->where('category_id = ?', $category_id)                         
                            );
        
        
        $this->view->category_id= $category_id;
        if(count($row)>0){
            $resume_ids = array();
            foreach($row as $val){
                $resume_ids[$val['resume_id']]= $val['resume_id'];
            }
            
            $tableResume= Engine_Api::_()->getDbtable('resumes', 'resumes');
            $select= $tableResume->select()
                        ->where('enable_search > ?', 0)
                        ->where('approved =?', 1)
                        ->where('resume_id IN(?)', $resume_ids)
                        
                        ;
            $this->view->page = $page = $this->_getParam('page', 1);
            $paginator = $this->view->paginator = Zend_Paginator::factory($select);
            //Zend_Debug::dump($paginator);exit;
            $paginator->setItemCountPerPage(20);
            $paginator->setCurrentPageNumber($page);
        }
    }
    public function categoryAction(){
        
    }
}
  