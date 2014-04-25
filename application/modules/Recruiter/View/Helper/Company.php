<?php 
class Recruiter_View_Helper_Company extends Zend_View_Helper_Abstract
{
    public function company($user_id){
        $table = Engine_Api::_()->getDbtable('recruiters', 'recruiter');
        $row = $table->fetchRow($table->select()->where('user_id = ?', $user_id));
        if(count($row)){
            return $row;
        }
        else{ 
            return "";
        }
        
    }
}