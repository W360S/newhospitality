<?php
/*
@author: huynhnv
@function: New job

*/ 
class Recruiter_Widget_NewJobController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $table= Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $select= $table->select()
                        ->from($table->info('name'))
                        ->where('status =?', 2)
                        ->where('deadline > ?', date('Y-m-d'))
                        ->limit(50)
                        ->order('creation_date DESC');
        $records= $table->fetchAll($select);
        $this->view->paginator= $paginator= Zend_Paginator::factory($records);
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        $paginator->setPageRange(5);
		
        if(count($paginator)==0){
            $this->setNoRender(true);
        }
        
    }
}