<?php
class Group_Widget_CategoriesController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
        $category = Engine_Api::_()->group()->getBrowseCategory();
        //Zend_debug::dump($category); exit;
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