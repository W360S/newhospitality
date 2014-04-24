<?php 
class Recruiter_View_Helper_CategoryJob extends Zend_View_Helper_Abstract
{
    public function categoryJob($category_id){
        //get city
        $table = Engine_Api::_()->getDbtable('categories', 'recruiter');
        $row = $table->fetchRow($table->select()->where('category_id = ?', $category_id));
        return $row;
    }
}