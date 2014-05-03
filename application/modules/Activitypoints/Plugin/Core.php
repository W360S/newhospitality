<?php

class Activitypoints_Plugin_Core
{

  public function onSemodsAddActivity($event)
  {

    $payload = $event->getPayload();
    
    $user = $payload['subject'];
    $actiontype_name = $payload['type'];

    $api = Engine_Api::_()->getApi('core', 'activitypoints');
  
    // TBD - special treatments,
     $excluded_actions = array();

     if(!in_array($actiontype_name, $excluded_actions)) {
        $api->updatePoints( $user->getIdentity(), $actiontype_name );
     }
    
  }
  

  public function onFriendsinviterRefer($event) {
    
    $payload = $event->getPayload();

    $referrer = $payload['referrer'];
    $new_user = $payload['new_user'];
    
    Engine_Api::_()->activitypoints()->updatePoints( $referrer->getIdentity(), "refer" );
    
  }

  public function onFriendsinviterStats($event) {
    
    $payload = $event->getPayload();
    
    $user_id = isset($payload['user']) ? $payload['user']->getIdentity() : $payload['user_id'];
    $invites_count = $payload['invites_count'];
    
    Engine_Api::_()->activitypoints()->updatePoints( $user_id, "invite", $invites_count );
    
  }
  

  public function onAlbumCreateAfter($event)
  {
    $user = Engine_Api::_()->user()->getViewer();
    $actiontype_name = 'newalbum';

    Engine_Api::_()->getApi('core', 'activitypoints')->updatePoints( $user->getIdentity(), $actiontype_name );
    
  }

  public function onCoreLikeCreateAfter($event)
  {
    
    $user = Engine_Api::_()->user()->getViewer();
    $actiontype_name = 'like';

    Engine_Api::_()->getApi('core', 'activitypoints')->updatePoints( $user->getIdentity(), $actiontype_name );
    
  }
  

  public function onForumTopicCreateAfter($event)
  {

    $user = Engine_Api::_()->user()->getViewer();
    $actiontype_name = 'forum_topic';

    Engine_Api::_()->getApi('core', 'activitypoints')->updatePoints( $user->getIdentity(), $actiontype_name );
    
  }

  public function onForumPostCreateAfter($event)
  {

    $user = Engine_Api::_()->user()->getViewer();
    $actiontype_name = 'forum_post';

    Engine_Api::_()->getApi('core', 'activitypoints')->updatePoints( $user->getIdentity(), $actiontype_name );
    
  }
  

  public function onMessagesMessageCreateAfter($event)
  {
    $payload = $event->getPayload();
    //Zend_Debug::dump($payload); exit;
    $user = Engine_Api::_()->user()->getViewer();
    $actiontype_name = 'message';

    $result = Engine_Api::_()->getApi('core', 'activitypoints')->updatePoints( $user->getIdentity(), $actiontype_name );
    
    
  }

  public function onMusicSongCreateAfter($event)
  {
  
    $user = Engine_Api::_()->user()->getViewer();
    $actiontype_name = 'newmusic';
  
    Engine_Api::_()->getApi('core', 'activitypoints')->updatePoints( $user->getIdentity(), $actiontype_name );
    
  }

  //public function onVideoRatingCreateAfter($event)
  //{
  //
  //  $user = Engine_Api::_()->user()->getViewer();
  //  $actiontype_name = 'video_rate';
  //
  //  Engine_Api::_()->getApi('core', 'activitypoints')->updatePoints( $user->getIdentity(), $actiontype_name );
  //  
  //}
  
  public function onExpertsQuestionCreateAfter($event)
  {
    $payload = $event->getPayload();
    //Zend_Debug::dump($event); exit;
    $user = Engine_Api::_()->user()->getViewer();
    $actiontype_name = 'create_question';
    
    $result = Engine_Api::_()->getApi('core', 'activitypoints')->updatePoints( $user->getIdentity(), $actiontype_name );
    
    if($result){
       Engine_Api::_()->experts()->setUpdatePoint($payload->question_id);
    }
    
  }
  
  public function onExpertsQuestionUpdateAfter($event)
  {
    $payload = $event->getPayload();
    // Kiem tra neu cau hoi duoc cancel thi tru diem
    if(($payload->status == 4) && ($payload->update_point == 1)) {
        $user = Engine_Api::_()->user()->getViewer();
        $actiontype_name = 'cancel_question';    
        Engine_Api::_()->getApi('core', 'activitypoints')->minusPoints( $user->getIdentity(), $actiontype_name );
    }    
    
  }
  
  public function onExpertsQuestionDeleteBefore($event)
  {
    $payload = $event->getPayload();
    // Kiem tra neu cau hoi chua duoc tru diem thi tru diem
    if(($payload->status != 4) && ($payload->update_point == 1)) {
        $user = Engine_Api::_()->user()->getViewer();
        $actiontype_name = 'delete_question';
        
        Engine_Api::_()->getApi('core', 'activitypoints')->minusPoints( $user->getIdentity(), $actiontype_name );
    }    
        
  }
  
  public function onLibraryBookUpdateBefore($event){
    //Zend_Debug::dump($event); exit;
    //$payload = $event->getPayload();
    // Kiem tra neu cau hoi chua duoc tru diem thi tru diem
    
    //return ;
    
  }
  
  
  public function onUserDeleteBefore($event)
  {
  
    $payload = $event->getPayload();
    if( $payload instanceof User_Model_User ) {

      // Remove counters
      Engine_Api::_()->getDbtable('counters', 'activitypoints')->delete( array('userpointcounters_user_id = ?' => $payload->getIdentity() ) );
    
      // Remove transactions
      Engine_Api::_()->getDbtable('transactions', 'activitypoints')->delete( array('uptransaction_user_id = ?' => $payload->getIdentity() ) );
    
      // Remove user points
      Engine_Api::_()->getDbtable('points', 'activitypoints')->delete( array('userpoints_user_id = ?' => $payload->getIdentity() ) );
      
    }
  }
  
  
  
}