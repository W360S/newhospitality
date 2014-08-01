<?php 
class Experts_View_Helper_Expert extends Zend_View_Helper_Abstract
{
    public function expert($user_id){
      
        $table = Engine_Api::_()->getDbtable('experts', 'experts');
        $row = $table->fetchRow($table->select()->where('user_id = ?', $user_id));
        return $row;
    }
}