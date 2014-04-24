<?php 
class Resumes_Widget_PopularResumeController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $table= Engine_Api::_()->getDbtable('resumes', 'resumes');
        $select= $table->select()
                    ->where('enable_search > ?', 0)
                    ->where('approved =?', 1)
                    ->order('view_count DESC')
                    //->limit(6);
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