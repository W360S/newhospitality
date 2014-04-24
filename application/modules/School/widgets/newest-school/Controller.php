<?php 
class School_Widget_NewestSchoolController extends Engine_Content_Widget_Abstract
{
    //newest school home
    public function indexAction(){
        $table= Engine_Api::_()->getDbtable('schools', 'school');
        $select= $table->select()
                    ->limit(5)
                    ->order('created DESC')
                    ;                    
        $schools= $table->fetchAll($select);
        $this->view->schools= $schools;
    }
}