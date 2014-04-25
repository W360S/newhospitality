<?php 
class School_Widget_HotelSchoolController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $table= Engine_Api::_()->getDbtable('schools', 'school');
        $select= $table->select()
                    ->order('view_count DESC')
                    ->limit(15)
                    ;
        $records= $table->fetchAll($select);
        $paginator = $this->view->paginator = Zend_Paginator::factory($records);
        
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(3);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        $paginator->setPageRange(5);
    }
}