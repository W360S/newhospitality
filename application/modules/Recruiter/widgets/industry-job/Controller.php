<?php
/*
@author: huynhnv
@function: industry job

*/ 
class Recruiter_Widget_IndustryJobController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        //find all industries
        $industry_all= Zend_Controller_Front::getInstance()->getRequest()->getParam('list');
        
        $tableIndustry= Engine_Api::_()->getDbtable('industries', 'recruiter');
        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $table_jobs= Engine_Api::_()->getDbtable('jobs', 'recruiter');
        if($industry_all=='all'){
            $select= $tableIndustry->select();
        }
        else{
            $industry_all= null;
            $select= $tableIndustry->select()
                            
                                        //->distinct()
                                        //->setIntegrityCheck(false)  
                                        //->from($tableIndustry->info('name'))
                                        //->joinLeft($table->info('name'), $table->info('name'). ".industry_id = ". $tableIndustry->info('name') . ".industry_id", array())
                                        //->where($table->info('name').".job_id".'>?', 0)
                                        //->order('COUNT('. $table->info('name').".industry_id".') DESC')
                                        //->joinLeft($table_jobs->info('name'), $table_jobs->info('name'). ".job_id = ". $table->info('name') . ".job_id", array())
                                        //->where($table_jobs->info('name').".status".'= ?', 2)
                                        //->limit(9)
                                        
                                        ;
                                        //Zend_Debug::dump($select->assemble());//exit;
        }
        
        $industries= $tableIndustry->fetchAll($select);
        $industries_temp= array();
        $i=0;
        foreach($industries as $industry){
            $row = $table->fetchAll(
                        $table
                            ->select()
                            ->where('industry_id = ?', $industry->industry_id)
                            ->where('job_id > ?', 0)
                            //->where('status =?', 2)
                            );
            
            $sum= 0;
            foreach($row as $val){
                
                $job= Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($val->job_id)->current();
                if($job->status ==2 && $job->deadline > date('Y-m-d H:i:s')){
                    $sum +=1;
                }
            }
            $industries_temp[$i]['industry_id']= $industry->industry_id;
            $industries_temp[$i]['name']= $industry->name;
            $industries_temp[$i]['sum']= $sum; 
            $i++;
        }
        //sap xep giam dan
        /*
        for($i=0; $i<count($industries_temp)-1; $i++){
            
          for($j = $i+1; $j>0; $j--){
            if($industries_temp[$j]['sum'] > $industries_temp[$j-1]['sum']){
                $temp = $industries_temp[$j];
                $industries_temp[$j] = $industries_temp[$j-1] ;
                $industries_temp[$j-1] = $temp;
            }
          }
        }
        */
        //Zend_Debug::dump($industries_temp);exit;
        $this->view->industries= $industries_temp;
        $this->view->industry= $industry_all;
    }
}