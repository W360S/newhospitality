<?php


class Activitypoints_Api_Core extends Core_Api_Abstract
{

  public static $action_group_types =   array(  0  => 'Unknown / Uncategorized',
                                                1  => 'Group',
                                                2  => 'Poll',
                                                3  => 'Events',
                                                4  => 'Classifieds',
                                                5  => 'Blog',
                                                6  => 'Media / Albums',
                                                9  => 'Music',
                                                10 => 'Video',
                                                11 => 'Forum',
                                                12 => 'Experts',
                                                13 => 'Library',
                                                100  => 'General',
                                                101  => 'Signup / Marketing'
                                                );

  /*********************** MAIN "FINANCIAL" FUNCTIONS *********************/
  
  /*
   * Get current points balance
   *
   * @param $user_id user_id
   * @return int Current balance
   *
   */
  function getPointsBalance($user_id) {
    return Engine_Api::_()->getDbTable('points', 'activitypoints')->getBalance($user_id);
  }
  
  /*
   * Try deducting amount to see if user has enough points (points are NOT deducted)
   *
   * @param $user_id user_id
   * @param $amount
   *
   * @return bool Success or failure of points try deduction
   *
   */
  function tryDeductPoints($user_id, $amount) {
    return Engine_Api::_()->getDbTable('points', 'activitypoints')->tryDeduct($user_id, $amount);
  }
  
  
  /*
   * Deduct points
   *
   * @param $user_id User_id
   * @param $amount Amount to process
   * @param $allowNegativeCredit if to allow "overdraft" - negative credit
   *
   * @return bool Success or failure of points deduction
   *
   * @todo boundary condition: if allowNegativeCredit is true and no rows (i.e. 0 points) this will fail
   */
  function deductPoints($user_id, $amount, $allowNegativeCredit = false) {

    $success = Engine_Api::_()->getDbTable('points', 'activitypoints')->deduct($user_id, $amount, $allowNegativeCredit);
    
    if($success) {
      $this->updateStats( $user_id, "spend", $amount );
    }
    
    return $success;
  
  }
  
  /*
   * Add points
   *
   * @param $user_id user_id
   * @param $amount amount
   *
   *
   */
  function addPoints($user_id, $amount, $update_totalearned = true) {

    Engine_Api::_()->getDbTable('points', 'activitypoints')->add($user_id, $amount, $update_totalearned);

    if($update_totalearned) {
      $this->updateStats( $user_id, "earn", $amount );
    }
  
  }
  
  
  /*
   * Set points
   *
   * @param $user_id user_id
   * @param $amount amount
   *
   */
  function setPoints($user_id, $amount) {

    Engine_Api::_()->getDbTable('points', 'activitypoints')->set($user_id, $amount);
    
  }
  
  /*********************** CUSTOM "FINANCIAL" FUNCTIONS *********************/
  
  function tryDeductPointsByType($user_id, $type) {
    return Engine_Api::_()->getDbTable('points', 'activitypoints')->tryDeductByType($user_id, $type);
  }
  
  function tryDeductPointsById($user_id, $id) {
    return Engine_Api::_()->getDbTable('points', 'activitypoints')->tryDeductById($user_id, $type);
  }
  
  function deductPointsByType($user_id, $type, $allowNegativeCredit = false) {
    return Engine_Api::_()->getDbTable('points', 'activitypoints')->deductByType($user_id, $type);
  }
  
  /*********************** STATISTICS FUNCTIONS *********************/
  
  function updateStats($user_id, $type, $amount = 1) {
  
    if(Semods_Utils::getSetting('activitypoints.enable_statistics')) {
      Engine_Api::_()->getDbTable('stats', 'activitypoints')->update($user_id, $type, $amount);
    }
  
  }
  
  
  /*********************** CUSTOM FUNCTIONS *********************/
  
  
  /*
   * retrieves user rank, based on total earned points
   * @param user_id
   * @return int user rank
   *
   */
  function getRank($user_id) {
  
  /*
    // SLOWER but more exact ranking, 2 queries required. Each call is rebuilding the whole table
  
    ( "SET @rownum := 0" );
    ( "SELECT rank FROM (
                  SELECT @rownum := @rownum+1 AS rank, userpoints_user_id
                  FROM se_semods_userpoints
                  ORDER BY  userpoints_count DESC, userpoints_user_id
                ) AS rank_table WHERE userpoints_user_id=$user_id
              ")
  */
  
  /*
    // FAST. This query shares the place for equal score and "floors" shared rank
    return ( "SELECT COUNT(*)+1 AS rank
              FROM se_semods_userpoints
              WHERE userpoints_totalearned >= (SELECT userpoints_totalearned FROM se_semods_userpoints WHERE userpoints_user_id=$user_id)" );
  */
  
  
  /*
   * user   points    rank
   * user1  1000      1
   * user2  500       2
   * user3  500       2
   * user4  400       4
   * user5  0         5
   * user5  0         5
   *
   */

    return Engine_Api::_()->getDbTable('points', 'activitypoints')->getRank($user_id);
  
  }
  
  
  /*********************** MAIN REWARDING FUNCTION *********************/
  
