<?php

class Experts_Widget_SearchController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    $url = Zend_Controller_Front::getInstance()->getRequest();
    //Zend_Debug::dump($url);
    $arr_cats = array();
    if(intval($url->cats) !=0){
        $arr_cats = explode(",",$url->cats);
    }
    $this->view->arr_cats= $arr_cats;
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'experts');
    $select = $categoryTable->select()
      ->order('priority ASC');
    $categories = $categoryTable->fetchAll($select);
    $this->view->categories = $categories;
  }
}