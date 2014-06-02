<?php
/*
    @date: 30.03.12
    @package: Statistics
    @funtion: Display panel left
    @company: Green Global
    @author: huynhnv
    @addres: 24 Le Dinh Duong, Hai Chau, Da Nang
*/
class Statistics_Widget_PanelLeftController extends Engine_Content_Widget_Abstract{
    
    public function indexAction(){
        $alias= Zend_Controller_Front::getInstance()->getRequest();
        $this->view->alias= $alias->getParam('slug');
        //load category to panel left menu
        $category_table= Engine_Api::_()->getDbTable('categories', 'statistics');
        $select= $category_table->select()->order('priority ASC');
        $categories= $category_table->fetchAll($select);
        $this->view->categories= $categories;
    }
}