  // This function deduct user for specific action, with limits per action(defalt limit = 0), added by quangnvh
  function minusPoints($user_id, $type, $amount = 1) {

    global $activitypoints_disable_hooks;
    
    if(isset($activitypoints_disable_hooks) && $activitypoints_disable_hooks) {
      return;
    }  

    $table = Engine_Api::_()->getDbTable('counters', 'activitypoints');

    $result = $table->quotas( array('type'                => $type,
                                    'user_id'             => $user_id,
                                    'amount'              => -$amount,
                                    )
                            );

    if($result == Activitypoints_Model_DbTable_Counters::$ADDING_SUCCESS) {
      $this->addPoints($user_id, $table->_points_to_add);

      // Transaction 
      if(Semods_Utils::getSetting('activitypoints.enable_microtransactions')) {

        Engine_Api::_()->getDbTable('transactions','activitypoints')->add( $user_id,
                                    1,  // type - microtransaction,
                                    1,  // cat "earner"
                                    0,  // state - completed
                                    $table->_action_data['action_name'],
                                    $table->_points_to_add
                                   );

      }
      
    }

  }
  
  //this function for download book
  function downloadBook($user_id, $amount){
    
    // get current point
    $rTable = Engine_Api::_()->getDbTable('points', 'activitypoints');
     
    $rName = $rTable->info('name');
    $user_point = $rTable->fetchRow("userpoints_user_id = '" . $user_id ."'");
    if($user_point->userpoints_count >= $amount){
        // update point
        $this->addPoints($user_id, -$amount);
        return true;
    } else {
        return false;
    }
    
  }
  
  
  // THIS FUNCTION REWARDS USER FOR SPECIFIC ACTION, WITH LIMITS PER ACTION
  function updatePoints($user_id, $type, $amount = 1) {

    global $activitypoints_disable_hooks;
    
    if(isset($activitypoints_disable_hooks) && $activitypoints_disable_hooks) {
      return;
    }  

    $table = Engine_Api::_()->getDbTable('counters', 'activitypoints');

    $result = $table->quotas( array('type'                => $type,
                                    'user_id'             => $user_id,
                                    'amount'              => $amount,
                                    )
                            );

    if($result == Activitypoints_Model_DbTable_Counters::$ADDING_SUCCESS) {
      $this->addPoints($user_id, $table->_points_to_add);
      
      // Transaction 
      if(Semods_Utils::getSetting('activitypoints.enable_microtransactions')) {

        Engine_Api::_()->getDbTable('transactions','activitypoints')->add( $user_id,
                                    1,  // type - microtransaction,
                                    1,  // cat "earner"
                                    0,  // state - completed
                                    $table->_action_data['action_name'],
                                    $table->_points_to_add
                                   );

      }
      return true;
    } else {
      return false;
    }

  }

  
  function getPoints($user_id) {
    return Engine_Api::_()->getDbTable('points', 'activitypoints')->get($user_id);
  }
  
  /*********************** THE MIGHTY TRANSFERRING FUNCTION *********************/
  
