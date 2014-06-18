<?php
class Library_Widget_TopViewsController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
        $this->view->data = Engine_Api::_()->library()->getTopViews();
    }
}