<?php
/*
@author: huynhnv
@function: industry job

*/ 
class Recruiter_Widget_CategoriesController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
       
        $tableCategory= Engine_Api::_()->getDbtable('categories', 'recruiter');
        $table = Engine_Api::_()->getDbtable('reCategories', 'recruiter');
        $table_jobs= Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $select= $tableCategory->select();
        $categories= $tableCategory->fetchAll($select);
        $categories_temp= array();
        $i=0;
		if(count($categories)){
			foreach($categories as $category){
				$row = $table->fetchAll(
							$table
								->select()
								->where('category_id = ?', $category->category_id)
								->where('job_id > ?', 0)
								//->where('status =?', 2)
								);
				
				$sum= 0;
				
				if(count($row)){
					foreach($row as $val){
						
						$job= Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($val->job_id)->current();
						if(($job->status ==2) && ($job->deadline > date('Y-m-d'))){
							$sum +=1;
						}
					}
				}
				$categories_temp[$i]['category_id']= $category->category_id;
				$categories_temp[$i]['name']= $category->name;
				$categories_temp[$i]['sum']= $sum; 
				$i++;
			}
		}
        //sap xep giam dan
        //thử categories không sắp xếp giảm dần.
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
        $this->view->categories= $categories_temp;
    }
}