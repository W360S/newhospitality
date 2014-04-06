<?php
class Event_Widget_CategoriesController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
        
        $front = Zend_Controller_Front::getInstance();
        //$module = $front->getRequest()->getModuleName();
		//$action = $front->getRequest()->getActionName();
		//$controller = $front->getRequest()->getControllerName();
        $param = $front->getRequest()->getParams();
       
        if(isset($param['filter']) && ($param['filter'] == 'past')){
            $category = Engine_Api::_()->event()->getPastCategory();
        } else {
            $category = Engine_Api::_()->event()->getFutureCategory(); 
        } 
        $this->view->data = $category;
        $request=  Zend_Controller_Front::getInstance()->getRequest();
        $category_id= $request->category_id;
        $tmp= $request->getParams();
        if(key_exists("amp;category_id",$tmp))
        {
            $category_id = $tmp["amp;category_id"];
        }
        $this->view->category_id= $category_id;

    }
}