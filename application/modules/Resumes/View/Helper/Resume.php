<?php 

class Resumes_View_Helper_Resume extends Zend_View_Helper_Abstract
{
    public function resume($resume_id){
        $table = Engine_Api::_()->getDbtable('resumes', 'resumes');
        $row = $table->fetchRow($table->select()->where('resume_id = ?', $resume_id));
        if(count($row)){
            return $row;
        }
        //return $row;
    }
}