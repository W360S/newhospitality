<?php 
class School_Widget_TopSchoolController extends Engine_Content_Widget_Abstract
{
    //top school home
    public function indexAction(){
        $table= Engine_Api::_()->getDbtable('schools', 'school');
        $select= $table->select()
                    ->limit(10)
                    ->order('view_count DESC')
                    ->order('num_artical DESC');
        $schools= $table->fetchAll($select);
        $this->view->schools= $schools;
        
    }
}