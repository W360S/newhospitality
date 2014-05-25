<?php
/*
@author: huynhnv
@function: Hot job

*/ 
class Recruiter_Widget_HotJobController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
       
        $table= Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $hot_select= $table->select()
                        ->from($table->info('name'))
                        ->where('status =?', 2)
                        ->where('deadline > ?', date('Y-m-d'))
                        ->limit(3)
                        
                        ->order('num_apply DESC');
        $records= $table->fetchAll($hot_select);
        $this->view->hot_paginator= $hot_paginator= Zend_Paginator::factory($records);
        
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $hot_paginator->setItemCountPerPage(10);
        $hot_paginator->setCurrentPageNumber($request->getParam('page'));
        $hot_paginator->setPageRange(5);
        if(count($hot_paginator)==0){
            $this->setNoRender(true);
        }
    }
}