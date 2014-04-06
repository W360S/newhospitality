<?php
class Event_Widget_MyCategoriesController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        
        $category = Engine_Api::_()->event()->getMyCategory($user_id);
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