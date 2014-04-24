<?php 
class School_Widget_NewestCommentController extends Engine_Content_Widget_Abstract
{
    //newest comments home
    public function indexAction(){
        $tableArticle= Engine_Api::_()->getDbtable('articals', 'school');
        $tableComment= Engine_Api::_()->getDbtable('comments', 'school');
        $rName= $tableComment->info('name');
        $aName= $tableArticle->info('name');
        $select= $tableComment->select()
                    ->setIntegrityCheck(false)
                    ->from($rName)
                    ->distinct()
                    ->joinLeft($aName, $aName. ".artical_id = ". $rName . ".artical_id")       
                    ->where($aName.'.approved =?', 1)        
                    ->limit(4)
                    ->order($rName.'.created DESC');
        $comments= $tableComment->fetchAll($select);
		if(count($comments)==0){
            $this->setNoRender(true);
        }
        //Zend_Debug::dump($comments);exit;
        $this->view->comments= $comments;
    }
}