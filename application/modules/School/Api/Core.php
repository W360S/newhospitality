<?php

class School_Api_Core extends Core_Api_Abstract
{
    //delete image
    function deleteImages($images){
        $path = APPLICATION_PATH . DIRECTORY_SEPARATOR;
        if(count($images)){
          $db = Engine_Db_Table::getDefaultAdapter();
          $db->beginTransaction();
            
          try
          {
           foreach($images as $item){
              $storage = Engine_Api::_()->getDbtable('files', 'storage')->find($item['file_id'])->current();
              $storage->delete();
              @unlink($path . $item['storage_path']);
           }
           $db->commit();
           
          }
          catch( Exception $e )
          {
            $db->rollBack();
            throw $e;
          } 
        }
    }
    public function deleteArtical($school_id, $user_id){
        $table= Engine_Api::_()->getDbtable('articals', 'school');
        $select= $table->select()
                    ->where('school_id =?', $school_id)
                    //->where('user_id =?', $user_id)
                    ;
        $articals= $table->fetchAll($select);
        if(count($articals)){
            foreach($articals as $artical){
                //delete comments
                Engine_Api::_()->getApi('core', 'school')->deleteComment($artical->artical_id);
                //delete ratings
                Engine_Api::_()->getApi('core', 'school')->deleteRatingArtical($artical->artical_id);
                $artical->delete();
            }
        }
    }
    public function ratingCount($artical_id){
        $table  = Engine_Api::_()->getDbTable('ratings', 'school');
        $rName = $table->info('name');
        $select = $table->select()
                        ->from($rName)
                        ->where($rName.'.artical_id = ?', $artical_id);
        $row = $table->fetchAll($select);
        $total = count($row);
        return $total;
  }
  public function checkRated($artical_id, $user_id)
  {
    $table  = Engine_Api::_()->getDbTable('ratings', 'school');

    $rName = $table->info('name');
    $select = $table->select()
                 ->setIntegrityCheck(false)
                    ->where('artical_id = ?', $artical_id)
                    ->where('user_id = ?', $user_id)
                    ->limit(1);
    $row = $table->fetchAll($select);
    
    if (count($row)>0) return true;
    return false;
  }
  public function getRatings($artical_id)
  {
    $table  = Engine_Api::_()->getDbTable('ratings', 'school');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.artical_id = ?', $artical_id);
    $row = $table->fetchAll($select);
    return $row;
  }
  public function setRating($artical_id, $user_id, $rating){
    $table  = Engine_Api::_()->getDbTable('ratings', 'school');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.artical_id = ?', $artical_id)
                    ->where($rName.'.user_id = ?', $user_id);
    $row = $table->fetchRow($select);
    if (empty($row)) {
      // create rating
      Engine_Api::_()->getDbTable('ratings', 'school')->insert(array(
        'artical_id' => $artical_id,
        'user_id' => $user_id,
        'rating' => $rating
      ));
    }
  }
  // get other articals
    function getArticals($school_id){
        $table = Engine_Api::_()->getItemTable('school_artical');
		
		
	    $select2 = $table->select()
			  //->from($table,new Zend_Db_Expr('artical_id, title, photo_id'))
			  ->order('created DESC')                        
			  
			  ->where('school_id =?', $school_id)
			  ->where('approved =?', 1)
			  ->limit(10);
	    $new = $table->fetchAll($select2);
        
	    return array("new"=>$new);
	    
    }
    public function deleteComment($artical_id){
        $table= Engine_Api::_()->getDbtable('comments', 'school');
        $select= $table->select()
                ->where('artical_id =?', $artical_id)
        ;
        $comments= $table->fetchAll($select);
        if(count($comments)){
            foreach($comments as $comment){
                $comment->delete();
            }
        }
    }
    public function deleteRatingArtical($artical_id){
        $table= Engine_Api::_()->getDbtable('ratings', 'school');
        $select= $table->select()
                ->where('artical_id =?', $artical_id)
        ;
        $ratings= $table->fetchAll($select);
        if(count($ratings)){
            foreach($ratings as $rating){
                $rating->delete();
            }
        }
    }
    //xoa activity
    public function deleteSchoolActivity($school_id){
        $table= Engine_Api::_()->getDbtable('actions', 'activity');
        $select= $table->select()->where('type =?', 'school_new')
                                ->where('object_type =?', 'school')
                                ->where('object_id =?', $school_id);
        $row= $table->fetchRow($select);
        return $row;
                                
    }
    public function deleteCommentSchool($action_id){
        $table= Engine_Api::_()->getDbtable('comments', 'activity');
        $select= $table->select()
                                ->where('resource_id =?', $action_id);
                               
        $rows= $table->fetchAll($select);
        if(count($rows)){
            foreach($rows as $row){
                $row->delete();
            }
        }
      
    }
}   