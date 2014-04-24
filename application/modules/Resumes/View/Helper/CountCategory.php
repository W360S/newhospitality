<?php 
class Resumes_View_Helper_CountCategory extends Zend_View_Helper_Abstract
{
    public function countCategory($category_id){
        
        $table = Engine_Api::_()->getDbtable('experiences', 'resumes');
        $row = $table->fetchAll(
                        $table
                            ->select()
                            ->distinct()
                            ->from($table,'resume_id')
                            ->where('category_id = ?', $category_id)                         
                            );
        
        $resume_ids = array();
        //Zend_Debug::dump($row);
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
            return count($resumes);
        }else{
            return 0;
        }
    }
}