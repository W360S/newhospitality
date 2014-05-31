<?php
/*
@author: huynhnv
@function: Sub Menu

*/ 
class Resumes_Widget_SubMenuController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        //check create resume
        if(!Engine_Api::_()->user()->getViewer()->getIdentity()){
            $this->setNoRender();
        }
        $table= Engine_Api::_()->getDbtable('resumes', 'resumes');
        $select= $table->select()
                        ->where('user_id =?', Engine_Api::_()->user()->getViewer()->getIdentity())
                        ;
        $resumes= $table->fetchAll($select);
        $this->view->sum_resume= $resumes;
        
        $selectResume = $table->select()
                    ->where('user_id=?', Engine_Api::_()->user()->getViewer()->getIdentity())
                    ->where('approved =?', 1);
        $resumes = $table->fetchAll($selectResume);
        $this->view->approved_resumes = $resumes;
    }
}