<?php 
class Resumes_View_Helper_CountExperience extends Zend_View_Helper_Abstract
{
    public function countExperience($resume_id){
        $table_experience = Engine_Api::_()->getDbTable('experiences','resumes');
        $select= $table_experience->select()
                        ->from($table_experience)
                        ->where('resume_id =?', $resume_id)
                        ;
        $rows= $table_experience->fetchAll($select);
        if(count($rows)){
            $sum= 0;
            foreach($rows as $row){
                $sum += $row->num_year;
            }
        }
        return $sum;
    }
}