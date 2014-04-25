<?php
/*
@author: huynhnv
@function: categories resumes

*/ 
class Resumes_Widget_CategoriesController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        //find all industries
        $category_all= Zend_Controller_Front::getInstance()->getRequest()->getParam('list');
        
        $tableCategory= Engine_Api::_()->getDbtable('industries', 'recruiter');
        if($category_all=='all'){
            $select= $tableCategory->select();
        }
        else{
            //mới đầu có all categories nên để limit = 9, giờ thì bỏ đi.
            $select= $tableCategory->select();
        }
        
        $categories= $tableCategory->fetchAll($select);
        //Zend_Debug::dump($categories);exit;
        $category_temp= array();
        $i= 0;
        $sum=0;
        if(count($categories)){
            foreach($categories as $category){
                $table = Engine_Api::_()->getDbtable('experiences', 'resumes');
                $row = $table->fetchAll(
                                $table
                                    ->select()
                                    ->distinct()
                                    ->from($table,'resume_id')
                                    ->where('category_id = ?', $category->industry_id)                         
                                    );
                $resume_ids = array();
                if(count($row)){
                    foreach($row as $val){
                        $resume_ids[$val['resume_id']]= $val['resume_id'];
                    }
                    $tableResume= Engine_Api::_()->getDbtable('resumes', 'resumes');
                    $select= $tableResume->select()
                                ->where('enable_search > ?', 0)
                                ->where('approved =?', 1)
                                ->where('resume_id IN(?)', $resume_ids)
                                
                                ;
                    $resumes= $tableResume->fetchAll($select);
                    
                    if(count($resumes)){
                        $sum= count($resumes);
                    }
                     
                }
                $category_temp[$i]['occup_id']= $category->industry_id;
                $category_temp[$i]['name']= $category->name;
                $category_temp[$i]['sum']= $sum; 
                $sum=0;
                $i++;
            }
            //sap xep giam dan
            for($i=0; $i<count($category_temp)-1; $i++){
                
              for($j = $i+1; $j>0; $j--){
                if($category_temp[$j]['sum'] > $category_temp[$j-1]['sum']){
                    $temp = $category_temp[$j];
                    $category_temp[$j] = $category_temp[$j-1] ;
                    $category_temp[$j-1] = $temp;
                }
              }
            }
        }
        
        //Zend_Debug::dump($categories);exit;
        $this->view->categories= $category_temp;
        $this->view->category= $category_all;
    }
}