  // THIS FUNCTION TRANSFERS POINTS FROM ONE USER TO ANOTHER
  function transferPoints(&$sender, $receiver_id, $amount) {
  
  
    $is_error = 0;
    $message = '';
  
    $receiver_id = intval($receiver_id);
    $amount = intval($amount);
    
    $permissionsTable = Engine_Api::_()->getDbtable('permissions', 'authorization');

    $table = Engine_Api::_()->getDbTable('counters', 'activitypoints');

    $db = Engine_Db_Table::getDefaultAdapter();
  
    try {

      if(($permissionsTable->getAllowed('activitypoints', $sender->level_id, 'use') == 0) || ($permissionsTable->getAllowed('activitypoints', $sender->level_id, 'allow_transfer') == 0)) {
        $is_error = 1;
        $message = 100016061;
        throw new Exception();
      }
  
      // check points
      if(!($amount > 0)) {
        $is_error = 1;
        $message = 100016058;
        throw new Exception();
      }
  
      // check receiver exists
      $ruser = Engine_Api::_()->user()->getUser($receiver_id);
      
      if((!$ruser instanceof User_Model_User) || !$ruser->getIdentity()) {
        $is_error = 1;
        $message = 100016059;
        throw new Exception();
      }

      // can't transfer to self
      if($sender->getIdentity() == $ruser->getIdentity()) {
        $is_error = 1;
        $message = 100016059;
        throw new Exception();
      }  

      $db->beginTransaction();
  
      $max_points_per_user_level = $permissionsTable->getAllowed('activitypoints', $sender->level_id, 'max_transfer');
      $max_receive_points_per_user_level = $permissionsTable->getAllowed('activitypoints', $ruser->level_id, 'max_receive');

      // check points quota / limitations - sending
      if( $max_points_per_user_level != 0 ) {

        $result = $table->quotas( array('type'                => 'transferpoints',
                                        'user_id'             => $sender->getIdentity(),
                                        'amount'              => 1,
                                        'update_total_earned' => false,
                                        'allow_partial'       => false,
                                          
                                        // override
                                        'action_pointsmax'    => $max_points_per_user_level,
                                        'action_points'       => $amount,
                                        )
                                );

        switch($result) {
          
          case Activitypoints_Model_DbTable_Counters::$ADDING_MORE_THAN_MAX;
            $message = sprintf( Zend_Registry::get('Zend_Translate')->_( "100016062" ), $max_points_per_user_level );
            $is_error = 1;
            throw new Exception();
            break;

          case Activitypoints_Model_DbTable_Counters::$ADDING_PARTIAL;
            $message = sprintf( Zend_Registry::get('Zend_Translate')->_( "100016062" ), $table->_partial_amount );
            $is_error = 1;
            throw new Exception();
            break;

          case Activitypoints_Model_DbTable_Counters::$ADDING_LIMIT_REACHED;
            $message = 100016063;
            $is_error = 1;
            throw new Exception();
            break;
          
        }
  
      }

      // check points quota / limitations - receiving
      if( $max_receive_points_per_user_level != 0 ) {

        $result = $table->quotas( array('type'                => 'receivepoints',
                                        'user_id'             => $ruser->getIdentity(),
                                        'amount'              => 1,
                                        'update_total_earned' => false,
                                        'allow_partial'       => false,
                                          
                                        // override
                                        'action_pointsmax'    => $max_receive_points_per_user_level,
                                        'action_points'       => $amount,
                                        )
                                );

        switch($result) {
          
          case Activitypoints_Model_DbTable_Counters::$ADDING_MORE_THAN_MAX;
            $message = sprintf( Zend_Registry::get('Zend_Translate')->_( "ACTIVITYPOINTS_TRANSFER_MAX_RECEIVE" ), $max_receive_points_per_user_level );
            $is_error = 1;
            throw new Exception();
            break;

          case Activitypoints_Model_DbTable_Counters::$ADDING_PARTIAL;
            $message = sprintf( Zend_Registry::get('Zend_Translate')->_( "ACTIVITYPOINTS_TRANSFER_MAX_RECEIVE" ), $table->_partial_amount );
            $is_error = 1;
            throw new Exception();
            break;

          case Activitypoints_Model_DbTable_Counters::$ADDING_LIMIT_REACHED;
            $message = Zend_Registry::get('Zend_Translate')->_( "ACTIVITYPOINTS_TRANSFER_MAX_QUOTA" );
            $is_error = 1;
            throw new Exception();
            break;
          
        }
  
      }
  
  
      /*** TRY TRANSFERRING POINTS ***/
  
      // check points left
      if(!$this->deductPoints( $sender->getIdentity(), $amount ) ) {
        $is_error = 1;
        $message = 100016057;
        throw new Exception();
      }
  
      $this->addPoints( $receiver_id,
                      $amount,
                      false // do not update "total points earned"
                    );
  
      // Transaction - Sender
      $transaction_id = Engine_Api::_()->getDbTable('transactions','activitypoints')->add( $sender->getIdentity(),
                                                    0,  // type,
                                                    2,  // cat "spender"
                                                    0,  // state - completed
                                                    Zend_Registry::get('Zend_Translate')->_("100016064") . " <a href=\"{$ruser->getHref()}\">{$ruser->getTitle()}</a>",
                                                    -$amount
                                                   );
  
      // Transaction - Receiver
      $transaction_id = Engine_Api::_()->getDbTable('transactions','activitypoints')->add( $receiver_id,
                                                    0,  // type
                                                    1,  // cat "earner"
                                                    0,  // state - completed
                                                    Zend_Registry::get('Zend_Translate')->_("100016065") . "  <a href=\"{$sender->getHref()}\">{$sender->getTitle()}</a>",
                                                    $amount
                                                   );
  
      // notify receiver
      $notifyApi = Engine_Api::_()->getDbtable('notifications', 'activity');
      $notifyApi->addNotification($ruser, $sender, $sender, 'points_sent', array(
        'amount' => $amount
      ));


      $message = 100016060;

      $db->commit();
      
    } catch( Exception $ex ) {

      $db->rollBack();
      
    }
  
    if(is_numeric($message)) {
      $message = Zend_Registry::get('Zend_Translate')->_( $message );
    }

    return array( 'is_error' => $is_error, 'message' => $message );
  
  }

  /*********************** CUSTOM FUNCTIONS *********************/
  function transactionLibrary($user_id, $msg, $amount=0){
    return Engine_Api::_()->getDbTable('transactions','activitypoints')->add( $user_id,
                                            0,  // type,
                                            2,  // cat "spender"
                                            0,  // state - completed
                                           $msg,
                                            -$amount
                                           );
  } 
    
}