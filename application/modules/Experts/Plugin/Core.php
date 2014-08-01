<?php

class Experts_Plugin_Core
{

  public function onUserDeleteBefore($event)
  {
    
    $payload = $event->getPayload();
    
    if( $payload instanceof User_Model_User ) {
      Engine_Api::_()->experts()->deleteQuestionAfferUserDeleted($payload->user_id);
      Engine_Api::_()->experts()->deleteExpertsByUser($payload->user_id);
      
    }
  }
  
}