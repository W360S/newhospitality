<?php 
class School_Widget_TopArticleController extends Engine_Content_Widget_Abstract
{
    //top articles home
    public function indexAction(){
        $table= Engine_Api::_()->getDbtable('articals', 'school');
        $select= $table->select()
                    ->where('approved =?', 1)
                    ->limit(3)
                    ->order('total DESC')
                    ->order('comment_count DESC');
        $articles= $table->fetchAll($select);
		if(count($articles)==0){
            $this->setNoRender(true);
        }
        $this->view->articles= $articles;
    }
}