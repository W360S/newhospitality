<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: core.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Api_Core extends Core_Api_Abstract
{
	// -------------------------------------- FUNCTION START FOR PEOPLE YOU MAY KNOW -------------------------------
	protected $_suggestion_distance;
	protected $_suggestion_previous;
	/**
   * @var Number of entries to be shown in the suggestion box
   */
	protected $_count_stag;
	protected $_temp_suggestion_users_id_array;
	protected $_final_key_array;
	protected $_reject_user_entity_id;
	protected $_userhome_display_array;
	protected $_first_level_user_array;
	protected $_network_ids;

	/**
   * Returns the members being displayed in the widget currently : Friends suggestion/AJAX
   *
   * @param $user: The user to get the suggestions for
   * @param $suggestion_level: The level depth till which friends are to be suggested
   * @param $display_user_str: The string having user IDs of users currently being suggested
   * @param $number_of_users: The number having of require users.
   * @return Array
   */
	public function suggestion_path($userid, $suggestion_level, $display_user_str, $number_of_users)
	{
		$suggestion_output = array();
		$this->_reject_user_entity_id = array();

		// WE ASSIGN $level = 1 TO DIRECT CONNECTED FRIENDS.
		$level = 1;
		// Assign blank array becouse that function call by "few frind" function recursivly.
		if(!empty($this->_temp_suggestion_users_id_array))
		{
			$this->_count_stag = '';
			$this->_temp_suggestion_users_id_array = array();
			$this->_suggestion_distance = array();
			$this->_suggestion_previous = array();
			$this->_reject_user_entity_id = array();
			$this->_userhome_display_array = array();
			$this->_final_key_array = array();
		}
		$this->_suggestion_distance[$userid] = 0;
		//$INDEX IS THE NUMBER FROM WHERE FOR LOOP STARTS IN find_distance_previous_array FUNCTION.
		$index = 0;
		$this->_temp_suggestion_users_id_array[] = $userid;

		//FETCH ID OF REJECT USER.
		$rejectTable = Engine_Api::_()->getItemTable('rejected');
		$rejectSelect = $rejectTable->select()
		->from($rejectTable, array('entity_id'))
		->where('owner_id = ?', $userid)
		->where('entity = ?', 'friend');
		$reject_user_entity_id_array = $rejectSelect->query()->fetchAll();
		foreach($reject_user_entity_id_array as $reject_user)
		{
			//Array which hold all the restricted entity id
			$this->_reject_user_entity_id[] = $reject_user['entity_id'];
		}

		//IF ADMIN SET NETWORK Members SETTING FOR ALLOWING FRIENDS.
		if (Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 1)
		{
			$this->find_network_friend($userid, $number_of_users);
			return $this->_final_key_array;
		}

		//IF ADMIN SET "All Members" SETTING FOR ALLOWING FRIENDS.
		elseif (Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 2)
		{
			while($level != $suggestion_level) {
				$index = $this->find_distance_suggestion_previous_array($this->_temp_suggestion_users_id_array, $index, $level, $display_user_str, $number_of_users);
				$level++;
				if(empty($index) || count($this->_temp_suggestion_users_id_array) == 1) {
					break;
				}
			}
		}
		//IF ADMIN SET NONE Members SETTING FOR ALLOWING FRIENDS.
		elseif (Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 0)
		{
			return ;
		}

		// This is the condition for If admin set "NOBODY BECOME FRIEND" then we return else we will find more friend in the user network.
		//Codition for network search
		if(count($this->_final_key_array) != $number_of_users)
		{
			$number_of_network_fri = $number_of_users - count($this->_final_key_array);
			$this->find_network_friend($userid, $number_of_network_fri, $display_user_str);
			// If there are no friend suggestion in 2nd level & 3rd level or in network then we show suggestion randumly, only if site admin set the friend setting - "All member"
			if(count($this->_final_key_array) != $number_of_users)
			{
				$number_of_network_fri = $number_of_users - count($this->_final_key_array);
				$this->find_randum_friend_suggestion($userid, $number_of_network_fri, $display_user_str);
				return $this->_final_key_array;
			}
			else {
				return $this->_final_key_array;
			}
		}
		else
		{
			return $this->_final_key_array;
		}
	}


	/**
   * Returns the index and user lavel array with current level friend.
   *
   * @param $temp_suggestion_users_id_array_1: Array which hold the user of the level as a value
   * @param $first_index:Starting number of for loop.
   * @param $level: The level depth till which friends are to be suggested
   * @param $display_user_str: The string having user IDs of users currently being suggested
   * @param $number_of_users: The number having of require users.
   * @return Integer
   */
	public function find_distance_suggestion_previous_array($temp_suggestion_users_id_array_1, $first_index, $level, $display_user_str, $number_of_users)
	{
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();// Current user id.
		$this->_userhome_display_array = array();
		// 3 USERS TO BE RETURNED IN CASE OF COMPLETE WIDGET RENDER
		if($display_user_str == '')
		{
			$this->_userhome_display_array[] = 0;
		}
		else
		{
			// ONLY ONE SUGGESTION TO BE RETURNED IS CALLED THROUGH AJAX
			$suggestion_expload_array = explode(",", $display_user_str);
			$this->_userhome_display_array[] = $suggestion_expload_array;
		}

		$current_user = $temp_suggestion_users_id_array_1[0];
		$index = count($temp_suggestion_users_id_array_1);

		for($x = $first_index; $x < $index; $x++)
		{
			$friend_1_id = $temp_suggestion_users_id_array_1[$x];

			//FETCH USER MEMBER FROM MEMBERSHIP TABLE
			$table = Engine_Api::_()->getDbtable('membership', 'user');
			$user_table = Engine_Api::_()->getItemTable('user');
			$network_table = Engine_Api::_()->getDbtable('membership', 'network');
			$iName = $table->info('name');
			$uName = $user_table->info('name');
			$nName = $network_table->info('name');

			$select = $table->select()
				->setIntegrityCheck(false)
				->from($iName, array('resource_id'))
				->joinLeft($uName, "$uName.user_id = $iName.user_id")
				->where($iName . '.resource_id = ?', $friend_1_id)
				->where($uName . '.verified = ?', 1)
				->where($iName . '.active = ?', 1)
				->where($uName . '.enabled = ?', 1)
				->order('RAND()');
			$fetch_record = $table->fetchAll($select);

			$ides = array();
			$level_suggestion_set = $level;

			foreach( $fetch_record as $row )
			{
				$ides[] = $row->user_id;
				$friend_id = $row->user_id;
				if((!empty($temp_suggestion_users_id_array_1['0']) && $friend_id != $temp_suggestion_users_id_array_1['0']) && (((!empty($this->_suggestion_distance[$friend_id]) &&  $this->_suggestion_distance[$friend_id] > $level) || empty($this->_suggestion_distance[$friend_id]))))
				{
					if($level == 1)
					{
						$this->_temp_suggestion_users_id_array[] = $friend_id;
						$this->_suggestion_distance[$friend_id] = $level;
						$this->_suggestion_previous[$friend_id] = $friend_1_id;
					}
					//IF LEVEL NOT 1
					else
					{
						$this->_temp_suggestion_users_id_array[] = $friend_id;
						$this->_suggestion_distance[$friend_id] = $level;
						$this->_suggestion_previous[$friend_id] = $friend_1_id;
						//COMPARE USER ID FROM REJECTED USER ARRAY
						if((in_array("$friend_id", $this->_reject_user_entity_id)))
						{
							continue;
						}
						else
						{
							// Here we match friend that friend should be active.
							$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
							$table_name = $membership_table->info('name');
							$select = $membership_table->select()
								->from($table_name, array('active'))
								->where($table_name . '.resource_id = ?', $user_id)
								->where($table_name . '.user_id = ?', $friend_id);
							$active = $select->query()->fetchAll();
							// "active" should be NULL if active = 0 then resource have friend request already and if active = 1 then user already frind of resource.
							if(empty($active) && $active != 0)
							{
								if($this->_userhome_display_array[0] != 0)
								{
									//COMPARE USER ID FROM ARRAY DISPLAY USER IN USERHOME PAGE
									if((in_array("$friend_id", $this->_userhome_display_array[0])))
									{
										continue;
									}
									else
									{
										$this->_count_stag++;
										$this->_final_key_array[] = $friend_id;
										if($this->_count_stag == $number_of_users)
										{
											return;
										}
									}
								}
								else
								{
									$this->_count_stag++;
									$this->_final_key_array[] = $friend_id;
									if($this->_count_stag == $number_of_users)
									{
										return;
									}
								}
							}
							else {
								continue;
							}
						}
					}
				}
			}
		}
		return $index;
	}


	/**
	 * Return the user's friends to be suggested during "Add as a Friend" and "Accept Friend Request". This confirms to Admin settings for Friendships (within network, etc.)
	 *
	 * @param $userid: User which are login.
	 * @param $friend_id: user id which are perform any event.
	 * @param $suggestion_level: The level depth till which friends are to be suggested
	 * @param $display_user_str: The string which which have display user info.
	 * @param $number_of_users: The number having of require users.
	 * @param $page: The name from where this function call.
	 * @return array
	 */
	public function add_friend_suggestion($userid, $friend_id, $display_user_str, $number_of_users, $page, $search)
	{
		//Find friend id and user id for accept and send friend request.
		if(($page == 'accept_request') && ($friend_id != 0))
		{
			$assign_friend_id = $userid;
			$assign_user_id = $friend_id;
		}
		else
		{ // In case of "Add as a Friend"
			$assign_friend_id = $friend_id;
			$assign_user_id = $userid;
		}

		if(empty($display_user_str))
		{
			$display_user_str = 0;
		}
		if(empty($this->_network_ids))
		{
			$this->_network_ids = 0;
		}

		$this->_first_level_user_array = array();
		$this->_reject_user_entity_id = array();
		//Array hold the display user info.
		$suggestion_expload_array = array();

		$this->_suggestion_distance[$userid] = 0;
		$this->_temp_suggestion_users_id_array[] = $userid;

		//FETCH MEMBER FOR USER.
		//IF ADMIN SET "All Members" SETTING FOR ALLOWING FRIENDS.
		if(Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 2)
		{
			$friend_table = Engine_Api::_()->getDbtable('membership', 'user');
			$friend_name = $friend_table->info('name');
			if($search == 'show_friend_suggestion')
			{
			  // @todo: Use database query.
			  $friend_select = $friend_table->select()
					->from(array("eum1" => $friend_name), array('user_id'))
					->where('eum1.resource_id = ?', $assign_user_id)
					->where('eum1.user_id != ?', $assign_friend_id )
					->where('eum1.user_approved = ?', 1)
					->where('eum1.active = ?', 1)
					->where('eum1.resource_approved = ?', 1)
					->where('NOT EXISTS (SELECT eum.user_id FROM `engine4_user_membership` eum WHERE eum.resource_id=' . $assign_friend_id . ' AND eum.user_id = eum1.user_id)') // Users should not be friends, or not have sent friend requests to the other party
					->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "friend" AND `engine4_suggestion_rejected`.`owner_id` = ' . $userid . ' AND `engine4_suggestion_rejected`.`entity_id` = eum1.user_id)')// Users' friendship suggestions should not have been rejected.
					->order('RAND()')
					->limit($number_of_users);
				$fetch_friend_table = $friend_select->query()->fetchAll();
				foreach( $fetch_friend_table as $row )
				{
					$this->_first_level_user_array[] = $row['user_id'];
				}
				return $this->_first_level_user_array;
			}
			else {
				$user_table = Engine_Api::_()->getItemTable('user');
				$user_Name = $user_table->info('name');
			  // @todo: Use database query.
			  $friend_select = $friend_table->select()
					->from(array("eum1" => $friend_name), array('user_id'))
					->joinInner($user_Name, "eum1 . user_id = $user_Name . user_id", array())
					->where('eum1.resource_id = ?', $assign_user_id)
					->where('eum1.user_id != ?', $assign_friend_id )
					->where('eum1.user_approved = ?', 1)
					->where('eum1.active = ?', 1)
					->where('eum1.resource_approved = ?', 1)
					->where('NOT EXISTS (SELECT eum.user_id FROM `engine4_user_membership` eum WHERE eum.resource_id=' . $assign_friend_id . ' AND eum.user_id = eum1.user_id)') // Users should not be friends, or not have sent friend requests to the other party
					->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "friend" AND `engine4_suggestion_rejected`.`owner_id` = ' . $userid . ' AND `engine4_suggestion_rejected`.`entity_id` = eum1.user_id)') // Users' friendship suggestions should not have been rejected.
					->where("$user_Name.displayname LIKE ?", '%' . $search . '%');
      	$fetch_friend_table = Zend_Paginator::factory($friend_select);
			}
		}
		//IF ADMIN SET NETWORK Members SETTING FOR ALLOWING FRIENDS.
		elseif (Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 1)
		{
			$network_table_user = Engine_Api::_()->getDbtable('membership', 'network');
			$network_name = $network_table_user->info('name');
			//FIND THE USER NETWORK ID, because the suggestions must belong to those networks only
			$user_net_table = $network_table_user->select()
			->from($network_table_user, array('resource_id'))
			->where($network_name . '.user_id = ?', $assign_friend_id);
			$fetch_user_network_table = $user_net_table->query()->fetchAll();
			$network_ids_str = '';
			foreach ( $fetch_user_network_table as $network_row )
			{//Find network IDs of which user is a member.
				$network_ids_str .= $network_row['resource_id'] . ',';
			}
			$network_ids_str = rtrim($network_ids_str, ',');
			if(empty($network_ids_str)) {
				$network_ids_str = 0;
			}
			$friend_table = Engine_Api::_()->getDbtable('membership', 'user');
			$friend_name = $friend_table->info('name');
			if($search == 'show_friend_sugg')
			{
				// @todo: Use database query.
				$friend_select = $friend_table->select()
					->from(array("eum1" => $friend_name), array('user_id'))
					->where('eum1.resource_id = ?', $assign_user_id)
					->where('eum1.user_id != ?', $assign_friend_id )
					->where('eum1.user_approved = ?', 1)
					->where('eum1.active = ?', 1)
					->where('eum1.resource_approved = ?', 1)
					->where('EXISTS (SELECT `engine4_network_membership`.`user_id` FROM `engine4_network_membership` WHERE `engine4_network_membership`.`user_id` = eum1.user_id AND `engine4_network_membership`.`resource_id` IN (' . $network_ids_str . '))') // Suggested Users should belong to the networks in the list
					->where('NOT EXISTS (SELECT eum.user_id FROM `engine4_user_membership` eum WHERE eum.resource_id=' . $assign_friend_id . ' AND eum.user_id = eum1.user_id)') // Users should not be friends, or not have sent friend requests to the other party
					->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "friend" AND `engine4_suggestion_rejected`.`owner_id` = ' . $userid . ' AND `engine4_suggestion_rejected`.`entity_id` = eum1.user_id)') // Users' friendship suggestions should not have been rejected
					->where('eum1.user_id NOT IN (' . $display_user_str . ')')
					->order('RAND()')
					->limit($number_of_users);
				$network_fetch_friend_table = $friend_select->query()->fetchAll();
				foreach( $network_fetch_friend_table as $network_row )
				{
					$this->_first_level_user_array[] = $network_row['user_id'];
				}
				return $this->_first_level_user_array;
			}
			else {
				$user_table = Engine_Api::_()->getItemTable('user');
				$user_Name = $user_table->info('name');
				// @todo: Use database query.
				$friend_select = $friend_table->select()
					->from(array("eum1" => $friend_name), array('user_id'))
					->joinInner($user_Name, "eum1 . user_id = $user_Name . user_id", array())
					->where('eum1.resource_id = ?', $assign_user_id)
					->where('eum1.user_id != ?', $assign_friend_id )
					->where('eum1.user_approved = ?', 1)
					->where('eum1.active = ?', 1)
					->where('eum1.resource_approved = ?', 1)
					->where('EXISTS (SELECT `engine4_network_membership`.`user_id` FROM `engine4_network_membership` WHERE `engine4_network_membership`.`user_id` = eum1.user_id AND `engine4_network_membership`.`resource_id` IN (' . $network_ids_str . '))') // Suggested Users should belong to the networks in the list
					->where('NOT EXISTS (SELECT eum.user_id FROM `engine4_user_membership` eum WHERE eum.resource_id=' . $assign_friend_id . ' AND eum.user_id = eum1.user_id)') // Users should not be friends, or not have sent friend requests to the other party
					->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "friend" AND `engine4_suggestion_rejected`.`owner_id` = ' . $userid . ' AND `engine4_suggestion_rejected`.`entity_id` = eum1.user_id)') // Users' friendship suggestions should not have been rejected
					->where('eum1.user_id NOT IN (' . $display_user_str . ')')
					->where("$user_Name.displayname LIKE ?", '%' . $search . '%');
	      $fetch_friend_table = Zend_Paginator::factory($friend_select);
			}
		}
		//IF ADMIN SET NONE Members SETTING FOR ALLOWING FRIENDS.
		elseif (Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 0)
		{
			return 0;
		}

		return $fetch_friend_table;
	}

	/**
   * Returns the first level friend which have few friend.
   *
   * @param $userid: User id of currently login user.
   * @param $friend_id:User id which are perform any event.
   * @param $display_user_str: The string having user IDs of users currently being suggested
   * @param $number_of_users: The number having of require users.
   * @return array
   */
	public function few_friend_suggestion($userid, $friend_id, $display_user_str, $number_of_users, $search)
	{
		if(empty($display_user_str))
		{
			$display_user_str = 0;
		}
		if(empty($this->_network_ids))
		{
			$this->_network_ids = 0;
		}

		$this->_first_level_user_array = array();
		$this->_reject_user_entity_id = array();
		//Array hold the display user info.
		$suggestion_expload_array = array();

		$this->_suggestion_distance[$userid] = 0;
		$this->_temp_suggestion_users_id_array[] = $userid;

		//FETCH MEMBER FOR USER.
		//IF ADMIN SET "All Members" SETTING FOR ALLOWING FRIENDS.
		if(Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 2)
		{
			$friend_table = Engine_Api::_()->getDbtable('membership', 'user');
			$friend_name = $friend_table->info('name');
			$user_table = Engine_Api::_()->getItemTable('user');
			$user_Name = $user_table->info('name');
			// @todo: Use database query.
			$friend_select = $friend_table->select()
				->from(array("eum1" => $friend_name), array('user_id'))
				->joinInner($user_Name, "eum1 . user_id = $user_Name . user_id", array())
				->where('eum1.resource_id = ?', $userid)
				->where('eum1.user_id != ?', $friend_id )
				->where('eum1.user_approved = ?', 1)
				->where('eum1.active = ?', 1)
				->where('eum1.resource_approved = ?', 1)
				->where('NOT EXISTS (SELECT eum.user_id FROM `engine4_user_membership` eum WHERE eum.resource_id=' . $friend_id . ' AND eum.user_id = eum1.user_id)') // Users should not be friends, or not have sent friend requests to the other party
				->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "friend" AND `engine4_suggestion_rejected`.`owner_id` = ' . $friend_id . ' AND `engine4_suggestion_rejected`.`entity_id` = eum1.user_id)') // Users' friendship suggestions should not have been rejected
				->where('NOT EXISTS (SELECT `owner_id` FROM `engine4_suggestion_suggestions` WHERE `engine4_suggestion_suggestions`.`sender_id` = ' . $userid . ' AND `engine4_suggestion_suggestions`.`entity`= "friend" AND `engine4_suggestion_suggestions`.`owner_id`= ' . $friend_id . ' AND `engine4_suggestion_suggestions`.`entity_id`= eum1.user_id)') // This user should not have made this suggestion to the friend earlier
				->where('eum1.user_id NOT IN (' . $display_user_str . ')')
				->where("$user_Name.displayname LIKE ?", '%' . $search . '%');

			$fetch_friend_table = Zend_Paginator::factory($friend_select);
		}
		//IF ADMIN SET NETWORK Members SETTING FOR ALLOWING FRIENDS.
		elseif (Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 1)
		{
			$network_table_user = Engine_Api::_()->getDbtable('membership', 'network');
			$network_name = $network_table_user->info('name');
			//FIND THE USER NETWORK ID, because the suggestions must belong to those networks only
			$user_net_table = $network_table_user->select()
			->from($network_table_user, array('resource_id'))
			->where($network_name . '.user_id = ?', $friend_id);
			$fetch_user_network_table = $user_net_table->query()->fetchAll();
			if(!empty($fetch_user_network_table))
			{
				$network_ids_str = '';
				foreach ( $fetch_user_network_table as $network_row )
				{//Find network IDs of which user is a member.
					$network_ids_str .= $network_row['resource_id'] . ',';
				}
				$network_ids_str = rtrim($network_ids_str, ',');
				$friend_table = Engine_Api::_()->getDbtable('membership', 'user');
				$friend_name = $friend_table->info('name');
				$user_table = Engine_Api::_()->getItemTable('user');
				$user_Name = $user_table->info('name');
				// @todo: Use database query.
				$friend_select = $friend_table->select()
					->from(array("eum1" => $friend_name), array('user_id'))
					->joinInner($user_Name, "eum1 . user_id = $user_Name . user_id", array())
					->where('eum1.resource_id = ?', $userid)
					->where('eum1.user_id != ?', $friend_id )
					->where('eum1.user_approved = ?', 1)
					->where('eum1.active = ?', 1)
					->where('eum1.resource_approved = ?', 1)
					->where('EXISTS (SELECT `engine4_network_membership`.`user_id` FROM `engine4_network_membership` WHERE `engine4_network_membership`.`user_id` = eum1.user_id AND `engine4_network_membership`.`resource_id` IN (' . $network_ids_str . '))') // Suggested Users should belong to the networks in the list
					->where('NOT EXISTS (SELECT eum.user_id FROM `engine4_user_membership` eum WHERE eum.resource_id=' . $friend_id . ' AND eum.user_id = eum1.user_id)') // Users should not be friends, or not have sent friend requests to the other party
					->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "friend" AND `engine4_suggestion_rejected`.`owner_id` = ' . $friend_id . ' AND `engine4_suggestion_rejected`.`entity_id` = eum1.user_id)') // Users' friendship suggestions should not have been rejected
					->where('NOT EXISTS (SELECT `owner_id` FROM `engine4_suggestion_suggestions` WHERE `engine4_suggestion_suggestions`.`sender_id` = ' . $userid . ' AND `engine4_suggestion_suggestions`.`entity`= "friend" AND `engine4_suggestion_suggestions`.`owner_id`= ' . $friend_id . ' AND `engine4_suggestion_suggestions`.`entity_id`= eum1.user_id)') // This user should not have made this suggestion to the friend earlier
					->where('eum1.user_id NOT IN (' . $display_user_str . ')')
					->where("$user_Name.displayname LIKE ?", '%' . $search . '%');

				$fetch_friend_table = Zend_Paginator::factory($friend_select);
			}
			else {
				return 0;
			}
		}
		//IF ADMIN SET NONE Members SETTING FOR ALLOWING FRIENDS.
		elseif (Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible == 0)
		{
			return 0;
		}
		return $fetch_friend_table;
	}


	public function getModuleSubject()
	{
		$suggestion_menu = hash('ripemd160', 'suggestion');
		Engine_Api::_()->getApi('settings', 'core')->setSetting('suggestion.menu', $suggestion_menu);

		$db     = Engine_Api::_()->getDbtable('menuitems', 'core');
		$db_name = $db->info('name');

		$db_select = $db->select()
			->where('name =?', 'suggestion_admin_settings');
		$setting_obj = $db->fetchAll($db_select)->toArray();
		if(empty($setting_obj))
		{
			$db->insert(array(
			 'name' => 'suggestion_admin_settings',
			 'module'    => 'suggestion',
			 'label'    => 'Suggestion types settings',
			 'plugin' => NULL,
			 'params'   => '{"route":"admin_default","module":"suggestion","controller":"settings"}',
			 'menu' => 'sugg_admin_main',
			 'submenu' => '',
			 'custom' => '0',
			 'order' => '2',

			));
		}

		$db_select = $db->select()
			->where('name =?', 'suggestion_admin_main_mix');
		$mix_suggestion_obj = $db->fetchAll($db_select)->toArray();
		if(empty($mix_suggestion_obj))
		{
			$db->insert(array(
			 'name' => 'suggestion_admin_main_mix',
			 'module'    => 'suggestion',
			 'label'    => 'Mixed Suggestions',
			 'plugin' => NULL,
			 'params'   => '{"route":"admin_default","module":"suggestion","controller":"mix"}',
			 'menu' => 'sugg_admin_main',
			 'submenu' => '',
			 'custom' => '0',
			 'order' => '3',

			));
		}

		$db_select = $db->select()
			->where('name =?', 'suggestion_introduction');
		$intro_obj = $db->fetchAll($db_select)->toArray();
		if(empty($intro_obj))
		{
			$db->insert(array(
			 'name' => 'suggestion_introduction',
			 'module'    => 'suggestion',
			 'label'    => 'Site Introduction',
			 'plugin' => NULL,
			 'params'   => '{"route":"admin_default","module":"suggestion","controller":"introduction"}',
			 'menu' => 'sugg_admin_main',
			 'submenu' => '',
			 'custom' => '0',
			 'order' => '4',

			));
		}
	}

	/**
	 * Return the array of randum users to be suggested as friends only if there are no friend in "Network" and "2nd & 3rd level".
	 *
	 * @param $user_id: User which are login.
	 * @param $number_of_users: Number of user which are require.
	 * @param $user_home_display_friend : User which are display already in home page use in ajax.
	 * @return array
	 */

	public function find_randum_friend_suggestion($user_id, $number_of_users, $user_home_display_friend)
	{
		$display_user = 0;
		if(empty($user_home_display_friend))
		{
			$user_home_display_friend = 0;
		}
		// For current user.
		if(!empty($this->_final_key_array))
		{
			$display_user .= ',' . implode(",", $this->_final_key_array);
		}
		// For display user.
		if(!empty($this->_userhome_display_array[0]))
		{
			$display_user .= ',' . implode(",", $this->_userhome_display_array[0]);
		}
		// For rejected user.
		if(!empty($this->_reject_user_entity_id))
		{
			$display_user .= ',' . implode(",", $this->_reject_user_entity_id);
		}
		$user_table = Engine_Api::_()->getItemTable('user');
		$user_table_name = $user_table->info('name');
		//$user_network_table = Engine_Api::_()->getDbtable('membership', 'network');
		$user_table_select = $user_table->select()
			->setIntegrityCheck(false)
			->from($user_table_name, array('user_id'))
			->where('user_id != ?', $user_id)
			->where('search = ?', 1)
			->where('enabled = ?', 1)
			->where('verified = ?', 1)
			->where("user_id NOT IN ($display_user)")
			->where("user_id NOT IN ($user_home_display_friend)")
			->where('NOT EXISTS (SELECT `user_id` FROM `engine4_user_membership` WHERE `engine4_user_membership`.`resource_id` = ' . $user_id . ' AND `engine4_user_membership`.`user_id`= ' . $user_table_name . '.`user_id`)')
			->order('RAND()')
			->limit($number_of_users);
		$fetch_user_table_select = $user_table_select->query()->fetchAll();
		foreach ( $fetch_user_table_select as $randum_user )
		{
			$this->_final_key_array[] = $randum_user['user_id'];
		}
		return;
	}

	/**
	 * Return the array of network users to be suggested as friends.
	 *
	 * @param $user_id: User which are login.
	 * @param $number_of_users: Number of user which are require.
	 * @param $user_home_display_friend : User which are display already in home page use in ajax.
	 * @return array
	 */
	public function find_network_friend($user_id, $number_of_users, $user_home_display_friend)
	{
		$display_user = 0;
		if(empty($user_home_display_friend))
		{
			$user_home_display_friend = 0;
		}
		$current_user = Engine_Api::_()->user()->getViewer()->getIdentity();// Current user id.
		$temp_sugg_user_id = implode(",", $this->_temp_suggestion_users_id_array);
		// For current user.
		if(!empty($this->_final_key_array))
		{
			$display_user .= ',' . implode(",", $this->_final_key_array);
		}
		// For display user.
		if(!empty($this->_userhome_display_array[0]))
		{
			$display_user .= ',' . implode(",", $this->_userhome_display_array[0]);
		}
		// For rejected user.
		if(!empty($this->_reject_user_entity_id))
		{
			$display_user .= ',' . implode(",", $this->_reject_user_entity_id);
		}
		$network_table = Engine_Api::_()->getDbtable('membership', 'network');
		$network_table_name = $network_table->info('name');

		$network_table_select = $network_table->select()
			->from($network_table_name, array('resource_id'))
			->where($network_table_name . '.user_id = ?', $user_id);

		$fetch_network_table = $network_table_select->query()->fetchAll();
		$network_ides = array();
		foreach ( $fetch_network_table as $network_row )
		{//Find network IDs of which user is a member.
			$network_ides[] = $network_row['resource_id'];
		}
		//Find users within every network
		foreach($network_ides as $sugg_nw_id)
		{
			$user_network_table = Engine_Api::_()->getDbtable('membership', 'network');
			$network_table_name = $network_table->info('name');
			$user_network_table_select = $user_network_table->select()
				->from($network_table_name, array('user_id'))
				->where('resource_id = ?', $sugg_nw_id)
				->where('active = ?', 1)
				->where('resource_approved = ?', 1)
				->where('user_approved = ?', 1)
				->where("user_id NOT IN ($temp_sugg_user_id)")
				->where("user_id NOT IN ($user_home_display_friend)")
				->where("user_id NOT IN ($display_user)")
				->where('NOT EXISTS (SELECT `user_id` FROM `engine4_user_membership` WHERE `engine4_user_membership`.`resource_id` = ' . $user_id . ' AND `engine4_user_membership`.`user_id`= ' . $network_table_name . '.`user_id`)')
				->order('RAND()')
				->limit($number_of_users);

			$fetch_user_network_table = $user_network_table_select->query()->fetchAll();
			foreach ( $fetch_user_network_table as $network_user )
			{
				$this->_final_key_array[] = $network_user['user_id'];
			}
		}
		return;
	}



	/**
   * Returns the members information being displayed in the widget : Friends suggestion/Ajax
   *
   * @param $path_array: Array of the suggested user/users.
   * @return Array
   */
	public function suggestion_users_information($path_array, $selected_friend_show)
	{
		$users_id = implode(",", $path_array);
		//FETCH RECORD FROM USER TABLE
		$user_table  = Engine_Api::_()->getItemTable('user');
		$select_user_table = $user_table->select()->where("user_id IN ($users_id)");
		if ($selected_friend_show) {
			$user_info_array = Zend_Paginator::factory($select_user_table);
	  }
		else {
			$user_info_array = $user_table->fetchAll($select_user_table);
		}

		return $user_info_array;
	}

	protected  $group_array;
	protected  $set_array;

	/** Function for "Group Widget" but call only in the case of "Login User".
   * Returns the group array.
   *
   * @param $display_sugg_str: Group which are display on page.
   * @param $limit: Set limit that how many group will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function group_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// Unset "group function array", if "group widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->group_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
			$mix_explode = explode("_", $row_explode_str);
			if($mix_explode[0] == 'group')
			{
				$mix_dis_str .= "," . $mix_explode[1];
			}
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_group = $mix_dis_str;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$level = 0;
		// The function sets based on their main queries. One of these functions is called randomly to return suggestions
		$this->set_array = array('group_set1', 'group_set2', 'group_set3', 'group_set4');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$group_fun = $this->set_array[$current_set_id];
			// Calling the randomly picked up function
			$group_set = $this->$group_fun($dis_group, $set_limit);
			//$this->group_array is the protected array to which all functions add their results
			$level = count($this->group_array);
			// The randomly picked function which was just called, should not be called again
			unset($this->set_array[$current_set_id]);
			if(count($this->set_array) == 0)
			{
				break;
			}
		}

		if($page == 'mix_sugg')
		{
			if(!empty($this->group_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->group_array;
				// Unset the group array value.
				$array_sugg_key = array_keys($this->group_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->group_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->group_array;
		}
	}

	/** Function for "Group Widget" but call only in the case of "Logout User".
   * Returns: the group array.
   *
   * @param $dis_group: Group which are display on page.
   * @param $limit: Set limit that how many group will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function group_loggedout_suggestions($dis_group, $limit, $page)
	{
		// Unset "group function array", if "group widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->group_array = array();
		}
		$level = 0;
		// For logged out users, these 2 functions should be called for group suggestions
		$this->set_array = array('group_set4', 'group_set2');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$group_fun = $this->set_array[$current_set_id];
			// Calling the randomly picked up function
			$group_set = $this->$group_fun($dis_group, $set_limit);
			//$this->group_array is the protected array to which all functions add their results
			$level = count($this->group_array);
			unset($this->set_array[$current_set_id]);
			if(count($this->set_array) == 0)
			{
				break;
			}
		}
		if($page == 'mix_sugg')
		{
			if(!empty($this->group_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->group_array;
				// Unset the group array value.
				$array_sugg_key = array_keys($this->group_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->group_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}

		}
		else
		{
			return $this->group_array;
		}
	}


	/** Function call by "Group" main functions.
   * Returns: the group array.
   *
   * @param $disply_group: Group which are display on page.
   * @param $limit: Set limit that how many group will be return.
   * @return Array
   */
	// - Groups created by my friends with most members
	// - Groups created by my friends with most views
	// - Groups created by my friends in creation_date DESC
	public function group_set1($disply_group, $limit)
	{
		//Condition for display user on page.
		if(empty($disply_group)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_group = 0;
		}
		//Condition for main array.
		if(empty($this->group_array)) // If none of the other randomly called functions have been called before this
		{
			$group_dis_array = 0;
		}
		else
		{
			$group_dis_array = implode(",", $this->group_array);
		}
		$group_str = $disply_group . ',' . $group_dis_array;
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// The order is chosen randomly
		// @todo : Instead of choosing random ORDER BY, build a randomly organized string of the 3 ORDER BYs
		$set_order = array('member_count DESC','view_count DESC', 'creation_date DESC');

		//		for($i = 0; $i<count($set1_order); $i++ )
		//		{
		//			//Return randum key.
		$randum_order = array_rand($set_order, 1);
		//			$group_order = ',' . $set1_order[$randum_order];
		//			unset($set1_order[$randum_order]);
		//		}

		// Groups which the user has joined
		$my_grp_table = Engine_Api::_()->getItemTable('groupinfo');
		$grp_select = $my_grp_table->select()
		->from($my_grp_table, array('resource_id'))
		->where('user_id = ' . $user_id);
		$my_grp_fetch = $grp_select->query()->fetchAll();
		foreach($my_grp_fetch as $row_my_grp)
		{
			$group_str .= ',' . $row_my_grp['resource_id'];
		}

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		$group_table = Engine_Api::_()->getItemTable('group');
		$member_name = $membership_table->info('name');
		$group_Name = $group_table->info('name');
		// @todo: Use database query.
		$set1_group_select = $group_table->select()
			->setIntegrityCheck(false)
			->from($group_Name, array('group_id'))
			->joinInner($member_name, "$member_name.user_id = $group_Name.user_id", array())
			->where($member_name . '.resource_id = ?', $user_id)
			->where($group_Name . '.user_id != ?', $user_id)
			->where($group_Name . '.search = ?', 1)
			->where($group_Name . '.invite = ?', 1)
			->where($member_name . '.active = ?', 1)
			->where($group_Name .".group_id NOT IN ($group_str)")
			->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "group" AND `engine4_suggestion_rejected`.`entity_id`= ' . $group_Name . '.group_id)')
			->order($group_Name . '.' . $set_order[$randum_order])
			->limit($limit);
		$fetch_set1_group = $set1_group_select->query()->fetchAll();
		foreach($fetch_set1_group as $row_set1_group)
		{
			$this->group_array['group_' . $row_set1_group['group_id']] = $row_set1_group['group_id'];

			if(count($this->group_array) == $limit)
			{
				return $this->group_array;
			}
		}
		return $this->group_array;
	}


	/** Function call by "Group" main functions.
   * Returns: the group array.
   *
   * @param $disply_group: Group which are display on page.
   * @param $limit: Set limit that how many group will be return.
   * @return Array
   */
	//- Latest created groups
	//- Groups with most members
	//- Groups with most views
	public function group_set2($disply_group, $limit)
	{
		if(empty($disply_group)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_group = 0;
		}
		//Condition for main array.
		if(empty($this->group_array)) // If none of the other randomly called functions have been called before this
		{
			$group_dis_array = 0;
		}
		else
		{
			$group_dis_array = implode(",", $this->group_array);
		}
		$group_str = $disply_group . ',' . $group_dis_array;
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();


		// The order is chosen randomly
		// @todo : Instead of choosing random ORDER BY, build a randomly organized string of the 3 ORDER BYs
		$set_order = array('creation_date DESC','member_count DESC', 'view_count DESC');
		//Return randum key.
		$randum_order = array_rand($set_order, 1);
		// Groups which the user has joined
		$my_grp_table = Engine_Api::_()->getItemTable('groupinfo');
		$grp_select = $my_grp_table->select()
		->from($my_grp_table, array('resource_id'))
		->where('user_id = ' . $user_id);
		$my_grp_fetch = $grp_select->query()->fetchAll();
		foreach($my_grp_fetch as $row_my_grp)
		{
			$group_str .= ',' . $row_my_grp['resource_id'];
		}


		$group_table = Engine_Api::_()->getItemTable('group');
		$group_Name = $group_table->info('name');
		// @todo: Use database query.
		$set2_group_select = $group_table->select()
			->from($group_table, array('group_id'))
			->where($group_Name . '.user_id != ?', $user_id)
			->where($group_Name . '.search = ?', 1)
			->where($group_Name . '.invite = ?', 1)
			->where($group_Name . ".group_id NOT IN ($group_str)")
			->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "group" AND `engine4_suggestion_rejected`.`entity_id`= ' . $group_Name . '.group_id)')
			->order($set_order[$randum_order])
			->limit($limit);
		$fetch_set2_group = $set2_group_select->query()->fetchAll();
		foreach($fetch_set2_group as $row_set2_group)
		{
			$this->group_array['group_' . $row_set2_group['group_id']] = $row_set2_group['group_id'];

			if(count($this->group_array) == $limit)
			{
				return $this->group_array;
			}
		}
		return $this->group_array;
	}


	/** Function call by "Group" main functions.
   * Returns: the group array.
   *
   * @param $disply_group: Group which are display on page.
   * @param $limit: Set limit that how many group will be return.
   * @return Array
   */
	// - Groups joined by my friends
	public function group_set3($disply_group, $limit)
	{
		if(empty($disply_group)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_group = 0;
		}
		//Condition for main array.
		if(empty($this->group_array)) // If none of the other randomly called functions have been called before this
		{
			$group_dis_array = 0;
		}
		else
		{
			$group_dis_array = implode(",", $this->group_array);
		}
		$group_str = $disply_group . ',' . $group_dis_array;
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// Groups which the user has joined
		$my_grp_table = Engine_Api::_()->getItemTable('groupinfo');
		$grp_select = $my_grp_table->select()
			->from($my_grp_table, array('resource_id'))
			->where('user_id = ' . $user_id);
		$my_grp_fetch = $grp_select->query()->fetchAll();
		foreach($my_grp_fetch as $row_my_grp)
		{
			$group_str .= ',' . $row_my_grp['resource_id'];
		}

		//Groups joined by my friends.
		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		$group_table = Engine_Api::_()->getItemTable('groupinfo');
		$grp_table = Engine_Api::_()->getItemTable('group');
		$grp_name = $grp_table->info('name');
		$member_name = $membership_table->info('name');
		$group_Name = $group_table->info('name');
		// @todo: Use database query.
		$set3_group_select = $group_table->select()
			->setIntegrityCheck(false)
			->from($member_name, array('COUNT(' . $member_name . '.user_id) AS friends_grp_count'))
			->joinInner($group_Name, "$group_Name.user_id = $member_name.user_id", array('resource_id'))
			->joinInner($grp_name, "$grp_name.group_id = $group_Name.resource_id", array())
			->where($member_name . '.resource_id = ?', $user_id)
			->where($grp_name . '.user_id != ?', $user_id)
			->where($member_name . '.active = ?', 1)
			->where($grp_name . '.search = ?', 1)
			->where($grp_name . '.invite = ?', 1)
			->where($group_Name . '.active = ?', 1)
			->where($group_Name . '.resource_approved = ?', 1)
			->where($group_Name . '.user_approved = ?', 1)
			->where($group_Name .".resource_id NOT IN ($group_str)")
			->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "group" AND `engine4_suggestion_rejected`.`entity_id`= ' . $group_Name . '.resource_id)')
			->group($group_Name . '.resource_id')
			->order('friends_grp_count DESC')
			->limit($limit);

		$fetch_set3_group = $set3_group_select->query()->fetchAll();
		foreach ($fetch_set3_group as $row_set3_group)
		{
			$this->group_array['group_' . $row_set3_group['resource_id']] = $row_set3_group['resource_id'];
			if(count($this->group_array) == $limit)
			{
				return $this->group_array;
			}
		}
		return $this->group_array;
	}


	/** Function call by "Group" main functions.
   * Returns: the group array.
   *
   * @param $disply_group: Group which are display on page.
   * @param $limit: Set limit that how many group will be return.
   * @return Array
   */
	//Groups belonging to the same category as the Group being viewed. [This will only work if the widget is being shown on the "Group Profile" page.]
	public function group_set4($disply_group, $limit)
	{
		if(empty($disply_group)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_group = 0;
		}
		//Condition for main array.
		if(empty($this->group_array)) // If none of the other randomly called functions have been called before this
		{
			$group_dis_array = 0;
		}
		else
		{
			$group_dis_array = implode(",", $this->group_array);
		}
		$group_str = $disply_group . ',' . $group_dis_array;
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$front = Zend_Controller_Front::getInstance();
		$module = $front->getRequest()->getModuleName();
		$action = $front->getRequest()->getActionName();

		if(($module == 'group') && ($action == 'index'))
		{
			$curr_url = $front->getRequest()->getRequestUri();
			$profile_group_url = explode("/", $curr_url);
			//Find out the Group ID.
			$profile_group_count = count($profile_group_url) - 1;
			$view_group_id = $profile_group_url[$profile_group_count];
			$group_str .= ',' . $view_group_id;

			//Query for find out same group category group

			$category_group = Engine_Api::_()->getItemTable('group');

			$category_group_select = $category_group->select()
			->from($category_group, array('category_id'))
			->where('group_id = ?',$view_group_id);

			$current_category_array = $category_group_select->query()->fetchall();
			$current_group_category = $current_category_array[0]['category_id'];

			// The order is chosen randomly
			// @todo : Instead of choosing random ORDER BY, build a randomly organized string of the 3 ORDER BYs
			$set_order = array('creation_date DESC','member_count DESC', 'view_count DESC');

			//		for($i = 0; $i<count($set_order); $i++ )
			//		{
			//Return randum key.
			$randum_order = array_rand($set_order, 1);
			//			$group_order = ',' . $set_order[$randum_order];
			//			unset($set2_order[$randum_order]);
			//		}

			// Groups which the user has joined
			$my_grp_table = Engine_Api::_()->getItemTable('groupinfo');
			$grp_select = $my_grp_table->select()
			->from($my_grp_table, array('resource_id'))
			->where('user_id = ' . $user_id);
			$my_grp_fetch = $grp_select->query()->fetchAll();
			foreach($my_grp_fetch as $row_my_grp)
			{
				$group_str .= ',' . $row_my_grp['resource_id'];
			}

			$group_table = Engine_Api::_()->getItemTable('group');
			$group_name = $group_table->info('name');
			// @todo: Use database query.
			$group_category_select = $group_table->select()
				->from($group_table, array('group_id'))
				->where($group_name . '.category_id = ?', $current_group_category)
				->where($group_name . '.user_id != ?', $user_id)
				->where($group_name . '.search = ?', 1)
				->where($group_name . '.invite = ?', 1)
				->where($group_name . ".group_id NOT IN ($group_str)")
				->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "group" AND `engine4_suggestion_rejected`.`entity_id`= ' . $group_name . '.group_id)')
				->order($set_order[$randum_order])
				->limit($limit);

			$fetch_group_id = $group_category_select->query()->fetchall();
			for($i=0; $i < count($fetch_group_id); $i++)
			{
				$this->group_array['group_' . $fetch_group_id[$i]['group_id']] = $fetch_group_id[$i]['group_id'];
				if(count($this->group_array) == $disply_group)
				{
					return $this->group_array;
				}
			}
		}
		return $this->group_array;
	}


	/**
   * Returns: Object of group.
   *
   * @param $path_array: Array of group ids.
   * @return Array
   */
	public function group_info($path_array)
	{
		$group_id = implode(",", $path_array);
		//FETCH RECORD FROM USER TABLE
		$grp_table = Engine_Api::_()->getItemTable('group');
		$select_grp_table = $grp_table->select()->where("group_id IN ($group_id)");
		$grp_info_array = $grp_table->fetchAll($select_grp_table);
		return $grp_info_array;
	}


	/** This popup comes when the user joins a group, and asks the user to suggest this group to other friends. This function is also called when "X" is clicked for an entry
   * Returns: Group id array.
   *
   * @param $group_id : Group id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
	public function group_suggestion($group_id, $display_user, $number_of_user, $search='')
	{
		$group = Engine_Api::_()->getItem('group', $group_id);
		if(($group->search == 1) && ($group->invite == 1))
		{
			//$can_reply = $this->view->can_reply = $userBlock->block_comment;
			if(empty($display_user))
			{
				$display_user = 0;
			}
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

			$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
			$member_name = $membership_table->info('name');
			$user_table = Engine_Api::_()->getItemTable('user');
			$user_Name = $user_table->info('name');

			// @todo : Try to compose the sub-queries written below using Zend's convention
			// The friend suggested should not be already shown in the popup; he should not be a member of the group already, and he should not have rejected this group as a suggestion.
			$member_select = $membership_table->select()
				->from($member_name, array('user_id'))
				->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
				->where($member_name . '.resource_id = ?', $user_id)
				->where($member_name . '.active = ?', 1)
				->where($member_name . '.user_id NOT IN(' . $display_user . ')')
				->where('NOT EXISTS (SELECT `user_id` FROM `engine4_group_membership` WHERE `engine4_group_membership`.`resource_id`=' . $group_id . ' AND `engine4_group_membership`.`user_id` = ' . $member_name . '.user_id AND `engine4_group_membership`.`active` = 1)')
				->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "group" AND `engine4_suggestion_rejected`.`owner_id` = ' . $member_name . '.user_id AND `engine4_suggestion_rejected`.`entity_id` = ' . $group_id . ')')
				->where('displayname LIKE ?', '%' . $search . '%');

      $fetch_member_myfriend = Zend_Paginator::factory($member_select);
 		}
		else
		{
			$fetch_member_myfriend = '';
		}
		return $fetch_member_myfriend;
	}


	protected  $event_array;
	protected  $set_event_array;

	/** Function for "Event Widget" but call only in the case of "Login User".
   * Returns the event array.
   *
   * @param $display_sugg_str: Event which are display on page.
   * @param $limit: Set limit that how many event will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function event_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// Unset "event function array", if "event widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->event_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
			$mix_explode = explode("_", $row_explode_str);
			if($mix_explode[0] == 'event')
			{
				$mix_dis_str .= "," . $mix_explode[1];
			}
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_event = $mix_dis_str;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$level = 0;
		$this->set_event_array = array('event_set1', 'event_set2', 'event_set3', 'event_set4', 'event_set5', 'event_set6');
		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_event_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$eve_function = $this->set_event_array[$current_set_id];
			$event_set = $this->$eve_function($dis_event, $set_limit);
			$level = count($this->event_array);
			$str = $current_set_id . $level;
			unset($this->set_event_array[$current_set_id]);
			if(count($this->set_event_array) == 0)
			{
				break;
			}
		}

		if($page == 'mix_sugg')
		{
			if(!empty($this->event_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->event_array;
				// Unset the event array value.
				$array_sugg_key = array_keys($this->event_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->event_array[$unset_key]);
				return 1;
			}
			else {
				return 0;
			}

		}
		else
		{
			return $this->event_array;
		}
	}


	/** Function for "Event Widget" but call only in the case of "Logout User".
   * Returns the event array.
   *
   * @param $dis_event: Event which are display on page.
   * @param $limit: Set limit that how many event will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function event_loggedout_suggestions($dis_event, $limit, $page)
	{
		// Unset "event function array", if "event widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->event_array = array();
		}
		$level = 0;
		$this->set_event_array = array('event_set1', 'event_set5');
		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_event_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$event_fun = $this->set_event_array[$current_set_id];
			$event_set = $this->$event_fun($dis_event, $set_limit);
			$level = count($this->event_array);
			unset($this->set_event_array[$current_set_id]);
			if(count($this->set_event_array) == 0)
			{
				break;
			}
		}
		if($page == 'mix_sugg')
		{
			if(!empty($this->event_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->event_array;
				// Unset the event array value.
				$array_sugg_key = array_keys($this->event_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->event_array[$unset_key]);
				return 1;
			}
			else {
				return 0;
			}

		}
		else
		{
			return $this->event_array;
		}
	}


	/** Function call by "Event" main functions.
   * Returns: the event array.
   *
   * @param $disply_event: Event which are display on page.
   * @param $limit: Set limit that how many event will be return.
   * @return Array
   */
	// -> (events in the order of member count, creation date).
	// -> (events in the order of view count, creation date).
	public function event_set1($disply_event, $limit)
	{
		if(empty($disply_event))
		{
			$disply_event = 0;
		}
		//Condition for main array.
		if(empty($this->event_array))
		{
			$event_dis_array = 0;
		}
		else
		{
			$event_dis_array = implode(",", $this->event_array);
		}
		$event_str = $disply_event . ',' . $event_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('member_count DESC', 'view_count DESC');

		//for($i = 0; $i<count($set2_order); $i++ )
		//{
		//Return randum key.
		$randum_order = array_rand($set_order, 1);

		// Getting the events joined by the user
		$my_event_table = Engine_Api::_()->getItemTable('eventinfo');
		$event_select = $my_event_table->select()
		->from($my_event_table, array('resource_id'))
		->where('user_id = ' . $user_id . '');
		$my_event_fetch = $event_select->query()->fetchAll();
		foreach($my_event_fetch as $row_my_event)
		{
			$event_str .= ',' . $row_my_event['resource_id'];
		}
		// @todo: Use database query.
		$event_table = Engine_Api::_()->getItemTable('event');
		$event_Name = $event_table->info('name');
		$set2_event_select = $event_table->select()
			->from($event_table, array('event_id'))
			->where($event_Name . '.user_id != ?', $user_id)
			->where($event_Name . '.search = ?', 1)
			->where("endtime > FROM_UNIXTIME(?)", time())
			->where($event_Name . ".event_id NOT IN ($event_str)")
			->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "event" AND `engine4_suggestion_rejected`.`entity_id`= ' . $event_Name . '.event_id)')
			->order($set_order[$randum_order])
			->order($event_Name . '.creation_date DESC')
			->limit($limit);
		$fetch_set2_event = $set2_event_select->query()->fetchAll();
		foreach($fetch_set2_event as $row_set2_event)
		{
			$this->event_array['event_' . $row_set2_event['event_id']] = $row_set2_event['event_id'];

			if(count($this->event_array) == $limit)
			{
				return $this->event_array;
			}
		}
		//	unset($set2_order[$randum_order]);
		//}
		return $this->event_array;
	}


	/** Function call by "Event" main functions.
   * Returns: the event array.
   *
   * @param $disply_event: Event which are display on page.
   * @param $limit: Set limit that how many event will be return.
   * @return Array
   */
	// - Upcoming events created by my friends in the order of member count.
	// - Upcoming events created by my friends in the order of view count.
	public function event_set2($disply_event, $limit)
	{
		if(empty($disply_event))
		{
			$disply_event = 0;
		}
		//Condition for main array.
		if(empty($this->event_array))
		{
			$event_dis_array = 0;
		}
		else
		{
			$event_dis_array = implode(",", $this->event_array);
		}
		$event_str = $disply_event . ',' . $event_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('member_count DESC', 'view_count DESC');

		//		for($i = 0; $i<count($set_order); $i++ )
		//		{
		//Return randum key.
		$randum_order = array_rand($set_order, 1);

		// Getting the events joined by the user
		$my_event_table = Engine_Api::_()->getItemTable('eventinfo');
		$event_select = $my_event_table->select()
		->from($my_event_table, array('resource_id'))
		->where('user_id = ' . $user_id . '');
		$my_event_fetch = $event_select->query()->fetchAll();
		foreach($my_event_fetch as $row_my_event)
		{
			$event_str .= ',' . $row_my_event['resource_id'];
		}

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		$event_table = Engine_Api::_()->getItemTable('event');
		$member_name = $membership_table->info('name');
		$event_Name = $event_table->info('name');
		// @todo: Use database query.
		$set1_event_select = $event_table->select()
			->setIntegrityCheck(false)
			->from($event_Name, array('event_id'))
			->joinInner($member_name, "$member_name.user_id = $event_Name.user_id", array())
			->where($event_Name . '.user_id != ?', $user_id)
			->where($member_name . '.resource_id = ?', $user_id)
			->where($member_name . '.active = ?', 1)
			->where($event_Name . ".endtime > FROM_UNIXTIME(?)", time())
			->where($event_Name . '.search = ?', 1)
			->where($event_Name . ".event_id NOT IN ($event_str)")
			->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "event" AND `engine4_suggestion_rejected`.`entity_id`= ' . $event_Name . '.event_id)')
			->order($event_Name . '.' . $set_order[$randum_order])
			->limit($limit);

		$fetch_set1_event = $set1_event_select->query()->fetchAll();
		foreach($fetch_set1_event as $row_set2_event)
		{
			$this->event_array['event_' . $row_set2_event['event_id']] = $row_set2_event['event_id'];

			if(count($this->event_array) == $limit)
			{
				return $this->event_array;
			}
		}
		//	unset($set_order[$randum_order]);
		//}
		return $this->event_array;
	}



	/** Function call by "Event" main functions.
   * Returns: the event array.
   *
   * @param $disply_event: Event which are display on page.
   * @param $limit: Set limit that how many event will be return.
   * @return Array
   */
	// - Upcoming events being attended by my friends in the order of popularity among friends (with most friends attending).
	public function event_set3($disply_event, $limit)
	{
		if(empty($disply_event))
		{
			$disply_event = 0;
		}
		//Condition for main array.
		if(empty($this->event_array))
		{
			$event_dis_array = 0;
		}
		else
		{
			$event_dis_array = implode(",", $this->event_array);
		}
		$event_str = $disply_event . ',' . $event_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// Getting the events joined by the user
		$my_event_table = Engine_Api::_()->getItemTable('eventinfo');
		$event_select = $my_event_table->select()
		->from($my_event_table, array('resource_id'))
		->where('user_id = ' . $user_id . '');
		$my_event_fetch = $event_select->query()->fetchAll();
		foreach($my_event_fetch as $row_my_event)
		{
			$event_str .= ',' . $row_my_event['resource_id'];
		}

		//Events joined by my friends.
		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		$event_table = Engine_Api::_()->getItemTable('eventinfo');
		$eve_table = Engine_Api::_()->getItemTable('event');
		$member_name = $membership_table->info('name');
		$event_Name = $event_table->info('name');
		$eve_Name = $eve_table->info('name');
		// @todo: Use database query.
		$set3_event_select = $event_table->select()
			->setIntegrityCheck(false)
			->from($member_name, array('COUNT(' . $member_name . '.user_id) AS friends_event_count'))
			->joinInner($event_Name, "$event_Name.user_id = $member_name.user_id", array('resource_id'))
			->joinInner($eve_Name, "$eve_Name.event_id = $event_Name.resource_id", array())
			->where($eve_Name . '.user_id != ?', $user_id)
			->where($member_name . '.resource_id = ?', $user_id)
			->where($member_name . '.active = ?', 1)
			->where($eve_Name . ".endtime > FROM_UNIXTIME(?)", time())
			->where($eve_Name . '.search = ?', 1)
			->where($event_Name . '.active = ?', 1)
			->where($event_Name . '.resource_approved = ?', 1)
			->where($event_Name . '.user_approved = ?', 1)
			->where($event_Name .".resource_id NOT IN ($event_str)")
			->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "event" AND `engine4_suggestion_rejected`.`entity_id`= ' . $event_Name . '.resource_id)')
			->group($event_Name . '.resource_id')
			->order('friends_event_count DESC')
			->limit($limit);

		$fetch_set2_event = $set3_event_select->query()->fetchAll();
		foreach($fetch_set2_event as $row_set2_event)
		{
			$this->event_array['event_' . $row_set2_event['resource_id']] = $row_set2_event['resource_id'];

			if(count($this->event_array) == $limit)
			{
				return $this->event_array;
			}
		}
		return $this->event_array;
	}


	/** Function call by "Event" main functions.
   * Returns: the event array.
   *
   * @param $disply_event: Event which are display on page.
   * @param $limit: Set limit that how many event will be return.
   * @return Array
   */
	// - Upcoming events being attended by my friends in the order of member count.
	// - Upcoming events being attended by my friends in the order of view count.
	public function event_set4($disply_event, $limit)
	{
		if(empty($disply_event))
		{
			$disply_event = 0;
		}
		//Condition for main array.
		if(empty($this->event_array))
		{
			$event_dis_array = 0;
		}
		else
		{
			$event_dis_array = implode(",", $this->event_array);
		}

		$event_str = $disply_event . ',' . $event_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('member_count DESC', 'view_count DESC');

		//		for($i = 0; $i<count($set5_order); $i++ )
		//		{
		//Return randum key.
		$randum_order = array_rand($set_order, 1);

		// Getting the events joined by the user
		$my_event_table = Engine_Api::_()->getItemTable('eventinfo');
		$event_select = $my_event_table->select()
		->from($my_event_table, array('resource_id'))
		->where('user_id = ' . $user_id . '');
		$my_event_fetch = $event_select->query()->fetchAll();
		foreach($my_event_fetch as $row_my_event)
		{
			$event_str .= ',' . $row_my_event['resource_id'];
		}

		//Events joined by my friends.
		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		$event_table = Engine_Api::_()->getItemTable('eventinfo');
		$eve_table = Engine_Api::_()->getItemTable('event');
		$member_name = $membership_table->info('name');
		$event_Name = $event_table->info('name');
		$eve_Name = $eve_table->info('name');
		// @todo: Use database query.
		$set5_event_select = $event_table->select()
			->setIntegrityCheck(false)
			->from($member_name, array())
			->joinInner($event_Name, "$event_Name.user_id = $member_name.user_id", array('resource_id'))
			->joinInner($eve_Name, "$eve_Name.event_id = $event_Name.resource_id", array())
			->where($eve_Name . '.user_id != ?', $user_id)
			->where($member_name . '.resource_id = ?', $user_id)
			->where($member_name . '.active = ?', 1)
			->where($eve_Name . ".endtime > FROM_UNIXTIME(?)", time())
			->where($eve_Name . '.search = ?', 1)
			->where($event_Name . '.active = ?', 1)
			->where($event_Name . '.resource_approved = ?', 1)
			->where($event_Name . '.user_approved = ?', 1)
			->where($event_Name .".resource_id NOT IN ($event_str)")
			->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "event" AND `engine4_suggestion_rejected`.`entity_id`= ' . $event_Name . '.resource_id)')
			->group($event_Name . '.resource_id')
			->order($eve_Name . '.'. $set_order[$randum_order])
			->limit($limit);

		$fetch_set5_event = $set5_event_select->query()->fetchAll();
		//$fetch_set5_event = $event_table->fetchAll($set5_event_select);
		foreach($fetch_set5_event as $row_set2_event)
		{
			$this->event_array['event_' . $row_set2_event['resource_id']] = $row_set2_event['resource_id'];

			if(count($this->event_array) == $limit)
			{
				return $this->event_array;
			}
		}
		//	unset($set5_order[$randum_order]);
		//}
		return $this->event_array;
	}


	/** Function call by "Event" main functions.
   * Returns: the event array.
   *
   * @param $disply_event: Event which are display on page.
   * @param $limit: Set limit that how many event will be return.
   * @return Array
   */
	// - Upcoming events belonging to the same category as the one being viewed. [This will only work if the widget is being shown on the "Event Profile" page.]
	public function event_set5($disply_event, $limit)
	{
		if(empty($disply_event))
		{
			$disply_event = 0;
		}
		//Condition for main array.
		if(empty($this->event_array))
		{
			$event_dis_array = 0;
		}
		else
		{
			$event_dis_array = implode(",", $this->event_array);
		}

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$front = Zend_Controller_Front::getInstance();
		$module = $front->getRequest()->getModuleName();
		$action = $front->getRequest()->getActionName();

		if(($module == 'event') && ($action == 'index'))
		{
			$curr_url = $front->getRequest()->getRequestUri();
			$profile_event_url = explode("/", $curr_url);
			//Find out the location of event.
			$profile_event_count = count($profile_event_url) - 1;
			$view_event_id = $profile_event_url[$profile_event_count];

			$event_str = $disply_event . ',' . $event_dis_array . ',' . $view_event_id;

			//Query for find out same event category event

			// Getting the events joined by the user
			$my_event_table = Engine_Api::_()->getItemTable('eventinfo');
			$event_select = $my_event_table->select()
			->from($my_event_table, array('resource_id'))
			->where('user_id = ' . $user_id . '');
			$my_event_fetch = $event_select->query()->fetchAll();
			foreach($my_event_fetch as $row_my_event)
			{
				$event_str .= ',' . $row_my_event['resource_id'];
			}


			$category_event = Engine_Api::_()->getItemTable('event');
			$category_event_select = $category_event->select()
			->from($category_event, array('category_id'))
			->where('event_id = ?',$view_event_id);

			$current_category_array = $category_event_select->query()->fetchall();
			$current_event_category = $current_category_array[0]['category_id'];

			$event_table = Engine_Api::_()->getItemTable('event');
			$event_name = $event_table->info('name');
			// @todo: Use database query.
			$event_category_select = $event_table->select()
				->from($event_table, array('event_id'))
				->where($event_name . '.user_id != ?', $user_id)
				->where($event_name . '.category_id = ?', $current_event_category)
				->where($event_name . ".endtime > FROM_UNIXTIME(?)", time())
				->where($event_name . '.search = ?', 1)
				->where($event_name . ".event_id NOT IN ($event_str)")
				->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "event" AND `engine4_suggestion_rejected`.`entity_id`= ' . $event_name . '.event_id)')
				->limit($limit);

			$fetch_event_id = $event_category_select->query()->fetchall();
			for($i=0; $i<count($fetch_event_id); $i++)
			{
				$this->event_array['event_' . $fetch_event_id[$i]['event_id']] = $fetch_event_id[$i]['event_id'];
				if(count($this->event_array) == $disply_event)
				{
					return $this->event_array;
				}
			}
		}
		return $this->event_array;
	}


	/** Function call by "Event" main functions.
   * Returns: the event array.
   *
   * @param $disply_event: Event which are display on page.
   * @param $limit: Set limit that how many event will be return.
   * @return Array
   */
	// - Upcoming events created by my friends in the order of popularity among friends (with most friends attending).
	public function event_set6($disply_event, $limit)
	{
		if(empty($disply_event))
		{
			$disply_event = 0;
		}
		//Condition for main array.
		if(empty($this->event_array))
		{
			$event_dis_array = 0;
		}
		else
		{
			$event_dis_array = implode(",", $this->event_array);
		}
		$event_str = $disply_event . ',' . $event_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// Getting the events joined by the user
		$my_event_table = Engine_Api::_()->getItemTable('eventinfo');
		$event_select = $my_event_table->select()
		->from($my_event_table, array('resource_id'))
		->where('user_id = ' . $user_id . '');
		$my_event_fetch = $event_select->query()->fetchAll();
		foreach($my_event_fetch as $row_my_event)
		{
			$event_str .= ',' . $row_my_event['resource_id'];
		}

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		$event_table = Engine_Api::_()->getItemTable('event');
		$member_name = $membership_table->info('name');
		$event_Name = $event_table->info('name');
		// @todo: Use database query.
		$set1_event_select = $event_table->select()
		 ->setIntegrityCheck(false)
		 ->from($event_Name, array('event_id','COUNT(' . $member_name . '.user_id) AS friends_event_count'))
	   ->joinInner($member_name, "$member_name.user_id = $event_Name.user_id", array())
	   ->where($event_Name . '.user_id != ?', $user_id)
	   ->where($member_name . '.resource_id = ?', $user_id)
	   ->where($member_name . '.active = ?', 1)
	   ->where($event_Name . ".endtime > FROM_UNIXTIME(?)", time())
	   ->where($event_Name . '.search = ?', 1)
	   ->where($event_Name . ".event_id NOT IN ($event_str)")
	   ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "event" AND `engine4_suggestion_rejected`.`entity_id`= ' . $event_Name . '.event_id)')
	   ->group($event_Name . '.event_id')
	   ->order('friends_event_count DESC')
	   ->limit($limit);

	  $fetch_set1_event = $set1_event_select->query()->fetchAll();
	  foreach($fetch_set1_event as $row_set2_event)
	  {
	  	$this->event_array['event_' . $row_set2_event['event_id']] = $row_set2_event['event_id'];

	  	if(count($this->event_array) == $limit)
			{
				return $this->event_array;
			}
	  }
		return $this->event_array;
	}


   /**
   * Returns: Object of event.
   *
   * @param $event_path_array: Array of event ids.
   * @return Array
   */
	//Return event information.
  public function event_info($event_path_array)
	{
  	$event_users_id = implode(",", $event_path_array);
  	//FETCH RECORD FROM event TABLE
  	$event_table  = Engine_Api::_()->getItemTable('event');
		$select_event_table = $event_table->select()->where("event_id IN ($event_users_id)");
		$event_info_array = $event_table->fetchAll($select_event_table);
  	return $event_info_array;
	}


	 /** EVENT SUGGESTION [APPLY FOR POPUP]
   * Returns: event id array.
   *
   * @param $event_id : event id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
	public function event_suggestion($event_id, $display_user, $number_of_user, $search='')
	{
		$event = Engine_Api::_()->getItem('event', $event_id);
		if($event->search == 1)
		{
			if(empty($display_user))
			{
				$display_user = 0;
			}
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

			$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		  $member_name = $membership_table->info('name');
		  $user_table = Engine_Api::_()->getItemTable('user');
			$user_Name = $user_table->info('name');
		  // @todo : Try to compose the sub-queries written below using Zend's convention
		  // The friend suggested should not be already shown in the popup; he should not be a member of the event already, and he should not have rejected this event as a suggestion.
		  $member_select = $membership_table->select()
		  	->from($member_name, array('user_id'))
				->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
		  	->where($member_name . '.resource_id = ?', $user_id)
		  	->where($member_name . '.active = ?', 1)
		  	->where($member_name . '.user_id NOT IN(' . $display_user . ')')
		  	->where('NOT EXISTS (SELECT `user_id` FROM `engine4_event_membership` WHERE `engine4_event_membership`.`resource_id`=' . $event_id . ' AND `engine4_event_membership`.`active` = 1 AND `engine4_event_membership`.`user_id` = ' . $member_name . '.user_id)')
		  	->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "event" AND `engine4_suggestion_rejected`.`owner_id` = ' . $member_name . '.user_id AND `engine4_suggestion_rejected`.`entity_id` = ' . $event_id . ')')
		  	->where('displayname LIKE ?', '%' . $search . '%');

		  	$fetch_member_myfriend = Zend_Paginator::factory($member_select);
		}
		else
		{
			$fetch_member_myfriend = '';
		}
		return $fetch_member_myfriend;
	}



	protected  $poll_array;
	protected  $poll_set_array;
	 /** Function for "poll Widget" but call only in the case of "Login User".
   * Returns the poll array.
   *
   * @param $display_sugg_str: poll which are display on page.
   * @param $limit: Set limit that how many poll will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function poll_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// Unset "poll function array", if "poll widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->poll_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'poll')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_poll = $mix_dis_str;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$level = 0;
		// The function sets based on their main queries. One of these functions is called randomly to return suggestions
		$this->poll_set_array = array('poll_set1', 'poll_set2', 'poll_set3', 'poll_set4', 'poll_set5');
		while($level != $limit)
		{
			$current_set_id = array_rand($this->poll_set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$poll_fun = $this->poll_set_array[$current_set_id];
			// Calling the randomly picked up function
			$poll_set = $this->$poll_fun($dis_poll, $set_limit);
			//$this->poll_array is the protected array to which all functions add their results
			$level = count($this->poll_array);
			// The randomly picked function which was just called, should not be called again
			unset($this->poll_set_array[$current_set_id]);
			if(count($this->poll_set_array) == 0)
			{
				break;
			}
		}

		if($page == 'mix_sugg')
		{
			if(!empty($this->poll_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->poll_array;
				// Unset the poll array value.
				$array_sugg_key = array_keys($this->poll_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->poll_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->poll_array;
		}
	}


 /** Function for "poll Widget" but call only in the case of "Logout User".
   * Returns the poll array.
   *
   * @param $dis_poll: poll which are display on page.
   * @param $limit: Set limit that how many poll will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function poll_loggedout_suggestions($dis_poll, $limit, $page)
	{
		// Unset "poll function array", if "poll widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->poll_array = array();
		}
		$level = 0;
		// For logged out users, these 2 functions should be called for blok suggestions
		$this->set_array = array('poll_set3');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$poll_fun = $this->set_array[$current_set_id];
			// Calling the randomly picked up function
			$poll_set = $this->$poll_fun($dis_poll, $set_limit);
			//$this->poll_array is the protected array to which all functions add their results
			$level = count($this->poll_array);
			unset($this->set_array[$current_set_id]);
			if(count($this->set_array) == 0)
			{
				break;
			}
		}
		if($page == 'mix_sugg')
		{
			if(!empty($this->poll_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->poll_array;
				// Unset the poll array value.
				$array_sugg_key = array_keys($this->poll_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->poll_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->poll_array;
		}
	}

   /** Function call by "poll" main functions.
   * Returns: the poll array.
   *
   * @param $disply_poll: poll which are display on page.
   * @param $limit: Set limit that how many poll will be return.
   * @return Array
   */
	// - poll Posts "Liked" by my friends in the order of number of friends liking them.
	public function poll_set1($disply_poll, $limit)
	{
		//Condition for display poll on page.
		if(empty($disply_poll)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_poll = 0;
		}
		//Condition for main array.
		if(empty($this->poll_array)) // If none of the other randomly called functions have been called before this
		{
			$poll_dis_array = 0;
		}
		else
		{
			$poll_dis_array = implode(",", $this->poll_array);
		}
		$poll_str = $disply_poll . ',' . $poll_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $poll_like_table = Engine_Api::_()->getItemTable('like');
	  $poll_table = Engine_Api::_()->getItemTable('poll');
	  $poll_name = $poll_table->info('name');
	  $member_name = $membership_table->info('name');
	  $poll_like_name = $poll_like_table->info('name');
	  // @todo: Use database query.
		$set_poll_select = $poll_like_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $member_name . '.user_id) AS friends_poll_count'))
	    ->joinInner($poll_like_name, ''.$poll_like_name.'.poster_id = '.$member_name.'.user_id', array('resource_id'))
	    ->joinInner($poll_name, ''.$poll_name.'.poll_id = '.$poll_like_name.'.resource_id', array())
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($poll_like_name . '.resource_type = ?', 'poll')
	    ->where($poll_name . '.user_id != ?', $user_id)
	    ->where($poll_name .".poll_id NOT IN ($poll_str)")
	    ->where($poll_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "poll" AND `engine4_suggestion_rejected`.`entity_id`= ' . $poll_like_name . '.resource_id)')
	    ->group($poll_like_name . '.resource_id')
	    ->order('friends_poll_count DESC')
	    ->limit($limit);

	  $fetch_set_poll = $set_poll_select->query()->fetchAll();
	  foreach($fetch_set_poll as $row_set_poll)
	  {
	  	$this->poll_array['poll_' . $row_set_poll['resource_id']] = $row_set_poll['resource_id'];

	  	if(count($this->poll_array) == $limit)
			{
				return $this->poll_array;
			}
	  }
		return $this->poll_array;
	}

   /** Function call by "poll" main functions.
   * Returns: the poll array.
   *
   * @param $disply_poll: poll which are display on page.
   * @param $limit: Set limit that how many poll will be return.
   * @return Array
   */
  // - poll created by my friends in the order of vote count Desc.
	// - poll created by my friends in the order of comments count Desc.
	// - poll created by my friends in the order of views count Desc.
	// - poll created by my friends in the order of creation date Desc.
	public function poll_set2($disply_poll, $limit)
	{
		//Condition for display poll on page.
		if(empty($disply_poll)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_poll = 0;
		}
		//Condition for main array.
		if(empty($this->poll_array)) // If none of the other randomly called functions have been called before this
		{
			$poll_dis_array = 0;
		}
		else
		{
			$poll_dis_array = implode(",", $this->poll_array);
		}
		$poll_str = $disply_poll . ',' . $poll_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// @todo : making random ORDER BY
		$set_order = array('vote_count DESC', 'comment_count DESC', 'views DESC', 'creation_date DESC');
		$randum_order = array_rand($set_order, 1);


	  $poll_table = Engine_Api::_()->getItemTable('poll');
	  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $member_name = $membership_table->info('name');
	  $poll_name = $poll_table->info('name');
	  // @todo: Use database query.
		$set_poll_select = $membership_table->select()
			->setIntegrityCheck(false)
	    ->from($membership_table, array())
	    ->joinInner($poll_name, ''.$poll_name.'.user_id = '.$member_name.'.user_id', array('poll_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($poll_name . '.user_id != ?', $user_id)
	    ->where($poll_name .".poll_id NOT IN ($poll_str)")
	    ->where($poll_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "poll" AND `engine4_suggestion_rejected`.`entity_id`= ' . $poll_name . '.poll_id)')
	    ->order($set_order[$randum_order])
	    ->limit($limit);

	  $fetch_set_poll = $set_poll_select->query()->fetchAll();
	  foreach($fetch_set_poll as $row_set_poll)
	  {
	  	$this->poll_array['poll_' . $row_set_poll['poll_id']] = $row_set_poll['poll_id'];

	  	if(count($this->poll_array) == $limit)
			{
				return $this->poll_array;
			}
	  }
		return $this->poll_array;
	}

   /** Function call by "poll" main functions.
   * Returns: the poll array.
   *
   * @param $disply_poll: poll which are display on page.
   * @param $limit: Set limit that how many poll will be return.
   * @return Array
   */
	// - Popular polls (in the order of votes count desc, creation date desc)
	// - Popular polls (in the order of comments count desc, creation date desc)
	// - Popular polls (in the order of views count desc, creation date desc)
	public function poll_set3($disply_poll, $limit)
	{
		//Condition for display poll on page.
		if(empty($disply_poll)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_poll = 0;
		}
		//Condition for main array.
		if(empty($this->poll_array)) // If none of the other randomly called functions have been called before this
		{
			$poll_dis_array = 0;
		}
		else
		{
			$poll_dis_array = implode(",", $this->poll_array);
		}
		$poll_str = $disply_poll . ',' . $poll_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('vote_count DESC', 'comment_count DESC','views DESC');
		$randum_order = array_rand($set_order, 1);


	  $poll_table = Engine_Api::_()->getItemTable('poll');
	  $poll_name = $poll_table->info('name');
	  // @todo: Use database query.
		$set_poll_select = $poll_table->select()
	    ->from($poll_table, array('poll_id'))
	    ->where($poll_name .".poll_id NOT IN ($poll_str)")
	    ->where($poll_name . '.user_id != ?', $user_id)
	    ->where($poll_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "poll" AND `engine4_suggestion_rejected`.`entity_id`= ' . $poll_name . '.poll_id)')
	    ->order($set_order[$randum_order])
	    ->order('creation_date DESC')
	    ->limit($limit);

	  $fetch_set_poll = $set_poll_select->query()->fetchAll();
	  foreach($fetch_set_poll as $row_set_poll)
	  {
	  	$this->poll_array['poll_' . $row_set_poll['poll_id']] = $row_set_poll['poll_id'];

	  	if(count($this->poll_array) == $limit)
			{
				return $this->poll_array;
			}
	  }
		return $this->poll_array;
	}

   /** Function call by "poll" main functions.
   * Returns: the poll array.
   *
   * @param $disply_poll: poll which are display on page.
   * @param $limit: Set limit that how many poll will be return.
   * @return Array
   */
	// - poll Posts commented on by my friends (in the order of comments count Desc)
	public function poll_set4($disply_poll, $limit)
	{
		//Condition for display poll on page.
		if(empty($disply_poll)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_poll = 0;
		}
		//Condition for main array.
		if(empty($this->poll_array)) // If none of the other randomly called functions have been called before this
		{
			$poll_dis_array = 0;
		}
		else
		{
			$poll_dis_array = implode(",", $this->poll_array);
		}
		$poll_str = $disply_poll . ',' . $poll_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $poll_comment_table = Engine_Api::_()->getItemTable('comment');
	  $poll_table = Engine_Api::_()->getItemTable('poll');
	  $poll_name = $poll_table->info('name');
	  $member_name = $membership_table->info('name');
	  $poll_comment_name = $poll_comment_table->info('name');
	  // @todo: Use database query.
		$set_poll_select = $poll_comment_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $poll_comment_name . '.poster_id) AS friends_poll_count'))
	    ->joinInner($poll_comment_name, ''.$poll_comment_name.'.poster_id = '.$member_name.'.user_id', array())
	    ->joinInner($poll_name, ''.$poll_name.'.poll_id = '.$poll_comment_name.'.resource_id', array('poll_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($poll_comment_name . '.resource_type = ?', 'poll')
	    ->where($poll_name . '.user_id != ?', $user_id)
	    ->where($poll_name .".poll_id NOT IN ($poll_str)")
	    ->where($poll_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "poll" AND `engine4_suggestion_rejected`.`entity_id`= ' . $poll_name . '.poll_id)')
	    ->group($poll_comment_name . '.resource_id')
	    ->order('friends_poll_count DESC')
	    ->limit($limit);

	  $fetch_set_poll = $set_poll_select->query()->fetchAll();
	  foreach($fetch_set_poll as $row_set_poll)
	  {
	  	$this->poll_array['poll_' . $row_set_poll['poll_id']] = $row_set_poll['poll_id'];

	  	if(count($this->poll_array) == $limit)
			{
				return $this->poll_array;
			}
	  }
		return $this->poll_array;
	}


   /** Function call by "poll" main functions.
   * Returns: the poll array.
   *
   * @param $disply_poll: poll which are display on page.
   * @param $limit: Set limit that how many poll will be return.
   * @return Array
   */
	// - Polls voted on by my friends in the order of number of friends voted on them.
	public function poll_set5($disply_poll, $limit)
	{
		//Condition for display poll on page.
		if(empty($disply_poll)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_poll = 0;
		}
		//Condition for main array.
		if(empty($this->poll_array)) // If none of the other randomly called functions have been called before this
		{
			$poll_dis_array = 0;
		}
		else
		{
			$poll_dis_array = implode(",", $this->poll_array);
		}
		$poll_str = $disply_poll . ',' . $poll_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $poll_table = Engine_Api::_()->getItemTable('poll');
	  $poll_name = $poll_table->info('name');
	  $member_name = $membership_table->info('name');
	  $poll_vote = Engine_Api::_()->getDbtable('votes', 'poll');
	  $poll_vote_name = $poll_vote->info('name');
	  // @todo: Use database query.
		$set_poll_select = $poll_vote->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $poll_vote_name . '.user_id) AS friends_vote_count'))
	    ->joinInner($poll_vote_name, ''.$poll_vote_name.'.user_id = '.$member_name.'.user_id', array('poll_id'))
	    ->joinInner($poll_name, ''.$poll_name.'.poll_id = '.$poll_vote_name.'.poll_id', array())
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($poll_name . '.user_id != ?', $user_id)
	    ->where($poll_name .".poll_id NOT IN ($poll_str)")
	    ->where($poll_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "poll" AND `engine4_suggestion_rejected`.`entity_id`= ' . $poll_name . '.poll_id)')
	    ->group($poll_vote_name . '.poll_id')
	    ->order('friends_vote_count DESC')
	    ->limit($limit);

	  $fetch_set_poll = $set_poll_select->query()->fetchAll();
	  foreach($fetch_set_poll as $row_set_poll)
	  {
	  	$this->poll_array['poll_' . $row_set_poll['poll_id']] = $row_set_poll['poll_id'];

	  	if(count($this->poll_array) == $limit)
			{
				return $this->poll_array;
			}
	  }
		return $this->poll_array;
	}

   /** This popup comes when the user joins a poll, and asks the user to suggest this poll to other friends. This function is also called when "X" is clicked for an entry
   * Returns: poll id array.
   *
   * @param $poll_id : poll id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
	public function poll_suggestion($poll_id, $display_user, $number_of_user, $search='')
	{
		$poll = Engine_Api::_()->getItem('poll', $poll_id);
			if(empty($display_user))
			{
				$display_user = 0;
			}
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

			$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		  $member_name = $membership_table->info('name');
		  $user_table = Engine_Api::_()->getItemTable('user');
			$user_Name = $user_table->info('name');
		  // @todo : Try to compose the sub-queries written below using Zend's convention
		  // The friend suggested should not be already shown in the popup; he should not be a member of the event already, and he should not have rejected this event as a suggestion.
		  $member_select = $membership_table->select()
		  	->from($member_name, array('user_id'))
				->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
		  	->where($member_name . '.resource_id = ?', $user_id)
		  	->where($member_name . '.active = ?', 1)
		  	->where($member_name . '.user_id NOT IN(' . $display_user . ')')
		  	->where('displayname LIKE ?', '%' . $search . '%');

			$fetch_member_myfriend = Zend_Paginator::factory($member_select);
			if(empty($fetch_member_myfriend))
			{
				$fetch_member_myfriend = '';
 			}
			return $fetch_member_myfriend;
	}

   /**
   * Returns: Object of poll.
   *
   * @param $path_array: Array of poll ids.
   * @return Array
   */
  public function poll_info($poll_path_array)
	{
  	$poll_users_id = implode(",", $poll_path_array);
  	//FETCH RECORD FROM poll TABLE
  	$poll_table  = Engine_Api::_()->getItemTable('poll');
		$select_poll_table = $poll_table->select()->where("poll_id IN ($poll_users_id)");
		$poll_info_array = $poll_table->fetchAll($select_poll_table);
  	return $poll_info_array;
	}



	protected  $forum_array;
	protected  $forum_set_array;
	 /** Function for "forum Widget" but call only in the case of "Login User".
   * Returns the forum array.
   *
   * @param $display_sugg_str: forum which are display on page.
   * @param $limit: Set limit that how many forum will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function forum_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// Unset "forum function array", if "forum widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->forum_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'forum')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_forum = $mix_dis_str;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$level = 0;
		// The function sets based on their main queries. One of these functions is called randomly to return suggestions
		$this->forum_set_array = array('forum_set1', 'forum_set2', 'forum_set3', 'forum_set4', 'forum_set5');
		while($level != $limit)
		{
			$current_set_id = array_rand($this->forum_set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$forum_fun = $this->forum_set_array[$current_set_id];
			// Calling the randomly picked up function
			$forum_set = $this->$forum_fun($dis_forum, $set_limit);
			//$this->forum_array is the protected array to which all functions add their results
			$level = count($this->forum_array);
			// The randomly picked function which was just called, should not be called again
			unset($this->forum_set_array[$current_set_id]);
			if(count($this->forum_set_array) == 0)
			{
				break;
			}
		}

		if($page == 'mix_sugg')
		{
			if(!empty($this->forum_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->forum_array;
				// Unset the forum array value.
				$array_sugg_key = array_keys($this->forum_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->forum_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->forum_array;
		}
	}


 /** Function for "forum Widget" but call only in the case of "Logout User".
   * Returns the forum array.
   *
   * @param $dis_forum: forum which are display on page.
   * @param $limit: Set limit that how many forum will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function forum_loggedout_suggestions($dis_forum, $limit, $page)
	{
		// Unset "forum function array", if "forum widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->forum_array = array();
		}
		$level = 0;
		// For logged out users, these 2 functions should be called for blok suggestions
		$this->set_array = array('forum_set2');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$forum_fun = $this->set_array[$current_set_id];
			// Calling the randomly picked up function
			$forum_set = $this->$forum_fun($dis_forum, $set_limit);
			//$this->forum_array is the protected array to which all functions add their results
			$level = count($this->forum_array);
			unset($this->set_array[$current_set_id]);
			if(count($this->set_array) == 0)
			{
				break;
			}
		}
		if($page == 'mix_sugg')
		{
			if(!empty($this->forum_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->forum_array;
				// Unset the forum array value.
				$array_sugg_key = array_keys($this->forum_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->forum_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->forum_array;
		}
	}

   /** Function call by "form" main functions.
   * Returns: the form array.
   *
   * @param $disply_form: form which are display on page.
   * @param $limit: Set limit that how many form will be return.
   * @return Array
   */
	// - Forum Topics created by my friends in the order of comments/replies count Desc.
	// - Forum Topics created by my friends in the order of views count Desc.
	// - Forum Topics created by my friends in the order of creation date Desc.
	public function forum_set1($disply_form, $limit)
	{
		//Condition for display form on page.
		if(empty($disply_form)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_form = 0;
		}
		//Condition for main array.
		if(empty($this->form_array)) // If none of the other randomly called functions have been called before this
		{
			$form_dis_array = 0;
		}
		else
		{
			$form_dis_array = implode(",", $this->form_array);
		}
		$form_str = $disply_form . ',' . $form_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// @todo : making random ORDER BY
		$set_order = array('post_count DESC', 'view_count DESC', 'creation_date DESC');
		$randum_order = array_rand($set_order, 1);


	  $form_table = Engine_Api::_()->getItemTable('forum_topic');
	  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $member_name = $membership_table->info('name');
	  $form_name = $form_table->info('name');
	  // @todo: Use database query.
		$set_form_select = $membership_table->select()
			->setIntegrityCheck(false)
	    ->from($membership_table, array())
	    ->joinInner($form_name, ''.$form_name.'.user_id = '.$member_name.'.user_id', array('topic_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($form_name . '.user_id != ?', $user_id)
	    ->where($form_name .".topic_id NOT IN ($form_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "forum" AND `engine4_suggestion_rejected`.`entity_id`= ' . $form_name . '.topic_id)')
	    ->order($set_order[$randum_order])
	    ->limit($limit);

	  $fetch_set_form = $set_form_select->query()->fetchAll();
	  foreach($fetch_set_form as $row_set_form)
	  {
	  	$this->forum_array['forum_' . $row_set_form['topic_id']] = $row_set_form['topic_id'];

	  	if(count($this->forum_array) == $limit)
			{
				return $this->forum_array;
			}
	  }
		return $this->forum_array;
	}

   /** Function call by "form" main functions.
   * Returns: the form array.
   *
   * @param $disply_form: form which are display on page.
   * @param $limit: Set limit that how many form will be return.
   * @return Array
   */
	// - Popular Forum Topics (in the order of comments/replies count desc, creation date desc)
	// - Popular Forum Topics (in the order of views count desc, creation date desc)
	public function forum_set2($disply_forum, $limit)
	{
		//Condition for display forum on page.
		if(empty($disply_forum)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_forum = 0;
		}
		//Condition for main array.
		if(empty($this->forum_array)) // If none of the other randomly called functions have been called before this
		{
			$forum_dis_array = 0;
		}
		else
		{
			$forum_dis_array = implode(",", $this->forum_array);
		}
		$forum_str = $disply_forum . ',' . $forum_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('view_count DESC', 'post_count DESC');
		$randum_order = array_rand($set_order, 1);


	  $forum_table = Engine_Api::_()->getItemTable('forum_topic');
	  $forum_name = $forum_table->info('name');
	  // @todo: Use database query.
		$set_forum_select = $forum_table->select()
	    ->from($forum_table, array('topic_id'))
	    ->where($forum_name .".topic_id NOT IN ($forum_str)")
	    ->where($forum_name . '.user_id != ?', $user_id)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "forum" AND `engine4_suggestion_rejected`.`entity_id`= ' . $forum_name . '.topic_id)')
	    ->order($set_order[$randum_order])
	    ->order('creation_date DESC')
	    ->limit($limit);
	  $fetch_set_forum = $set_forum_select->query()->fetchAll();
	  foreach($fetch_set_forum as $row_set_forum)
	  {
	  	$this->forum_array['forum_' . $row_set_forum['topic_id']] = $row_set_forum['topic_id'];

	  	if(count($this->forum_array) == $limit)
			{
				return $this->forum_array;
			}
	  }
		return $this->forum_array;
	}

   /** Function call by "forum" main functions.
   * Returns: the forum array.
   *
   * @param $disply_forum: forum which are display on page.
   * @param $limit: Set limit that how many forum will be return.
   * @return Array
   */
	// - Forum Topics commented on/replied to by my friends (in the order of comments/replies count Desc)
	public function forum_set3($disply_forum, $limit)
	{
		//Condition for display forum on page.
		if(empty($disply_forum)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_forum = 0;
		}
		//Condition for main array.
		if(empty($this->forum_array)) // If none of the other randomly called functions have been called before this
		{
			$forum_dis_array = 0;
		}
		else
		{
			$forum_dis_array = implode(",", $this->forum_array);
		}
		$forum_str = $disply_forum . ',' . $forum_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $forum_post_table = Engine_Api::_()->getItemTable('forum_post');
	  $forum_table = Engine_Api::_()->getItemTable('forum_topic');
	  $forum_name = $forum_table->info('name');
	  $member_name = $membership_table->info('name');
	  $forum_post_name = $forum_post_table->info('name');
	  // @todo: Use database query.
		$set_forum_select = $forum_post_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $forum_post_name . '.user_id) AS friends_topic_count'))
	    ->joinInner($forum_post_name, ''.$forum_post_name.'.user_id = '.$member_name.'.user_id', array('topic_id'))
	    ->joinInner($forum_name, ''.$forum_post_name.'.topic_id = '.$forum_name.'.topic_id', null)
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($forum_name . '.user_id != ?', $user_id)
	    ->where($forum_post_name . '.user_id != ?', $user_id)
	    ->where($forum_post_name .".topic_id NOT IN ($forum_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "forum" AND `engine4_suggestion_rejected`.`entity_id`= ' . $forum_post_name . '.topic_id)')
	    ->group($forum_post_name . '.topic_id')
	    ->order('friends_topic_count DESC')
	    ->limit($limit);

	  $fetch_set_forum = $set_forum_select->query()->fetchAll();
	  foreach($fetch_set_forum as $row_set_forum)
	  {
	  	$this->forum_array['forum_' . $row_set_forum['topic_id']] = $row_set_forum['topic_id'];

	  	if(count($this->forum_array) == $limit)
			{
				return $this->forum_array;
			}
	  }
		return $this->forum_array;
	}


   /** Function call by "forum" main functions.
   * Returns: the forum array.
   *
   * @param $disply_forum: forum which are display on page.
   * @param $limit: Set limit that how many forum will be return.
   * @return Array
   */
	// - Forum Topics viewed by my friends (in the order of views count Desc)
	public function forum_set4($disply_forum, $limit)
	{
		//Condition for display forum on page.
		if(empty($disply_forum)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_forum = 0;
		}
		//Condition for main array.
		if(empty($this->forum_array)) // If none of the other randomly called functions have been called before this
		{
			$forum_dis_array = 0;
		}
		else
		{
			$forum_dis_array = implode(",", $this->forum_array);
		}
		$forum_str = $disply_forum . ',' . $forum_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $forum_view_table = Engine_Api::_()->getDbtable('topicviews', 'forum');
	  $forum_table = Engine_Api::_()->getItemTable('forum_topic');
	  $forum_name = $forum_table->info('name');
	  $member_name = $membership_table->info('name');
	  $forum_view_name = $forum_view_table->info('name');
	  // @todo: Use database query.
		$set_forum_select = $forum_view_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $forum_view_name . '.user_id) AS friends_view_count'))
	    ->joinInner($forum_view_name, ''.$forum_view_name.'.user_id = '.$member_name.'.user_id', array('topic_id'))
	    ->joinInner($forum_name, ''.$forum_view_name.'.topic_id = '.$forum_name.'.topic_id', null)
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($forum_name . '.user_id != ?', $user_id)
	    ->where($forum_view_name . '.user_id != ?', $user_id)
	    ->where($forum_view_name .".topic_id NOT IN ($forum_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "forum" AND `engine4_suggestion_rejected`.`entity_id`= ' . $forum_view_name . '.topic_id)')
	    ->group($forum_view_name . '.topic_id')
	    ->order('friends_view_count DESC')
	    ->limit($limit);
	  $fetch_set_forum = $set_forum_select->query()->fetchAll();
	  foreach($fetch_set_forum as $row_set_forum)
	  {
	  	$this->forum_array['forum_' . $row_set_forum['topic_id']] = $row_set_forum['topic_id'];

	  	if(count($this->forum_array) == $limit)
			{
				return $this->forum_array;
			}
	  }
		return $this->forum_array;
	}

   /** Function call by "forum" main functions.
   * Returns: the forum array.
   *
   * @param $disply_forum: forum which are display on page.
   * @param $limit: Set limit that how many forum will be return.
   * @return Array
   */
	// - Forum Topics commented on/replied to by my friends (in the order of their views count Desc)
	public function forum_set5($disply_forum, $limit)
	{
		//Condition for display forum on page.
		if(empty($disply_forum)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_forum = 0;
		}
		//Condition for main array.
		if(empty($this->forum_array)) // If none of the other randomly called functions have been called before this
		{
			$forum_dis_array = 0;
		}
		else
		{
			$forum_dis_array = implode(",", $this->forum_array);
		}
		$forum_str = $disply_forum . ',' . $forum_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $forum_post_table = Engine_Api::_()->getItemTable('forum_post');
	  $forum_topic_table  = Engine_Api::_()->getItemTable('forum_topic');
	  $topic_name = $forum_topic_table->info('name');
	  $member_name = $membership_table->info('name');
	  $forum_post_name = $forum_post_table->info('name');
	  // @todo: Use database query.
		$set_forum_select = $forum_post_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array())
	    ->joinInner($forum_post_name, ''.$forum_post_name.'.user_id = '.$member_name.'.user_id', array('topic_id'))
	    ->joinInner($topic_name, ''.$topic_name.'.topic_id = '.$forum_post_name.'.topic_id', array())
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($topic_name . '.user_id != ?', $user_id)
	    ->where($forum_post_name .".topic_id NOT IN ($forum_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "forum" AND `engine4_suggestion_rejected`.`entity_id`= ' . $forum_post_name . '.topic_id)')
	    ->group($forum_post_name . '.topic_id')
	    ->order($topic_name . '.view_count DESC')
	    ->limit($limit);

	  $fetch_set_forum = $set_forum_select->query()->fetchAll();
	  foreach($fetch_set_forum as $row_set_forum)
	  {
	  	$this->forum_array['forum_' . $row_set_forum['topic_id']] = $row_set_forum['topic_id'];

	  	if(count($this->forum_array) == $limit)
			{
				return $this->forum_array;
			}
	  }
		return $this->forum_array;
	}

   /** This popup comes when the user joins a forum, and asks the user to suggest this forum to other friends. This function is also called when "X" is clicked for an entry
   * Returns: forum id array.
   *
   * @param $forum_id : forum id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
	public function forum_suggestion($topic_id, $display_user, $number_of_user, $search='')
	{
		if(empty($display_user))
		{
			$display_user = 0;
		}
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $member_name = $membership_table->info('name');
	  $user_table = Engine_Api::_()->getItemTable('user');
		$user_Name = $user_table->info('name');
	  // @todo : Try to compose the sub-queries written below using Zend's convention
	  // The friend suggested should not be already shown in the popup; he should not be a member of the event already, and he should not have rejected this event as a suggestion.
	  $member_select = $membership_table->select()
	  	->from($member_name, array('user_id'))
			->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
	  	->where($member_name . '.resource_id = ?', $user_id)
	  	->where($member_name . '.active = ?', 1)
	  	->where($member_name . '.user_id NOT IN(' . $display_user . ')')
	  	->where('NOT EXISTS (SELECT `user_id` FROM `engine4_forum_posts` WHERE `engine4_forum_posts`.`topic_id`=' . $topic_id . ' AND `engine4_forum_posts`.`user_id` = ' . $member_name . '.user_id)')
	  	->where('displayname LIKE ?', '%' . $search . '%');
		 $fetch_member_myfriend = Zend_Paginator::factory($member_select);
		//$fetch_member_myfriend = $member_select->query()->fetchAll();
		if(empty($fetch_member_myfriend))
		{
		   $fetch_member_myfriend = '';
		}
		return $fetch_member_myfriend;
	}

   /**
   * Returns: Object of forum.
   *
   * @param $path_array: Array of forum ids.
   * @return Array
   */
  public function forum_info($forum_path_array)
	{
  	$forum_users_id = implode(",", $forum_path_array);
  	//FETCH RECORD FROM forum TABLE
  	$forum_table  = Engine_Api::_()->getItemTable('forum_topic');
		$select_forum_table = $forum_table->select()->where("topic_id IN ($forum_users_id)");
		$forum_info_array = $forum_table->fetchAll($select_forum_table);
  	return $forum_info_array;
	}

	protected  $blog_array;
	protected  $blog_set_array;


 /** Function for "blog Widget" but call only in the case of "Login User".
   * Returns the blog array.
   *
   * @param $display_sugg_str: blog which are display on page.
   * @param $limit: Set limit that how many blog will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function blog_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// Unset "blog function array", if "blog widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->blog_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'blog')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_blog = $mix_dis_str;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$level = 0;
		// The function sets based on their main queries. One of these functions is called randomly to return suggestions
		$this->blog_set_array = array('blog_set1','blog_set2','blog_set3','blog_set4');
		while($level != $limit)
		{
			$current_set_id = array_rand($this->blog_set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$blog_fun = $this->blog_set_array[$current_set_id];
			// Calling the randomly picked up function
			$blog_set = $this->$blog_fun($dis_blog, $set_limit);
			//$this->blog_array is the protected array to which all functions add their results
			$level = count($this->blog_array);
			// The randomly picked function which was just called, should not be called again
			unset($this->blog_set_array[$current_set_id]);
			if(count($this->blog_set_array) == 0)
			{
				break;
			}
		}

		if($page == 'mix_sugg')
		{
			if(!empty($this->blog_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->blog_array;
				// Unset the blog array value.
				$array_sugg_key = array_keys($this->blog_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->blog_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->blog_array;
		}
	}

 /** Function for "blog Widget" but call only in the case of "Logout User".
   * Returns the blog array.
   *
   * @param $dis_blog: blog which are display on page.
   * @param $limit: Set limit that how many blog will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function blog_loggedout_suggestions($dis_blog, $limit, $page)
	{
		// Unset "blog function array", if "blog widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->blog_array = array();
		}
		$level = 0;
		// For logged out users, these 2 functions should be called for blok suggestions
		$this->set_array = array('blog_set3');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$blog_fun = $this->set_array[$current_set_id];
			// Calling the randomly picked up function
			$blog_set = $this->$blog_fun($dis_blog, $set_limit);
			//$this->blog_array is the protected array to which all functions add their results
			$level = count($this->blog_array);
			unset($this->set_array[$current_set_id]);
			if(count($this->set_array) == 0)
			{
				break;
			}
		}
		if($page == 'mix_sugg')
		{
			if(!empty($this->blog_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->blog_array;
				// Unset the blog array value.
				$array_sugg_key = array_keys($this->blog_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->blog_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->blog_array;
		}
	}

   /** Function call by "blog" main functions.
   * Returns: the blog array.
   *
   * @param $disply_blog: blog which are display on page.
   * @param $limit: Set limit that how many blog will be return.
   * @return Array
   */
	// - Blog Posts "Liked" by my friends in the order of number of friends liking them.
	public function blog_set1($disply_blog, $limit)
	{
		//Condition for display blog on page.
		if(empty($disply_blog)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_blog = 0;
		}
		//Condition for main array.
		if(empty($this->blog_array)) // If none of the other randomly called functions have been called before this
		{
			$blog_dis_array = 0;
		}
		else
		{
			$blog_dis_array = implode(",", $this->blog_array);
		}
		$blog_str = $disply_blog . ',' . $blog_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $blog_like_table = Engine_Api::_()->getItemTable('like');
	  $blog_table = Engine_Api::_()->getItemTable('blog');
	  $blog_name = $blog_table->info('name');
	  $member_name = $membership_table->info('name');
	  $blog_like_name = $blog_like_table->info('name');
	  // @todo: Use database query.
		$set_blog_select = $blog_like_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $member_name . '.user_id) AS friends_blog_count'))
	    ->joinInner($blog_like_name, ''.$blog_like_name.'.poster_id = '.$member_name.'.user_id', array('resource_id'))
	    ->joinInner($blog_name, ''.$blog_name.'.blog_id = '.$blog_like_name.'.resource_id', array())
	    ->where($blog_name . '.owner_id != ?', $user_id)
	    ->where($blog_name .".blog_id NOT IN ($blog_str)")
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($blog_like_name . '.resource_type = ?', 'blog')
	    ->where($blog_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "blog" AND `engine4_suggestion_rejected`.`entity_id`= ' . $blog_like_name . '.resource_id)')
	    ->group($blog_like_name . '.resource_id')
	    ->order('friends_blog_count DESC')
	    ->limit($limit);

	  $fetch_set_blog = $set_blog_select->query()->fetchAll();
	  foreach($fetch_set_blog as $row_set_blog)
	  {
	  	$this->blog_array['blog_' . $row_set_blog['resource_id']] = $row_set_blog['resource_id'];

	  	if(count($this->blog_array) == $limit)
			{
				return $this->blog_array;
			}
	  }
		return $this->blog_array;
	}

   /** Function call by "blog" main functions.
   * Returns: the blog array.
   *
   * @param $disply_blog: blog which are display on page.
   * @param $limit: Set limit that how many blog will be return.
   * @return Array
   */
	// - Blog Posts created by my friends in the order of comments count Desc.
	// - Blog Posts created by my friends in the order of views count Desc.
	// - Blog Posts created by my friends in the order of creation date Desc.
	public function blog_set2($disply_blog, $limit)
	{
		//Condition for display blog on page.
		if(empty($disply_blog)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_blog = 0;
		}
		//Condition for main array.
		if(empty($this->blog_array)) // If none of the other randomly called functions have been called before this
		{
			$blog_dis_array = 0;
		}
		else
		{
			$blog_dis_array = implode(",", $this->blog_array);
		}
		$blog_str = $disply_blog . ',' . $blog_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// @todo : making random ORDER BY
		$set_order = array('comment_count DESC', 'view_count DESC', 'creation_date DESC');
		$randum_order = array_rand($set_order, 1);


	  $blog_table = Engine_Api::_()->getItemTable('blog');
	  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $member_name = $membership_table->info('name');
	  $blog_name = $blog_table->info('name');
	  // @todo: Use database query.
		$set_blog_select = $membership_table->select()
			->setIntegrityCheck(false)
	    ->from($membership_table, array())
	    ->joinInner($blog_name, ''.$blog_name.'.owner_id = '.$member_name.'.user_id', array('blog_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($blog_name . '.owner_id != ?', $user_id)
	    ->where($blog_name .".blog_id NOT IN ($blog_str)")
	    ->where($blog_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "blog" AND `engine4_suggestion_rejected`.`entity_id`= ' . $blog_name . '.blog_id)')
	    ->order($set_order[$randum_order])
	    ->limit($limit);

	  $fetch_set_blog = $set_blog_select->query()->fetchAll();
	  foreach($fetch_set_blog as $row_set_blog)
	  {
	  	$this->blog_array['blog_' . $row_set_blog['blog_id']] = $row_set_blog['blog_id'];

	  	if(count($this->blog_array) == $limit)
			{
				return $this->blog_array;
			}
	  }
		return $this->blog_array;
	}

   /** Function call by "blog" main functions.
   * Returns: the blog array.
   *
   * @param $disply_blog: blog which are display on page.
   * @param $limit: Set limit that how many blog will be return.
   * @return Array
   */
	// - Popular Blogs (in the order of comments count desc, creation date desc)
	// - Popular Blogs (in the order of views count desc, creation date desc)
	public function blog_set3($disply_blog, $limit)
	{
		//Condition for display blog on page.
		if(empty($disply_blog)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_blog = 0;
		}
		//Condition for main array.
		if(empty($this->blog_array)) // If none of the other randomly called functions have been called before this
		{
			$blog_dis_array = 0;
		}
		else
		{
			$blog_dis_array = implode(",", $this->blog_array);
		}
		$blog_str = $disply_blog . ',' . $blog_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('comment_count DESC','view_count DESC');
		$randum_order = array_rand($set_order, 1);


	  $blog_table = Engine_Api::_()->getItemTable('blog');
	  $blog_name = $blog_table->info('name');
	  // @todo: Use database query.
		$set_blog_select = $blog_table->select()
	    ->from($blog_table, array('blog_id'))
	    ->where($blog_name .".blog_id NOT IN ($blog_str)")
	    ->where($blog_name . '.owner_id != ?', $user_id)
	    ->where($blog_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "blog" AND `engine4_suggestion_rejected`.`entity_id`= ' . $blog_name . '.blog_id)')
	    ->order($set_order[$randum_order])
	    ->order('creation_date DESC')
	    ->limit($limit);

	  $fetch_set_blog = $set_blog_select->query()->fetchAll();
	  foreach($fetch_set_blog as $row_set_blog)
	  {
	  	$this->blog_array['blog_' . $row_set_blog['blog_id']] = $row_set_blog['blog_id'];

	  	if(count($this->blog_array) == $limit)
			{
				return $this->blog_array;
			}
	  }
		return $this->blog_array;
	}

   /** Function call by "blog" main functions.
   * Returns: the blog array.
   *
   * @param $disply_blog: blog which are display on page.
   * @param $limit: Set limit that how many blog will be return.
   * @return Array
   */
	// - Blog Posts commented on by my friends (in the order of comments count Desc)
	public function blog_set4($disply_blog, $limit)
	{
		//Condition for display blog on page.
		if(empty($disply_blog)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_blog = 0;
		}
		//Condition for main array.
		if(empty($this->blog_array)) // If none of the other randomly called functions have been called before this
		{
			$blog_dis_array = 0;
		}
		else
		{
			$blog_dis_array = implode(",", $this->blog_array);
		}
		$blog_str = $disply_blog . ',' . $blog_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $blog_comment_table = Engine_Api::_()->getItemTable('comment');
	  $blog_table = Engine_Api::_()->getItemTable('blog');
	  $blog_name = $blog_table->info('name');
	  $member_name = $membership_table->info('name');
	  $blog_comment_name = $blog_comment_table->info('name');
	  // @todo: Use database query.
		$set_blog_select = $blog_comment_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $blog_comment_name . '.poster_id) AS friends_blog_count'))
	    ->joinInner($blog_comment_name, ''.$blog_comment_name.'.poster_id = '.$member_name.'.user_id', array())
	    ->joinInner($blog_name, ''.$blog_name.'.blog_id = '.$blog_comment_name.'.resource_id', array('blog_id'))
	    ->where($blog_name . '.owner_id != ?', $user_id)
	    ->where($blog_name .".blog_id NOT IN ($blog_str)")
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($blog_comment_name . '.resource_type = ?', 'blog')
	    ->where($blog_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "blog" AND `engine4_suggestion_rejected`.`entity_id`= ' . $blog_name . '.blog_id)')
	    ->group($blog_comment_name . '.resource_id')
	    ->order('friends_blog_count DESC')
	    ->limit($limit);

	  $fetch_set_blog = $set_blog_select->query()->fetchAll();
	  foreach($fetch_set_blog as $row_set_blog)
	  {
	  	$this->blog_array['blog_' . $row_set_blog['blog_id']] = $row_set_blog['blog_id'];

	  	if(count($this->blog_array) == $limit)
			{
				return $this->blog_array;
			}
	  }
		return $this->blog_array;
	}

   /** This popup comes when the user joins a blog, and asks the user to suggest this blog to other friends. This function is also called when "X" is clicked for an entry
   * Returns: blog id array.
   *
   * @param $blog_id : blog id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
	public function blog_suggestion($blog_id, $display_user, $number_of_user, $search = '')
	{
		$blog = Engine_Api::_()->getItem('blog', $blog_id);
		if($blog->search == 1)
		{
			//$can_reply = $this->view->can_reply = $userBlock->block_comment;
			if(empty($display_user))
			{
				$display_user = 0;
			}
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

			$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		  $member_name = $membership_table->info('name');
		  $user_table = Engine_Api::_()->getItemTable('user');
			$user_Name = $user_table->info('name');
		  // @todo : Try to compose the sub-queries written below using Zend's convention
		  // The friend suggested should not be already shown in the popup; he should not be a member of the event already, and he should not have rejected this event as a suggestion.
		  $member_select = $membership_table->select()
		  	->from($member_name, array('user_id'))
				->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
		  	->where($member_name . '.resource_id = ?', $user_id)
		  	->where($member_name . '.active = ?', 1)
		  	->where($member_name . '.user_id NOT IN(' . $display_user . ')')
		  	->where('displayname LIKE ?', '%' . $search . '%');
		  	$fetch_member_myfriend = Zend_Paginator::factory($member_select);
		}
		else
		{
			$fetch_member_myfriend = '';
		}
		return $fetch_member_myfriend;
	}

   /**
   * Returns: Object of blog.
   *
   * @param $path_array: Array of blog ids.
   * @return Array
   */
  public function blog_info($blog_path_array)
	{
  	$blog_users_id = implode(",", $blog_path_array);
  	//FETCH RECORD FROM blog TABLE
  	$blog_table  = Engine_Api::_()->getItemTable('blog');
		$select_blog_table = $blog_table->select()->where("blog_id IN ($blog_users_id)");
		$blog_info_array = $blog_table->fetchAll($select_blog_table);
  	return $blog_info_array;
	}

	protected $album_array;
	protected $album_set_array;


 /** Function for "Album Widget" but call only in the case of "Login User".
   * Returns the album array.
   *
   * @param $display_sugg_str: album which are display on page.
   * @param $limit: Set limit that how many album will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function album_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// Unset "album function array", if "album widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->album_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'album')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_album = $mix_dis_str;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$level = 0;
		// The function sets based on their main queries. One of these functions is called randomly to return suggestions
		$this->album_set_array = array('album_set1', 'album_set2', 'album_set3', 'album_set4', 'album_set5');
		while($level != $limit)
		{
			$current_set_id = array_rand($this->album_set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$album_fun = $this->album_set_array[$current_set_id];
			// Calling the randomly picked up function
			$album_set = $this->$album_fun($dis_album, $set_limit);
			//$this->album_array is the protected array to which all functions add their results
			$level = count($this->album_array);
			// The randomly picked function which was just called, should not be called again
			unset($this->album_set_array[$current_set_id]);
			if(count($this->album_set_array) == 0)
			{
				break;
			}
		}

		if($page == 'mix_sugg')
		{
			if(!empty($this->album_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->album_array;
				// Unset the album array value.
				$array_sugg_key = array_keys($this->album_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->album_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->album_array;
		}
	}


 /** Function for "Album Widget" but call only in the case of "Logout User".
   * Returns the album array.
   *
   * @param $dis_album: album which are display on page.
   * @param $limit: Set limit that how many album will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function album_loggedout_suggestions($dis_album, $limit, $page)
	{
		// Unset "album function array", if "album widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->album_array = array();
		}
		$level = 0;
		// For logged out users, these 2 functions should be called for blok suggestions
		$this->set_array = array('album_set3');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$album_fun = $this->set_array[$current_set_id];
			// Calling the randomly picked up function
			$album_set = $this->$album_fun($dis_album, $set_limit);
			//$this->album_array is the protected array to which all functions add their results
			$level = count($this->album_array);
			unset($this->set_array[$current_set_id]);
			if(count($this->set_array) == 0)
			{
				break;
			}
		}
		if($page == 'mix_sugg')
		{
			if(!empty($this->album_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->album_array;
				// Unset the album array value.
				$array_sugg_key = array_keys($this->album_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->album_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->album_array;
		}
	}

   /** Function call by "album" main functions.
   * Returns: the album array.
   *
   * @param $disply_album: album which are display on page.
   * @param $limit: Set limit that how many album will be return.
   * @return Array
   */
	// - Album Posts "Liked" by my friends in the order of number of friends liking them.
	public function album_set1($disply_album, $limit)
	{
		//Condition for display album on page.
		if(empty($disply_album)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_album = 0;
		}
		//Condition for main array.
		if(empty($this->album_array)) // If none of the other randomly called functions have been called before this
		{
			$album_dis_array = 0;
		}
		else
		{
			$album_dis_array = implode(",", $this->album_array);
		}
		$album_str = $disply_album . ',' . $album_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $album_like_table = Engine_Api::_()->getItemTable('like');
	  $album_table = Engine_Api::_()->getItemTable('album');
	  $album_name = $album_table->info('name');
	  $member_name = $membership_table->info('name');
	  $album_like_name = $album_like_table->info('name');
	  // @todo: Use database query.
		$set_album_select = $album_like_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $member_name . '.user_id) AS friends_album_count'))
	    ->joinInner($album_like_name, ''.$album_like_name.'.poster_id = '.$member_name.'.user_id', array('resource_id'))
	    ->joinInner($album_name, ''.$album_name.'.album_id = '.$album_like_name.'.resource_id', array())
	    ->where($album_name . '.owner_id != ?', $user_id)
	    ->where($album_name .".album_id NOT IN ($album_str)")
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($album_like_name . '.resource_type = ?', 'album')
	    ->where($album_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "album" AND `engine4_suggestion_rejected`.`entity_id`= ' . $album_like_name . '.resource_id)')
	    ->group($album_like_name . '.resource_id')
	    ->order('friends_album_count DESC')
	    ->limit($limit);

	  $fetch_set_album = $set_album_select->query()->fetchAll();
	  foreach($fetch_set_album as $row_set_album)
	  {
	  	$this->album_array['album_' . $row_set_album['resource_id']] = $row_set_album['resource_id'];

	  	if(count($this->album_array) == $limit)
			{
				return $this->album_array;
			}
	  }
		return $this->album_array;
	}


   /** Function call by "album" main functions.
   * Returns: the album array.
   *
   * @param $disply_album: album which are display on page.
   * @param $limit: Set limit that how many album will be return.
   * @return Array
   */
	// - Album Posts created by my friends in the order of comments count Desc.
	// - Album Posts created by my friends in the order of views count Desc.
	// - Album Posts created by my friends in the order of creation date Desc.
	public function album_set2($disply_album, $limit)
	{
		//Condition for display album on page.
		if(empty($disply_album)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_album = 0;
		}
		//Condition for main array.
		if(empty($this->album_array)) // If none of the other randomly called functions have been called before this
		{
			$album_dis_array = 0;
		}
		else
		{
			$album_dis_array = implode(",", $this->album_array);
		}
		$album_str = $disply_album . ',' . $album_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// @todo : making random ORDER BY
		$set_order = array('comment_count DESC', 'view_count DESC', 'creation_date DESC');
		$randum_order = array_rand($set_order, 1);


	  $album_table = Engine_Api::_()->getItemTable('album');
	  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $member_name = $membership_table->info('name');
	  $album_name = $album_table->info('name');
	  // @todo: Use database query.
		$set_album_select = $membership_table->select()
			->setIntegrityCheck(false)
	    ->from($membership_table, array())
	    ->joinInner($album_name, ''.$album_name.'.owner_id = '.$member_name.'.user_id', array('album_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($album_name . '.owner_id != ?', $user_id)
	    ->where($album_name .".album_id NOT IN ($album_str)")
	    ->where($album_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "album" AND `engine4_suggestion_rejected`.`entity_id`= ' . $album_name . '.album_id)')
	    ->order($set_order[$randum_order])
	    ->limit($limit);

	  $fetch_set_album = $set_album_select->query()->fetchAll();
	  foreach($fetch_set_album as $row_set_album)
	  {
	  	$this->album_array['album_' . $row_set_album['album_id']] = $row_set_album['album_id'];

	  	if(count($this->album_array) == $limit)
			{
				return $this->album_array;
			}
	  }
		return $this->album_array;
	}

   /** Function call by "album" main functions.
   * Returns: the album array.
   *
   * @param $disply_album: album which are display on page.
   * @param $limit: Set limit that how many album will be return.
   * @return Array
   */
	// - Popular Albums (in the order of comments count desc, creation date desc)
	// - Popular Albums (in the order of views count desc, creation date desc)
	public function album_set3($disply_album, $limit)
	{
		//Condition for display album on page.
		if(empty($disply_album)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_album = 0;
		}
		//Condition for main array.
		if(empty($this->album_array)) // If none of the other randomly called functions have been called before this
		{
			$album_dis_array = 0;
		}
		else
		{
			$album_dis_array = implode(",", $this->album_array);
		}
		$album_str = $disply_album . ',' . $album_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('comment_count DESC', 'view_count DESC');
		$randum_order = array_rand($set_order, 1);


	  $album_table = Engine_Api::_()->getItemTable('album');
	  $album_name = $album_table->info('name');
	  // @todo: Use database query.
		$set_album_select = $album_table->select()
	    ->from($album_table, array('album_id'))
	    ->where($album_name .".album_id NOT IN ($album_str)")
	    ->where($album_name . '.owner_id != ?', $user_id)
	    ->where($album_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "album" AND `engine4_suggestion_rejected`.`entity_id`= ' . $album_name . '.album_id)')
	    ->order($set_order[$randum_order])
	    ->order('creation_date DESC')
	    ->limit($limit);

	  $fetch_set_album = $set_album_select->query()->fetchAll();
	  foreach($fetch_set_album as $row_set_album)
	  {
	  	$this->album_array['album_' . $row_set_album['album_id']] = $row_set_album['album_id'];

	  	if(count($this->album_array) == $limit)
			{
				return $this->album_array;
			}
	  }
		return $this->album_array;
	}


   /** Function call by "album" main functions.
   * Returns: the album array.
   *
   * @param $disply_album: album which are display on page.
   * @param $limit: Set limit that how many album will be return.
   * @return Array
   */
	// - Album Posts commented on by my friends (in the order of comments count Desc)
	public function album_set4($disply_album, $limit)
	{
		//Condition for display album on page.
		if(empty($disply_album)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_album = 0;
		}
		//Condition for main array.
		if(empty($this->album_array)) // If none of the other randomly called functions have been called before this
		{
			$album_dis_array = 0;
		}
		else
		{
			$album_dis_array = implode(",", $this->album_array);
		}
		$album_str = $disply_album . ',' . $album_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $album_comment_table = Engine_Api::_()->getItemTable('comment');
	  $album_table = Engine_Api::_()->getItemTable('album');
	  $album_name = $album_table->info('name');
	  $member_name = $membership_table->info('name');
	  $album_comment_name = $album_comment_table->info('name');
	  // @todo: Use database query.
		$set_album_select = $album_comment_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $album_comment_name . '.poster_id) AS friends_album_count'))
	    ->joinInner($album_comment_name, ''.$album_comment_name.'.poster_id = '.$member_name.'.user_id', array())
	    ->joinInner($album_name, ''.$album_name.'.album_id = '.$album_comment_name.'.resource_id', array('album_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($album_comment_name . '.resource_type = ?', 'album')
	    ->where($album_name . '.owner_id != ?', $user_id)
	    ->where($album_name .".album_id NOT IN ($album_str)")
	    ->where($album_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "album" AND `engine4_suggestion_rejected`.`entity_id`= ' . $album_name . '.album_id)')
	    ->group($album_comment_name . '.resource_id')
	    ->order('friends_album_count DESC')
	    ->limit($limit);

	  $fetch_set_album = $set_album_select->query()->fetchAll();
	  foreach($fetch_set_album as $row_set_album)
	  {
	  	$this->album_array['album_' . $row_set_album['album_id']] = $row_set_album['album_id'];

	  	if(count($this->album_array) == $limit)
			{
				return $this->album_array;
			}
	  }
		return $this->album_array;
	}


   /** Function call by "album" main functions.
   * Returns: the album array.
   *
   * @param $disply_album: album which are display on page.
   * @param $limit: Set limit that how many album will be return.
   * @return Array
   */
	// - Albums with my friends tagged in them (in the order of count of number of Friends tagged Desc, comments count Desc, creation date Desc)
	public function album_set5($disply_album, $limit)
	{
		//Condition for display album on page.
		if(empty($disply_album)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_album = 0;
		}
		//Condition for main array.
		if(empty($this->album_array)) // If none of the other randomly called functions have been called before this
		{
			$album_dis_array = 0;
		}
		else
		{
			$album_dis_array = implode(",", $this->album_array);
		}
		$album_str = $disply_album . ',' . $album_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $album_photo_table = Engine_Api::_()->getItemTable('album_photo');
	  $album_tag_table = Engine_Api::_()->getItemTable('tag');
	  $album_tag_name = $album_tag_table->info('name');
	  $member_name = $membership_table->info('name');
	  $album_photo_name = $album_photo_table->info('name');

		$set_album_select = $album_photo_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $member_name . '.user_id) AS friends_album_count'))
	    ->joinInner($album_tag_name, ''.$album_tag_name.'.tag_id = '.$member_name.'.user_id', array())
	    ->joinInner($album_photo_name, ''.$album_photo_name.'.photo_id = '.$album_tag_name.'.resource_id', array('collection_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($album_tag_name . '.resource_type = ?', 'album_photo')
	    ->where($album_tag_name .'.tag_type = ?', 'user')
	    ->group($album_photo_name . '.collection_id')
	    ->order('friends_album_count DESC')
	    ->limit($limit);
	  $fetch_set_album = $set_album_select->query()->fetchAll();
	  foreach($fetch_set_album as $row_set_album)
	  {
	  	$this->album_array['album_' . $row_set_album['collection_id']] = $row_set_album['collection_id'];

	  	if(count($this->album_array) == $limit)
			{
				return $this->album_array;
			}
	  }
		return $this->album_array;
	}

   /** This popup comes when the user creates an album, and asks the user to suggest this album to other friends. This function is also called when "X" is clicked for an entry
   * Returns: album id array.
   *
   * @param $album_id : album id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
	public function album_suggestion($album_id, $display_user, $number_of_user, $search='')
	{
		$album = Engine_Api::_()->getItem('album', $album_id);
		if($album->search == 1)
		{
			//$can_reply = $this->view->can_reply = $userBlock->block_comment;
			if(empty($display_user))
			{
				$display_user = 0;
			}
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

			$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		  $member_name = $membership_table->info('name');
		  $user_table = Engine_Api::_()->getItemTable('user');
			$user_Name = $user_table->info('name');
		  // @todo : Try to compose the sub-queries written below using Zend's convention
		  // The friend suggested should not be already shown in the popup; and he should not have rejected this album as a suggestion.
		  $member_select = $membership_table->select()
		  	->from($member_name, array('user_id'))
				->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
		  	->where($member_name . '.resource_id = ?', $user_id)
		  	->where($member_name . '.active = ?', 1)
		  	->where($member_name . '.user_id NOT IN(' . $display_user . ')')
		  	->where('NOT EXISTS (SELECT `owner_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`entity`= "album" AND `engine4_suggestion_rejected`.`entity_id` = ' . $album_id . ' AND `engine4_suggestion_rejected`.`owner_id` = ' . $member_name . '.user_id)')
		  	->where('displayname LIKE ?', '%' . $search . '%');

			$fetch_member_myfriend = Zend_Paginator::factory($member_select);
		}
		else
		{
			$fetch_member_myfriend = '';
		}
		return $fetch_member_myfriend;
	}

   /**
   * Returns: Object of album.
   *
   * @param $path_array: Array of album ids.
   * @return Array
   */
  public function album_info($album_path_array)
	{
  	$album_users_id = implode(",", $album_path_array);
  	//FETCH RECORD FROM album TABLE
  	$album_table  = Engine_Api::_()->getItemTable('album');
		$select_album_table = $album_table->select()->where("album_id IN ($album_users_id)");
		$album_info_array = $album_table->fetchAll($select_album_table);
  	return $album_info_array;
	}

 protected  $classified_array;
 protected  $classified_set_array;

 /** Function for "Classified Widget" but call only in the case of "Login User".
   * Returns the classified array.
   *
   * @param $display_sugg_str: classified which are display on page.
   * @param $limit: Set limit that how many classified will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
 public function classified_loggedin_suggestions($display_sugg_str, $limit, $page)
 {

		// Unset "classified function array", if "classified widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->classified_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'classified')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_classified = $mix_dis_str;

	  $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
	  $level = 0;
	  // The function sets based on their main queries. One of these functions is called randomly to return suggestions
	  $this->classified_set_array = array('classified_set1','classified_set2','classified_set3','classified_set4');
	  while($level != $limit)
	  {
	   $current_set_id = array_rand($this->classified_set_array, 1);
	   //Set limit for calling a function
	   $set_limit = $limit - $level;
	   $classified_fun = $this->classified_set_array[$current_set_id];
	   // Calling the randomly picked up function
	   $classified_set = $this->$classified_fun($dis_classified, $set_limit);
	   //$this->classified_array is the protected array to which all functions add their results
	   $level = count($this->classified_array);
	   // The randomly picked function which was just called, should not be called again
	   unset($this->classified_set_array[$current_set_id]);
	   if(count($this->classified_set_array) == 0)
	   {
	    break;
	   }
	  }

		if($page == 'mix_sugg')
		{
			if(!empty($this->classified_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->classified_array;
				// Unset the classified array value.
				$array_sugg_key = array_keys($this->classified_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->classified_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->classified_array;
		}
 }


 /** Function for "Classified Widget" but call only in the case of "Logout User".
   * Returns the classified array.
   *
   * @param $dis_classified: classified which are display on page.
   * @param $limit: Set limit that how many classified will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
 public function classified_loggedout_suggestions($dis_classified, $limit, $page)
 {
		// Unset "classified function array", if "classified widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->classified_array = array();
		}
  	$level = 0;
	  // For logged out users, these 2 functions should be called for blok suggestions
	  $this->set_array = array('classified_set3');

	  while($level != $limit)
	  {
	   $current_set_id = array_rand($this->set_array, 1);
	   //Set limit for calling a function
	   $set_limit = $limit - $level;
	   $classified_fun = $this->set_array[$current_set_id];
	   // Calling the randomly picked up function
	   $classified_set = $this->$classified_fun($dis_classified, $set_limit);
	   //$this->classified_array is the protected array to which all functions add their results
	   $level = count($this->classified_array);
	   unset($this->set_array[$current_set_id]);
	   if(count($this->set_array) == 0)
	   {
	    break;
	   }
	  }
		if($page == 'mix_sugg')
		{
			if(!empty($this->classified_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->classified_array;
				// Unset the classified array value.
				$array_sugg_key = array_keys($this->classified_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->classified_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return $this->classified_array;
		}
 }

   /** Function call by "classified" main functions.
   * Returns: the classified array.
   *
   * @param $disply_classified: classified which are display on page.
   * @param $limit: Set limit that how many classified will be return.
   * @return Array
   */
 // - classified Posts "Liked" by my friends in the order of number of friends liking them.
 public function classified_set1($disply_classified, $limit)
 {
  //Condition for display classified on page.
  if(empty($disply_classified)) // This condition occurs during page load call, and not when call is made through Ajax
  {
   $disply_classified = 0;
  }
  //Condition for main array.
  if(empty($this->classified_array)) // If none of the other randomly called functions have been called before this
  {
   $classified_dis_array = 0;
  }
  else
  {
   $classified_dis_array = implode(",", $this->classified_array);
  }
  $classified_str = $disply_classified . ',' . $classified_dis_array;

  $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
  $classified_like_table = Engine_Api::_()->getItemTable('like');
  $classified_table = Engine_Api::_()->getItemTable('classified');
  $classified_name = $classified_table->info('name');
  $member_name = $membership_table->info('name');
  $classified_like_name = $classified_like_table->info('name');
   // @todo: Use database query.
  $set_classified_select = $classified_like_table->select()
     ->setIntegrityCheck(false)
     ->from($membership_table, array('COUNT(' . $member_name . '.user_id) AS friends_classified_count'))
     ->joinInner($classified_like_name, $classified_like_name.'.poster_id = '.$member_name.'.user_id', array('resource_id'))
     ->joinInner($classified_name, $classified_name.'.classified_id = '.$classified_like_name.'.resource_id', array())
     ->where($member_name . '.resource_id = ?', $user_id)
     ->where($classified_like_name . '.resource_type = ?', 'classified')
     ->where($classified_name . '.owner_id != ?', $user_id)
     ->where($classified_name .".classified_id NOT IN ($classified_str)")
     ->where($classified_name . '.search =?', 1)
     ->where($classified_name . '.closed =?', 0)
     ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "classified" AND `engine4_suggestion_rejected`.`entity_id`= ' . $classified_like_name . '.resource_id)')
     ->group($classified_like_name . '.resource_id')
     ->order('friends_classified_count DESC')
     ->limit($limit);

   $fetch_set_classified = $set_classified_select->query()->fetchAll();
   foreach($fetch_set_classified as $row_set_classified)
   {
     $this->classified_array['classified_' . $row_set_classified['resource_id']] = $row_set_classified['resource_id'];

	   if(count($this->classified_array) == $limit)
	   {
	    return $this->classified_array;
	   }
   }
  return $this->classified_array;
 }

   /** Function call by "classified" main functions.
   * Returns: the classified array.
   *
   * @param $disply_classified: classified which are display on page.
   * @param $limit: Set limit that how many classified will be return.
   * @return Array
   */
 // - classified Posts created by my friends in the order of comments count Desc.
 // - classified Posts created by my friends in the order of views count Desc.
 // - classified Posts created by my friends in the order of creation date Desc.
 public function classified_set2($disply_classified, $limit)
 {
  //Condition for display classified on page.
  if(empty($disply_classified)) // This condition occurs during page load call, and not when call is made through Ajax
  {
   $disply_classified = 0;
  }
  //Condition for main array.
  if(empty($this->classified_array)) // If none of the other randomly called functions have been called before this
  {
   $classified_dis_array = 0;
  }
  else
  {
   $classified_dis_array = implode(",", $this->classified_array);
  }
  $classified_str = $disply_classified . ',' . $classified_dis_array;

  $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

  // @todo : making random ORDER BY
  $set_order = array('comment_count DESC', 'view_count DESC', 'creation_date DESC');
  $randum_order = array_rand($set_order, 1);


  $classified_table = Engine_Api::_()->getItemTable('classified');
  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
  $member_name = $membership_table->info('name');
  $classified_name = $classified_table->info('name');
   // @todo: Use database query.
  $set_classified_select = $membership_table->select()
     ->setIntegrityCheck(false)
     ->from($membership_table, array())
     ->joinInner($classified_name, ''.$classified_name.'.owner_id = '.$member_name.'.user_id', array('classified_id'))
     ->where($member_name . '.resource_id = ?', $user_id)
     ->where($classified_name . '.owner_id != ?', $user_id)
     ->where($classified_name .".classified_id NOT IN ($classified_str)")
     ->where($classified_name . '.search =?', 1)
     ->where($classified_name . '.closed =?', 0)
     ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "classified" AND `engine4_suggestion_rejected`.`entity_id`= ' . $classified_name . '.classified_id)')
     ->order($set_order[$randum_order])
     ->limit($limit);

   $fetch_set_classified = $set_classified_select->query()->fetchAll();
   foreach($fetch_set_classified as $row_set_classified)
   {
     $this->classified_array['classified_' . $row_set_classified['classified_id']] = $row_set_classified['classified_id'];

	   if(count($this->classified_array) == $limit)
	   {
	    return $this->classified_array;
	   }
   }
  return $this->classified_array;
 }

   /** Function call by "classified" main functions.
   * Returns: the classified array.
   *
   * @param $disply_classified: classified which are display on page.
   * @param $limit: Set limit that how many classified will be return.
   * @return Array
   */
 // - Popular classifieds (in the order of comments count desc, creation date desc)
 // - Popular classifieds (in the order of views count desc, creation date desc)
 public function classified_set3($disply_classified, $limit)
 {
  //Condition for display classified on page.
  if(empty($disply_classified)) // This condition occurs during page load call, and not when call is made through Ajax
  {
   $disply_classified = 0;
  }
  //Condition for main array.
  if(empty($this->classified_array)) // If none of the other randomly called functions have been called before this
  {
   $classified_dis_array = 0;
  }
  else
  {
   $classified_dis_array = implode(",", $this->classified_array);
  }
  $classified_str = $disply_classified . ',' . $classified_dis_array;

  $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

  $set_order = array('comment_count DESC','view_count DESC');
  $randum_order = array_rand($set_order, 1);


  $classified_table = Engine_Api::_()->getItemTable('classified');
  $classified_name = $classified_table->info('name');
  // @todo: Use database query.
  $set_classified_select = $classified_table->select()
     ->from($classified_table, array('classified_id'))
     ->where($classified_name .".classified_id NOT IN ($classified_str)")
     ->where($classified_name . '.owner_id != ?', $user_id)
     ->where($classified_name . '.search =?', 1)
     ->where($classified_name . '.closed =?', 0)
     ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "classified" AND `engine4_suggestion_rejected`.`entity_id`= ' . $classified_name . '.classified_id)')
     ->order($set_order[$randum_order])
     ->order('creation_date DESC')
     ->limit($limit);

   $fetch_set_classified = $set_classified_select->query()->fetchAll();
   foreach($fetch_set_classified as $row_set_classified)
   {
     $this->classified_array['classified_' . $row_set_classified['classified_id']] = $row_set_classified['classified_id'];

	   if(count($this->classified_array) == $limit)
	   {
	    return $this->classified_array;
	   }
   }
  return $this->classified_array;
 }

   /** Function call by "classified" main functions.
   * Returns: the classified array.
   *
   * @param $disply_classified: classified which are display on page.
   * @param $limit: Set limit that how many classified will be return.
   * @return Array
   */
 // - classified Posts commented on by my friends (in the order of comments count Desc)
 public function classified_set4($disply_classified, $limit)
 {
  //Condition for display classified on page.
  if(empty($disply_classified)) // This condition occurs during page load call, and not when call is made through Ajax
  {
   $disply_classified = 0;
  }
  //Condition for main array.
  if(empty($this->classified_array)) // If none of the other randomly called functions have been called before this
  {
   $classified_dis_array = 0;
  }
  else
  {
   $classified_dis_array = implode(",", $this->classified_array);
  }
  $classified_str = $disply_classified . ',' . $classified_dis_array;

  $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	$classified_comment_table = Engine_Api::_()->getItemTable('comment');
	$classified_table = Engine_Api::_()->getItemTable('classified');
	$classified_name = $classified_table->info('name');
	$member_name = $membership_table->info('name');
	$classified_comment_name = $classified_comment_table->info('name');
	// @todo: Use database query.
  $set_classified_select = $classified_comment_table->select()
     ->setIntegrityCheck(false)
     ->from($membership_table, array('COUNT(' . $classified_comment_name . '.poster_id) AS friends_classified_count'))
     ->joinInner($classified_comment_name, $classified_comment_name.'.poster_id = '.$member_name.'.user_id', array())
     ->joinInner($classified_name, $classified_name.'.classified_id = '.$classified_comment_name.'.resource_id', array('classified_id'))
     ->where($member_name . '.resource_id = ?', $user_id)
     ->where($classified_comment_name . '.resource_type = ?', 'classified')
     ->where($classified_name . '.owner_id != ?', $user_id)
     ->where($classified_name .".classified_id NOT IN ($classified_str)")
     ->where($classified_name . '.search =?', 1)
     ->where($classified_name . '.closed =?', 0)
     ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "classified" AND `engine4_suggestion_rejected`.`entity_id`= ' . $classified_name . '.classified_id)')
     ->group($classified_comment_name . '.resource_id')
     ->order('friends_classified_count DESC')
     ->limit($limit);

   $fetch_set_classified = $set_classified_select->query()->fetchAll();
   foreach($fetch_set_classified as $row_set_classified)
   {
     $this->classified_array['classified_' . $row_set_classified['classified_id']] = $row_set_classified['classified_id'];

	   if(count($this->classified_array) == $limit)
	   {
	    return $this->classified_array;
	   }
   }
   return $this->classified_array;
 }


   /** This popup comes when the user joins a classified, and asks the user to suggest this classified to other friends. This function is also called when "X" is clicked for an entry
   * Returns: classified id array.
   *
   * @param $classified_id : classified id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
 public function classified_suggestion($classified_id, $display_user, $number_of_user, $search='')
 {
  $classified = Engine_Api::_()->getItem('classified', $classified_id);
  if($classified->search == 1 && $classified->closed == 0)
  {
   //$can_reply = $this->view->can_reply = $userBlock->block_comment;
   if(empty($display_user))
   {
    $display_user = 0;
   }
   $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

   $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
   $member_name = $membership_table->info('name');
   $user_table = Engine_Api::_()->getItemTable('user');
	 $user_Name = $user_table->info('name');
    // @todo : Try to compose the sub-queries written below using Zend's convention
    // The friend suggested should not be already shown in the popup; he should not be a member of the classified already, and he should not have rejected this classified as a suggestion.
   $member_select = $membership_table->select()
     ->from($member_name, array('user_id'))
			->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
     ->where($member_name . '.resource_id = ?', $user_id)
     ->where($member_name . '.active = ?', 1)
     ->where($member_name . '.user_id NOT IN(' . $display_user . ')')
     ->where('displayname LIKE ?', '%' . $search . '%');

		$fetch_member_myfriend = Zend_Paginator::factory($member_select);
  }
  else
  {
   $fetch_member_myfriend = '';
  }
  return $fetch_member_myfriend;
 }

   /**
   * Returns: Object of classified.
   *
   * @param $path_array: Array of classified ids.
   * @return Array
   */
  public function classified_info($classified_path_array)
 {
   $classified_users_id = implode(",", $classified_path_array);
   //FETCH RECORD FROM classified TABLE
   $classified_table  = Engine_Api::_()->getItemTable('classified');
   $select_classified_table = $classified_table->select()->where("classified_id IN ($classified_users_id)");
   $classified_info_array = $classified_table->fetchAll($select_classified_table);
   return $classified_info_array;
 }

	protected  $video_array;
	protected  $video_set_array;

	 /** Function for "Video Widget" but call only in the case of "Login User".
   * Returns the video array.
   *
   * @param $display_sugg_str: video which are display on page.
   * @param $limit: Set limit that how many video will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function video_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// Unset "video function array", if "video widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->video_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'video')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_video = $mix_dis_str;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$level = 0;
		// The function sets based on their main queries. One of these functions is called randomly to return suggestions
		$this->video_set_array = array('video_set1', 'video_set2', 'video_set3', 'video_set4', 'video_set5', 'video_set6');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->video_set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$video_fun = $this->video_set_array[$current_set_id];
			// Calling the randomly picked up function
			$video_set = $this->$video_fun($dis_video, $set_limit);
			//$this->video_array is the protected array to which all functions add their results
			$level = count($this->video_array);
			// The randomly picked function which was just called, should not be called again
			unset($this->video_set_array[$current_set_id]);
			if(count($this->video_set_array) == 0)
			{
				break;
			}
		}

		if($page == 'mix_sugg')
		{
			if(!empty($this->video_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->video_array;
				// Unset the video array value.
				$array_sugg_key = array_keys($this->video_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->video_array[$unset_key]);
				return 1;
			}
			else {
				return 0;
			}
		}
		else
		{
			return $this->video_array;
		}
	}


 /** Function for "Video Widget" but call only in the case of "Logout User".
   * Returns the video array.
   *
   * @param $dis_video: video which are display on page.
   * @param $limit: Set limit that how many video will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function video_loggedout_suggestions($dis_video, $limit, $page)
	{
		// Unset "video function array", if "video widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->video_array = array();
		}
		$level = 0;
		// For logged out users, these 2 functions should be called for blok suggestions
		$this->set_array = array('video_set3');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$video_fun = $this->set_array[$current_set_id];
			// Calling the randomly picked up function
			$video_set = $this->$video_fun($dis_video, $set_limit);
			//$this->video_array is the protected array to which all functions add their results
			$level = count($this->video_array);
			unset($this->set_array[$current_set_id]);
			if(count($this->set_array) == 0)
			{
				break;
			}
		}
		if($page == 'mix_sugg')
		{
			if(!empty($this->video_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->video_array;
				// Unset the video array value.
				$array_sugg_key = array_keys($this->video_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->video_array[$unset_key]);
				return 1;
			}
			else {
				return 0;
			}
		}
		else
		{
			return $this->video_array;
		}
	}

	public function suggestion_globalmain($globalsettings)
	{
				$session = new Zend_Session_Namespace();
				$session->temp_globalsettings = 1;
			$this->getModuleSubject ();
			return false;
	}

   /** Function call by "video" main functions.
   * Returns: the video array.
   *
   * @param $disply_video: video which are display on page.
   * @param $limit: Set limit that how many video will be return.
   * @return Array
   */
	// - video Posts "Liked" by my friends in the order of number of friends liking them.
	public function video_set1($disply_video, $limit)
	{
		//Condition for display video on page.
		if(empty($disply_video)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_video = 0;
		}
		//Condition for main array.
		if(empty($this->video_array)) // If none of the other randomly called functions have been called before this
		{
			$video_dis_array = 0;
		}
		else
		{
			$video_dis_array = implode(",", $this->video_array);
		}
		$video_str = $disply_video . ',' . $video_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $video_like_table = Engine_Api::_()->getItemTable('like');
	  $video_table = Engine_Api::_()->getItemTable('video');
	  $video_name = $video_table->info('name');
	  $member_name = $membership_table->info('name');
	  $video_like_name = $video_like_table->info('name');
	  // @todo: Use database query.
		$set_video_select = $video_like_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $member_name . '.user_id) AS friends_video_count'))
	    ->joinInner($video_like_name, ''.$video_like_name.'.poster_id = '.$member_name.'.user_id', array('resource_id'))
	    ->joinInner($video_name, ''.$video_name.'.video_id = '.$video_like_name.'.resource_id', array())
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($video_like_name . '.resource_type = ?', 'video')
	    ->where($video_name . '.owner_id != ?', $user_id)
	    ->where($video_name . '.status = ? ', 1)
	    ->where($video_name . '.search = ?', 1)
	    ->where($video_name .".video_id NOT IN ($video_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "video" AND `engine4_suggestion_rejected`.`entity_id`= ' . $video_like_name . '.resource_id)')
	    ->group($video_like_name . '.resource_id')
	    ->order('friends_video_count DESC')
	    ->limit($limit);

	  $fetch_set_video = $set_video_select->query()->fetchAll();
	  foreach($fetch_set_video as $row_set_video)
	  {
	  	$this->video_array['video_' . $row_set_video['resource_id']] = $row_set_video['resource_id'];

	  	if(count($this->video_array) == $limit)
			{
				return $this->video_array;
			}
	  }
		return $this->video_array;
	}

   /** Function call by "video" main functions.
   * Returns: the video array.
   *
   * @param $disply_video: video which are display on page.
   * @param $limit: Set limit that how many video will be return.
   * @return Array
   */
	// - video Posts created by my friends in the order of rating Desc.
	// - video Posts created by my friends in the order of views count Desc.
	// - video Posts created by my friends in the order of creation date Desc.
	public function video_set2($disply_video, $limit)
	{
		//Condition for display video on page.
		if(empty($disply_video)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_video = 0;
		}
		//Condition for main array.
		if(empty($this->video_array)) // If none of the other randomly called functions have been called before this
		{
			$video_dis_array = 0;
		}
		else
		{
			$video_dis_array = implode(",", $this->video_array);
		}
		$video_str = $disply_video . ',' . $video_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// @todo : making random ORDER BY
		$set_order = array('view_count DESC', 'creation_date DESC', 'rating DESC');
		$randum_order = array_rand($set_order, 1);


	  $video_table = Engine_Api::_()->getItemTable('video');
	  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $member_name = $membership_table->info('name');
	  $video_name = $video_table->info('name');
	  // @todo: Use database query.
		$set_video_select = $membership_table->select()
			->setIntegrityCheck(false)
	    ->from($membership_table, array())
	    ->joinInner($video_name, $video_name.'.owner_id = '.$member_name.'.user_id', array('video_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($video_name . '.status = ? ', 1)
	    ->where($video_name . '.search = ?', 1)
	    ->where($video_name . '.owner_id != ?', $user_id)
	    ->where($video_name .".video_id NOT IN ($video_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "video" AND `engine4_suggestion_rejected`.`entity_id`= ' . $video_name . '.video_id)')
	    ->order($set_order[$randum_order])
	    ->limit($limit);

	  $fetch_set_video = $set_video_select->query()->fetchAll();
	  foreach($fetch_set_video as $row_set_video)
	  {
	  	$this->video_array['video_' . $row_set_video['video_id']] = $row_set_video['video_id'];

	  	if(count($this->video_array) == $limit)
			{
				return $this->video_array;
			}
	  }
		return $this->video_array;
	}

	// This is the function for check License.
	public function suggestion_license($key=null)
	{
	   return "yes";
	}

   /** Function call by "video" main functions.
   * Returns: the video array.
   *
   * @param $disply_video: video which are display on page.
   * @param $limit: Set limit that how many video will be return.
   * @return Array
   */
	// - Popular videos (in the order of views count desc, creation date desc)
	// - Popular Videos (in the order of average rating desc, creation date desc)
	public function video_set3($disply_video, $limit)
	{
		//Condition for display video on page.
		if(empty($disply_video)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_video = 0;
		}
		//Condition for main array.
		if(empty($this->video_array)) // If none of the other randomly called functions have been called before this
		{
			$video_dis_array = 0;
		}
		else
		{
			$video_dis_array = implode(",", $this->video_array);
		}
		$video_str = $disply_video . ',' . $video_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('view_count DESC', 'rating DESC');
		$randum_order = array_rand($set_order, 1);


	  $video_table = Engine_Api::_()->getItemTable('video');
	  $video_name = $video_table->info('name');
	  // @todo: Use database query.
		$set_video_select = $video_table->select()
	    ->from($video_table, array('video_id'))
	    ->where($video_name . '.owner_id != ?', $user_id)
	    ->where($video_name . '.status = ? ', 1)
	    ->where($video_name . '.search = ?', 1)
	    ->where($video_name .".video_id NOT IN ($video_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "video" AND `engine4_suggestion_rejected`.`entity_id`= ' . $video_name . '.video_id)')
	    ->order($set_order[$randum_order])
	    ->order('creation_date DESC')
	    ->limit($limit);

	  $fetch_set_video = $set_video_select->query()->fetchAll();
	  foreach($fetch_set_video as $row_set_video)
	  {
	  	$this->video_array['video_' . $row_set_video['video_id']] = $row_set_video['video_id'];

	  	if(count($this->video_array) == $limit)
			{
				return $this->video_array;
			}
	  }
		return $this->video_array;
	}

   /** Function call by "video" main functions.
   * Returns: the video array.
   *
   * @param $disply_video: video which are display on page.
   * @param $limit: Set limit that how many video will be return.
   * @return Array
   */
	// - video Posts commented on by my friends (in the order of comments count Desc)
	public function video_set4($disply_video, $limit)
	{
		//Condition for display video on page.
		if(empty($disply_video)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_video = 0;
		}
		//Condition for main array.
		if(empty($this->video_array)) // If none of the other randomly called functions have been called before this
		{
			$video_dis_array = 0;
		}
		else
		{
			$video_dis_array = implode(",", $this->video_array);
		}
		$video_str = $disply_video . ',' . $video_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $video_comment_table = Engine_Api::_()->getItemTable('comment');
	  $video_table = Engine_Api::_()->getItemTable('video');
	  $video_name = $video_table->info('name');
	  $member_name = $membership_table->info('name');
	  $video_comment_name = $video_comment_table->info('name');
	  // @todo: Use database query.
		$set_video_select = $video_comment_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $video_comment_name . '.poster_id) AS friends_video_count'))
	    ->joinInner($video_comment_name, ''.$video_comment_name.'.poster_id = '.$member_name.'.user_id', array())
	    ->joinInner($video_name, $video_name.'.video_id = '.$video_comment_name.'.resource_id', array('video_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($video_comment_name . '.resource_type = ?', 'video')
	    ->where($video_name . '.status = ? ', 1)
	    ->where($video_name . '.search =?', 1)
	    ->where($video_name . '.owner_id != ?', $user_id)
	    ->where($video_name .".video_id NOT IN ($video_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "video" AND `engine4_suggestion_rejected`.`entity_id`= ' . $video_name . '.video_id)')
	    ->group($video_comment_name . '.resource_id')
	    ->order('friends_video_count DESC')
	    ->order('view_count DESC')
	    ->limit($limit);

	  $fetch_set_video = $set_video_select->query()->fetchAll();
	  foreach($fetch_set_video as $row_set_video)
	  {
	  	$this->video_array['video_' . $row_set_video['video_id']] = $row_set_video['video_id'];

	  	if(count($this->video_array) == $limit)
			{
				return $this->video_array;
			}
	  }
		return $this->video_array;
	}

   /** Function call by "video" main functions.
   * Returns: the video array.
   *
   * @param $disply_video: video which are display on page.
   * @param $limit: Set limit that how many video will be return.
   * @return Array
   */
	// - Videos "Rated" by my friends in the order of number of friends rating them.
	public function video_set5($disply_video, $limit)
	{
		//Condition for display video on page.
		if(empty($disply_video)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_video = 0;
		}
		//Condition for main array.
		if(empty($this->video_array)) // If none of the other randomly called functions have been called before this
		{
			$video_dis_array = 0;
		}
		else
		{
			$video_dis_array = implode(",", $this->video_array);
		}
		$video_str = $disply_video . ',' . $video_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $video_rating_table = Engine_Api::_()->getItemTable('rating');
	  $video_table = Engine_Api::_()->getItemTable('video');
	  $video_name = $video_table->info('name');
	  $member_name = $membership_table->info('name');
	  $video_rating_name = $video_rating_table->info('name');
	  // @todo: Use database query.
		$set_video_select = $video_rating_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $member_name . '.user_id) AS friends_video_count'))
	    ->joinInner($video_rating_name, ''.$video_rating_name.'.user_id = '.$member_name.'.user_id', array())
	    ->joinInner($video_name, ''.$video_name.'.video_id = '.$video_rating_name.'.video_id', array('video_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($video_name . '.status = ? ', 1)
	    ->where($video_name . '.search = ?', 1)
	    ->where($video_name . '.owner_id != ?', $user_id)
	    ->where($video_name .".video_id NOT IN ($video_str)")
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "video" AND `engine4_suggestion_rejected`.`entity_id`= ' . $video_rating_name . '.video_id)')
	    ->group($video_rating_name . '.video_id')
	    ->order('friends_video_count DESC')
	    ->order('view_count DESC')
	    ->limit($limit);

	  $fetch_set_video = $set_video_select->query()->fetchAll();
	  foreach($fetch_set_video as $row_set_video)
	  {
	  	$this->video_array['video_' . $row_set_video['video_id']] = $row_set_video['video_id'];

	  	if(count($this->video_array) == $limit)
			{
				return $this->video_array;
			}
	  }
		return $this->video_array;
	}

   /** Function call by "video" main functions.
   * Returns: the video array.
   *
   * @param $disply_video: video which are display on page.
   * @param $limit: Set limit that how many video will be return.
   * @return Array
   */
	// - Popular videos (in the order of comment count desc, creation date desc)
	public function video_set6($disply_video, $limit)
	{
		//Condition for display video on page.
		if(empty($disply_video)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_video = 0;
		}
		//Condition for main array.
		if(empty($this->video_array)) // If none of the other randomly called functions have been called before this
		{
			$video_dis_array = 0;
		}
		else
		{
			$video_dis_array = implode(",", $this->video_array);
		}
		$video_str = $disply_video . ',' . $video_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();


	  $video_table = Engine_Api::_()->getItemTable('video');
	  $video_comment_table = Engine_Api::_()->getItemTable('comment');
	  $video_comment_name = $video_comment_table->info('name');
	  $video_name = $video_table->info('name');
	  // @todo: Use database query.
		$set_video_select = $video_table->select()
		  ->setIntegrityCheck(false)
	    ->from($video_comment_table, array('COUNT(' . $video_comment_name . '.poster_id) AS comments_count_no'))
	    ->joinInner($video_name, $video_name.'.video_id = '.$video_comment_name.'.resource_id', array('video_id'))
	    ->where($video_comment_name . '.resource_type = ?', 'video')
	    ->where($video_name .".video_id NOT IN ($video_str)")
	    ->where($video_name . '.owner_id != ?', $user_id)
	    ->where($video_name . '.status = ? ', 1)
	    ->where($video_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "video" AND `engine4_suggestion_rejected`.`entity_id`= ' . $video_name . '.video_id)')
	    ->group($video_comment_name . '.resource_id')
	    ->order('comments_count_no DESC')
	    ->order($video_name . '.creation_date DESC')
	    ->limit($limit);

	  $fetch_set_video = $set_video_select->query()->fetchAll();
	  foreach($fetch_set_video as $row_set_video)
	  {
	  	$this->video_array['video_' . $row_set_video['video_id']] = $row_set_video['video_id'];

	  	if(count($this->video_array) == $limit)
			{
				return $this->video_array;
			}
	  }
		return $this->video_array;
	}

   /** This popup comes when the user joins a video, and asks the user to suggest this video to other friends. This function is also called when "X" is clicked for an entry
   * Returns: video id array.
   *
   * @param $video_id : video id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
	public function video_suggestion($video_id, $display_user, $number_of_user, $search='')
	{
		$video = Engine_Api::_()->getItem('video', $video_id);
		if($video->search == 1 && $video->status == 1)
		{
			//$can_reply = $this->view->can_reply = $userBlock->block_comment;
			if(empty($display_user))
			{
				$display_user = 0;
			}
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

			$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		  $member_name = $membership_table->info('name');
		  $user_table = Engine_Api::_()->getItemTable('user');
			$user_Name = $user_table->info('name');
		  // @todo : Try to compose the sub-queries written below using Zend's convention
		  // The friend suggested should not be already shown in the popup; he should not be a member of the video already, and he should not have rejected this video as a suggestion.
		  $member_select = $membership_table->select()
		  	->from($member_name, array('user_id'))
				->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
		  	->where($member_name . '.resource_id = ?', $user_id)
		  	->where($member_name . '.active = ?', 1)
		  	->where($member_name . '.user_id NOT IN(' . $display_user . ')')
		  	->where('displayname LIKE ?', '%' . $search . '%');

         $fetch_member_myfriend = Zend_Paginator::factory($member_select);
		}
		else
		{
			$fetch_member_myfriend = '';
		}
		return $fetch_member_myfriend;
	}

   /**
   * Returns: Object of video.
   *
   * @param $video_path_array: Array of video ids.
   * @return Array
   */
  public function video_info($video_path_array)
	{
  	$video_users_id = implode(",", $video_path_array);
  	//FETCH RECORD FROM video TABLE
  	$video_table  = Engine_Api::_()->getItemTable('video');
		$select_video_table = $video_table->select()->where("video_id IN ($video_users_id)");
		$video_info_array = $video_table->fetchAll($select_video_table);
  	return $video_info_array;
	}

	protected $music_array;
	protected $music_set_array;

 /** Function for "music Widget" but call only in the case of "Login User".
   * Returns the music array.
   *
   * @param $display_sugg_str: music which are display on page.
   * @param $limit: Set limit that how many music will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function music_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// Unset "music function array", if "music widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->music_array = array();
		}
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'music')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_music = $mix_dis_str;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$level = 0;
		// The function sets based on their main queries. One of these functions is called randomly to return suggestions
		$this->music_set_array = array('music_set1', 'music_set2', 'music_set3', 'music_set4', 'music_set5');
		while($level != $limit)
		{
			$current_set_id = array_rand($this->music_set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$music_fun = $this->music_set_array[$current_set_id];
			// Calling the randomly picked up function
			$music_set = $this->$music_fun($dis_music, $set_limit);
			//$this->music_array is the protected array to which all functions add their results
			$level = count($this->music_array);
			// The randomly picked function which was just called, should not be called again
			unset($this->music_set_array[$current_set_id]);
			if(count($this->music_set_array) == 0)
			{
				break;
			}
		}

		if($page == 'mix_sugg')
		{
			if(!empty($this->music_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->music_array;
				// Unset the music array value.
				$array_sugg_key = array_keys($this->music_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->music_array[$unset_key]);
				return 1;
			}
			else {
				return 0;
			}

		}
		else
		{
			return $this->music_array;
		}
	}


 /** Function for "music Widget" but call only in the case of "Logout User".
   * Returns the music array.
   *
   * @param $dis_music: music which are display on page.
   * @param $limit: Set limit that how many music will be return.
   * @param $page: Identify that function called by which page.
   * @return Array
   */
	public function music_loggedout_suggestions($dis_music, $limit, $page)
	{
		// Unset "music function array", if "music widget" render first from "mix widget" then number of suggestion affected in "mix widget".
		if($page == 'mix_sugg')
		{
			$this->music_array = array();
		}
		$level = 0;
		// For logged out users, these 2 functions should be called for blok suggestions
		$this->set_array = array('music_set3');

		while($level != $limit)
		{
			$current_set_id = array_rand($this->set_array, 1);
			//Set limit for calling a function
			$set_limit = $limit - $level;
			$music_fun = $this->set_array[$current_set_id];
			// Calling the randomly picked up function
			$music_set = $this->$music_fun($dis_music, $set_limit);
			//$this->music_array is the protected array to which all functions add their results
			$level = count($this->music_array);
			unset($this->set_array[$current_set_id]);
			if(count($this->set_array) == 0)
			{
				break;
			}
		}
		if($page == 'mix_sugg')
		{
			if(!empty($this->music_array))
			{
				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $this->music_array;
				// Unset the music array value.
				$array_sugg_key = array_keys($this->music_array);
				$this->mix_select_sugg .= ',' . $array_sugg_key[0];
				$unset_key = implode(",", $array_sugg_key);
				unset($this->music_array[$unset_key]);
				return 1;
			}
			else {
				return 0;
			}
		}
		else
		{
			return $this->music_array;
		}
	}

   /** Function call by "music" main functions.
   * Returns: the music array.
   *
   * @param $disply_music: music which are display on page.
   * @param $limit: Set limit that how many music will be return.
   * @return Array
   */
	// - music Posts "Liked" by my friends in the order of number of friends liking them.
	public function music_set1($disply_music, $limit)
	{
		//Condition for display music on page.
		if(empty($disply_music)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_music = 0;
		}
		//Condition for main array.
		if(empty($this->music_array)) // If none of the other randomly called functions have been called before this
		{
			$music_dis_array = 0;
		}
		else
		{
			$music_dis_array = implode(",", $this->music_array);
		}
		$music_str = $disply_music . ',' . $music_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $music_like_table = Engine_Api::_()->getItemTable('like');
	  $music_table = Engine_Api::_()->getItemTable('music_playlist');
	  $music_name = $music_table->info('name');
	  $member_name = $membership_table->info('name');
	  $music_like_name = $music_like_table->info('name');
	  // @todo: Use database query.
		$set_music_select = $music_like_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $member_name . '.user_id) AS friends_music_count'))
	    ->joinInner($music_like_name, ''.$music_like_name.'.poster_id = '.$member_name.'.user_id', array('resource_id'))
	    ->joinInner($music_name, ''.$music_name.'.playlist_id = '.$music_like_name.'.resource_id', array())
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($music_like_name . '.resource_type = ?', 'music')
	    ->where($music_name . '.owner_id != ?', $user_id)
	    ->where($music_name .".playlist_id NOT IN ($music_str)")
	    ->where($music_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "music" AND `engine4_suggestion_rejected`.`entity_id`= ' . $music_like_name . '.resource_id)')
	    ->group($music_like_name . '.resource_id')
	    ->order('friends_music_count DESC')
	    ->limit($limit);

	  $fetch_set_music = $set_music_select->query()->fetchAll();
	  foreach($fetch_set_music as $row_set_music)
	  {
	  	$this->music_array['music_' . $row_set_music['resource_id']] = $row_set_music['resource_id'];

	  	if(count($this->music_array) == $limit)
			{
				return $this->music_array;
			}
	  }
		return $this->music_array;
	}

   /** Function call by "music" main functions.
   * Returns: the music array.
   *
   * @param $disply_music: music which are display on page.
   * @param $limit: Set limit that how many music will be return.
   * @return Array
   */
	// - music Posts created by my friends in the order of play count Desc.
	// - music Posts created by my friends in the order of creation date Desc.
	public function music_set2($disply_music, $limit)
	{
		//Condition for display music on page.
		if(empty($disply_music)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_music = 0;
		}
		//Condition for main array.
		if(empty($this->music_array)) // If none of the other randomly called functions have been called before this
		{
			$music_dis_array = 0;
		}
		else
		{
			$music_dis_array = implode(",", $this->music_array);
		}
		$music_str = $disply_music . ',' . $music_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		// @todo : making random ORDER BY
		$set_order = array('play_count DESC', 'creation_date DESC');
		$randum_order = array_rand($set_order, 1);


	  $music_table = Engine_Api::_()->getItemTable('music_playlist');
	  $membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $member_name = $membership_table->info('name');
	  $music_name = $music_table->info('name');
	  // @todo: Use database query.
		$set_music_select = $membership_table->select()
			->setIntegrityCheck(false)
	    ->from($membership_table, array())
	    ->joinInner($music_name, ''.$music_name.'.owner_id = '.$member_name.'.user_id', array('playlist_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($music_name . '.owner_id != ?', $user_id)
	    ->where($music_name .".playlist_id NOT IN ($music_str)")
	    ->where($music_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "music" AND `engine4_suggestion_rejected`.`entity_id`= ' . $music_name . '.playlist_id)')
	    ->order($set_order[$randum_order])
	    ->limit($limit);

	  $fetch_set_music = $set_music_select->query()->fetchAll();
	  foreach($fetch_set_music as $row_set_music)
	  {
	  	$this->music_array['music_' . $row_set_music['playlist_id']] = $row_set_music['playlist_id'];

	  	if(count($this->music_array) == $limit)
			{
				return $this->music_array;
			}
	  }
		return $this->music_array;
	}

   /** Function call by "music" main functions.
   * Returns: the music array.
   *
   * @param $disply_music: music which are display on page.
   * @param $limit: Set limit that how many music will be return.
   * @return Array
   */
	// - Popular musics (in the order of views count desc, creation date desc)
	public function music_set3($disply_music, $limit)
	{
		//Condition for display music on page.
		if(empty($disply_music)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_music = 0;
		}
		//Condition for main array.
		if(empty($this->music_array)) // If none of the other randomly called functions have been called before this
		{
			$music_dis_array = 0;
		}
		else
		{
			$music_dis_array = implode(",", $this->music_array);
		}
		$music_str = $disply_music . ',' . $music_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$set_order = array('play_count DESC');
		$randum_order = array_rand($set_order, 1);


	  $music_table = Engine_Api::_()->getItemTable('music_playlist');
	  $music_name = $music_table->info('name');
	  // @todo: Use database query.
		$set_music_select = $music_table->select()
	    ->from($music_table, array('playlist_id'))
	    ->where($music_name .".playlist_id NOT IN ($music_str)")
	    ->where($music_name . '.owner_id != ?', $user_id)
	    ->where($music_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "music" AND `engine4_suggestion_rejected`.`entity_id`= ' . $music_name . '.playlist_id)')
	    ->order($set_order[$randum_order])
	    ->order('creation_date DESC')
	    ->limit($limit);

	  $fetch_set_music = $set_music_select->query()->fetchAll();
	  foreach($fetch_set_music as $row_set_music)
	  {
	  	$this->music_array['music_' . $row_set_music['playlist_id']] = $row_set_music['playlist_id'];

	  	if(count($this->music_array) == $limit)
			{
				return $this->music_array;
			}
	  }
		return $this->music_array;
	}

   /** Function call by "music" main functions.
   * Returns: the music array.
   *
   * @param $disply_music: music which are display on page.
   * @param $limit: Set limit that how many music will be return.
   * @return Array
   */
	// - music Posts commented on by my friends (in the order of comments count Desc)
	public function music_set4($disply_music, $limit)
	{
		//Condition for display music on page.
		if(empty($disply_music)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_music = 0;
		}
		//Condition for main array.
		if(empty($this->music_array)) // If none of the other randomly called functions have been called before this
		{
			$music_dis_array = 0;
		}
		else
		{
			$music_dis_array = implode(",", $this->music_array);
		}
		$music_str = $disply_music . ',' . $music_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
	  $music_comment_table = Engine_Api::_()->getItemTable('comment');
	  $music_table = Engine_Api::_()->getItemTable('music_playlist');
	  $music_name = $music_table->info('name');
	  $member_name = $membership_table->info('name');
	  $music_comment_name = $music_comment_table->info('name');
	  // @todo: Use database query.
		$set_music_select = $music_comment_table->select()
	    ->setIntegrityCheck(false)
	    ->from($membership_table, array('COUNT(' . $music_comment_name . '.poster_id) AS friends_music_count'))
	    ->joinInner($music_comment_name, ''.$music_comment_name.'.poster_id = '.$member_name.'.user_id', array())
	    ->joinInner($music_name, ''.$music_name.'.playlist_id = '.$music_comment_name.'.resource_id', array('playlist_id'))
	    ->where($member_name . '.resource_id = ?', $user_id)
	    ->where($music_comment_name . '.resource_type = ?', 'music')
	    ->where($music_name . '.owner_id != ?', $user_id)
	    ->where($music_name .".playlist_id NOT IN ($music_str)")
	    ->where($music_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "music" AND `engine4_suggestion_rejected`.`entity_id`= ' . $music_name . '.playlist_id)')
	    ->group($music_comment_name . '.resource_id')
	    ->order('friends_music_count DESC')
	    ->limit($limit);

	  $fetch_set_music = $set_music_select->query()->fetchAll();
	  foreach($fetch_set_music as $row_set_music)
	  {
	  	$this->music_array['music_' . $row_set_music['playlist_id']] = $row_set_music['playlist_id'];

	  	if(count($this->music_array) == $limit)
			{
				return $this->music_array;
			}
	  }
		return $this->music_array;
	}

   /** Function call by "music" main functions.
   * Returns: the music array.
   *
   * @param $disply_music: music which are display on page.
   * @param $limit: Set limit that how many music will be return.
   * @return Array
   */
	// - Popular musics (in the order of comment desc, creation date desc)
	public function music_set5($disply_music, $limit)
	{
		//Condition for display music on page.
		if(empty($disply_music)) // This condition occurs during page load call, and not when call is made through Ajax
		{
			$disply_music = 0;
		}
		//Condition for main array.
		if(empty($this->music_array)) // If none of the other randomly called functions have been called before this
		{
			$music_dis_array = 0;
		}
		else
		{
			$music_dis_array = implode(",", $this->music_array);
		}
		$music_str = $disply_music . ',' . $music_dis_array;

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

	  $music_table = Engine_Api::_()->getItemTable('music_playlist');
	  $music_comment_table = Engine_Api::_()->getItemTable('comment');
	  $music_comment_name = $music_comment_table->info('name');
	  $music_name = $music_table->info('name');
	  // @todo: Use database query.
		$set_music_select = $music_table->select()
		  ->setIntegrityCheck(false)
	    ->from($music_comment_table, array('COUNT(' . $music_comment_name . '.poster_id) AS comments_count_no'))
	    ->joinInner($music_name, $music_name.'.playlist_id = '.$music_comment_name.'.resource_id', array('playlist_id'))
	    ->where($music_comment_name . '.resource_type = ?', 'music_playlist')
	    ->where($music_name .".playlist_id NOT IN ($music_str)")
	    ->where($music_name . '.owner_id != ?', $user_id)
	    ->where($music_name . '.search =?', 1)
	    ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "music" AND `engine4_suggestion_rejected`.`entity_id`= ' . $music_name . '.playlist_id)')
	    ->group($music_comment_name . '.resource_id')
	    ->order('comments_count_no DESC')
	    ->order($music_name . '.creation_date DESC')
	    ->limit($limit);

	  $fetch_set_music = $set_music_select->query()->fetchAll();
	  foreach($fetch_set_music as $row_set_music)
	  {
	  	$this->music_array['music_' . $row_set_music['playlist_id']] = $row_set_music['playlist_id'];

	  	if(count($this->music_array) == $limit)
			{
				return $this->music_array;
			}
	  }
		return $this->music_array;
	}

   /** This popup comes when the user creates an music, and asks the user to suggest this music to other friends. This function is also called when "X" is clicked for an entry
   * Returns: music id array.
   *
   * @param $music_id : music id.
   * @param $display_user: User which are displayed on page.
   * @param $number_of_user: Limit, how many record wand.
   * @return Array
   */
	public function music_suggestion($music_id, $display_user, $number_of_user, $search='')
	{
		$music = Engine_Api::_()->getItem('music_playlist', $music_id);
		if($music->search == 1)
		{
			//$can_reply = $this->view->can_reply = $userBlock->block_comment;
			if(empty($display_user))
			{
				$display_user = 0;
			}
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

			$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		  $member_name = $membership_table->info('name');
		  $user_table = Engine_Api::_()->getItemTable('user');
			$user_Name = $user_table->info('name');
		  // @todo : Try to compose the sub-queries written below using Zend's convention
		  // The friend suggested should not be already shown in the popup; and he should not have rejected this music as a suggestion.
		  $member_select = $membership_table->select()
		  	->from($member_name, array('user_id'))
				->joinInner($user_Name, "$member_name . user_id = $user_Name . user_id", array())
		  	->where($member_name . '.resource_id = ?', $user_id)
		  	->where($member_name . '.active = ?', 1)
		  	->where($member_name . '.user_id NOT IN(' . $display_user . ')')
		  	->where('displayname LIKE ?', '%' . $search . '%');

				$fetch_member_myfriend = Zend_Paginator::factory($member_select);
		}
		else
		{
			$fetch_member_myfriend = '';
		}
		return $fetch_member_myfriend;
	}

 /**
 * @param $music_path_array : music id in the form of array.
 * @return Object.
 */
  public function music_info($music_path_array)
	{
  	$music_users_id = implode(",", $music_path_array);
  	//FETCH RECORD FROM music TABLE
  	$music_table  = Engine_Api::_()->getItemTable('music_playlist');
		$select_music_table = $music_table->select()->where("playlist_id IN ($music_users_id)");
		$music_info_array = $music_table->fetchAll($select_music_table);
  	return $music_info_array;
	}


	/**
	* This function Only call by "mix suggestion function".
	* @param $display_sugg_str :Suggestion which are display.
	* @param $limit :Limit, which set in data base query.
	* @param $page : page name.
	* @return Increment in "Mix suggestion array {Protected}" and destroy the self value.
	**/
	public function friendphoto_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'friendphoto')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_message = $mix_dis_str;
		// Condition If Dispaly message is empty.
		if(empty($dis_message))
		{
			$dis_message = 0;
		}

		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$photo_loggdin_array = array();
		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		$member_name = $membership_table->info('name');
		$user_table = Engine_Api::_()->getItemTable('user');
		$user_name = $user_table->info('name');
		// @todo: Use database query.
		$photo_friend_select = $user_table->select()
			->setIntegrityCheck(false)
			->from($user_name, array())
			->joinInner($member_name, "$member_name.user_id = $user_name.user_id", array('user_id'))
			->where($member_name . '.resource_id = ?', $user_id)
			->where($user_name . '.photo_id = ?', 0)
			->where($member_name . '.active = ?', 1)
			->where($user_name . '.search = ?', 1)
			->where($member_name . ".user_id NOT IN ($dis_message)")
			->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "friendphoto" AND `engine4_suggestion_rejected`.`entity_id`= ' . $member_name . '.user_id)')
			->where('NOT EXISTS (SELECT `owner_id` FROM `engine4_suggestion_suggestions` WHERE `engine4_suggestion_suggestions`.`sender_id` = ' . $user_id . ' AND `engine4_suggestion_suggestions`.`entity`= "photo" AND `engine4_suggestion_suggestions`.`owner_id`= ' . $member_name . '.user_id)')
			->order('RAND()')
			->limit($limit);
		$fetch_friend = $photo_friend_select->query()->fetchAll();
		if(!empty($fetch_friend))
		{
			//Randumly pick one from the array.
			$randum_friend_key = array_rand($fetch_friend, 1);
			$randum_one_friend = $fetch_friend[$randum_friend_key];
			$photo_loggdin_array['friendphoto_' . $randum_one_friend['user_id']] = $randum_one_friend['user_id'];
		}
	 	// Check if $page : mix_suggestion then run it.
		if(!empty($photo_loggdin_array))
		{
			$mix_array_key = count($this->mix_suggestion);
			// Assign value in mix suggestion array.
			$this->mix_suggestion[$mix_array_key] = $photo_loggdin_array;
			$sugg_str = array_keys($photo_loggdin_array);
			$this->mix_select_sugg .= ',' . $sugg_str[0];
			// Unset the photo array value.
			$array_sugg_key = array_keys($photo_loggdin_array);
			$unset_key = implode(",", $array_sugg_key);
			unset($photo_loggdin_array[$unset_key]);
			return 1;
		}
		else
		{
			return 0;
		}
	}

	/**
	* This function Only call by "mix suggestion function".
	* @param $display_sugg_str :Suggestion which are display.
	* @param $limit :Limit, which set in data base query.
	* @param $page : page name.
	* @return Increment in "Mix suggestion array {Protected}" and destroy the self value.
	**/
	public function friendfewfriend_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		// If site admin set "Nobody can friend".
		if(Engine_Api::_()->getApi('settings', 'core')->user_friends_eligible != 0)
		{
			//Display widget.
			$explode_display_str = explode(",", $display_sugg_str);
			$mix_dis_str = '';
			foreach($explode_display_str as $row_explode_str)
			{
			  $mix_explode = explode("_", $row_explode_str);
			  if($mix_explode[0] == 'friendfewfriend')
			  {
				  $mix_dis_str .= "," . $mix_explode[1];
			  }
			}
			$mix_dis_str = ltrim($mix_dis_str, ",");
			$dis_message = $mix_dis_str; // My Friends being displayed as having few friends in suggestions
			// Condition If Dispaly message is empty.
			if(empty($dis_message))
			{
				$dis_message = 0;
			}
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$few_loggdin_array = array();
			$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
			$member_name = $membership_table->info('name');
			//$suggestion_table = Engine_Api::_()->getItemTable('suggestion');
			//$suggestion_name = $suggestion_table->info('name');
			$user_table = Engine_Api::_()->getItemTable('user');
			$user_name = $user_table->info('name');
			// @todo: Use database query.
			$few_friend_select = $user_table->select()
				->setIntegrityCheck(false)
				->from($user_name, array())
				->joinInner($member_name, "$member_name.user_id = $user_name.user_id", array('user_id'))
				//->joinInner($suggestion_name, "$suggestion_name.owner_id = $member_name.user_id", array())
				->where($member_name . '.resource_id = ?', $user_id)
				->where($member_name . '.active = ?', 1)
				->where($user_name . '.member_count < ?', 10) // Picking up friends having less than 10 friends
				->where($user_name . '.search = ?', 1)
				->where($member_name . ".user_id NOT IN ($dis_message)") // My Friends being displayed as having few friends in suggestions
				->where('NOT EXISTS (SELECT `owner_id` FROM `engine4_suggestion_suggestions` WHERE `engine4_suggestion_suggestions`.`sender_id` = ' . $user_id . ' AND `engine4_suggestion_suggestions`.`entity`= "friend" AND `engine4_suggestion_suggestions`.`owner_id`= ' . $member_name . '.user_id)')
				->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "friendfewfriend" AND `engine4_suggestion_rejected`.`entity_id`= ' . $member_name . '.user_id)')
				->order($user_name . '.member_count ASC')
				->limit(15);
			$fetch_friend = $few_friend_select->query()->fetchAll();
			if(!empty($fetch_friend))
			{
				//Randumly pick one from the array.
				$randum_friend_key = array_rand($fetch_friend, 1);
				$randum_one_friend = $fetch_friend[$randum_friend_key];
				$few_loggdin_array['friendfewfriend_' . $randum_one_friend['user_id']] = $randum_one_friend['user_id'];

				$mix_array_key = count($this->mix_suggestion);
				// Assign value in mix suggestion array.
				$this->mix_suggestion[$mix_array_key] = $few_loggdin_array;
				$sugg_str = array_keys($few_loggdin_array);
				$this->mix_select_sugg .= ',' . $sugg_str[0];
				// Unset the few friend array value.
				$array_sugg_key = array_keys($few_loggdin_array);
				$unset_key = implode(",", $array_sugg_key);
				unset($few_loggdin_array[$unset_key]);
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}

	/**
	* This function Only call by "mix suggestion function".
	* @param $display_sugg_str :Suggestion which are display.
	* @param $limit :Limit, which set in data base query.
	* @param $page : page name.
	* @return Increment in "Mix suggestion array {Protected}" and destroy the self value.
	**/
	public function friend_loggedin_suggestions($display_sugg_str, $limit, $page)
	{
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'friend')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_friend = $mix_dis_str;
		// Condition If Dispaly message is empty.
		if(empty($dis_friend))
		{
			$dis_friend = '';
		}
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

		$friend_id_array = $this->suggestion_path($user_id, 4, $dis_friend, 1);
		$friend_loggdin_array = array();
		if(!empty($friend_id_array))
		{
			$friend_loggdin_array['friend_' . $friend_id_array[0]] = $friend_id_array[0];
		}
	 	// Check if $page : mix_suggestion then run it.
		if(!empty($friend_loggdin_array))
		{
			$mix_array_key = count($this->mix_suggestion);
			// Assign value in mix suggestion array.
			$this->mix_suggestion[$mix_array_key] = $friend_loggdin_array;
			$sugg_str = array_keys($friend_loggdin_array);
			$this->mix_select_sugg .= ',' . $sugg_str[0];
			// Unset the loggedin array value.
			$array_sugg_key = array_keys($friend_loggdin_array);
			$unset_key = implode(",", $array_sugg_key);
			unset($friend_loggdin_array[$unset_key]);
			return 1;
		}
		else
		{
			return 0;
		}
	}

	/**
	* This function Only call by "mix suggestion function".
	* @param $display_sugg_str :Suggestion which are display.
	* @param $limit :Limit, which set in data base query.
	* @param $page : page name.
	* @return Increment in "Mix suggestion array {Protected}" and destroy the self value.
	**/
 	public function messagefriend_loggedin_suggestions($display_sugg_str, $limit, $page)
 	{
		//Display widget.
		$explode_display_str = explode(",", $display_sugg_str);
		$mix_dis_str = '';
		foreach($explode_display_str as $row_explode_str)
		{
		  $mix_explode = explode("_", $row_explode_str);
		  if($mix_explode[0] == 'messagefriend')
		  {
			  $mix_dis_str .= "," . $mix_explode[1];
		  }
		}
		$mix_dis_str = ltrim($mix_dis_str, ",");
		$dis_message = $mix_dis_str;
		// Condition If Dispaly message is empty.
		if(empty($dis_message))
		{
			$dis_message = 0;
		}
		// 1) We only show this suggestion to the user if he has more than 3 friends
		// 2) We randomly pick a friend to whom the user has never messaged. If this comes out to be empty, we go to step 3
		// 3) We pick up a friend to whom the user messaged first.
		// Initialized all table's.
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$message_table = Engine_Api::_()->getItemTable('messages_message');
		$membership_table = Engine_Api::_()->getDbtable('membership', 'user');
		$recipient_table = Engine_Api::_()->getItemTable('recipient');
		$user_table = Engine_Api::_()->getItemTable('user');
		$message_name = $message_table->info('name');
		$member_name = $membership_table->info('name');
		$recipient_name = $recipient_table->info('name');
		$user_name = $user_table->info('name');

		//Query for check that user should have more then 3 friend.
  	$message_select = $user_table->select()
			->from($user_name, array('member_count'))
		  ->where($user_name . '.user_id = ?', $user_id);
	 	$fetch_user_array = $message_select->query()->fetchAll();
		if(!empty($fetch_user_array) && $fetch_user_array[0]['member_count'] > 3)
		{
			//Query for pick a friend to whom I've never messaged.
			// @todo: Use database query.
	  	$message_select = $membership_table->select()
				->from($member_name, array('user_id'))
			  ->where($member_name . '.resource_id = ?', $user_id)
			  ->where($member_name . '.active = ?', 1)
			  ->where('NOT EXISTS (SELECT emm.message_id FROM `engine4_messages_messages` emm INNER JOIN `engine4_messages_recipients` emr ON emr.conversation_id = emm.conversation_id WHERE emm.user_id = ' . $user_id . ' AND emr.user_id = ' . $member_name . '.user_id)')
			  ->where($member_name . ".user_id NOT IN ($dis_message)")
			  ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "messagefriend" AND `engine4_suggestion_rejected`.`entity_id`= ' . $member_name . '.user_id)')
			  ->order('RAND()')
		 		->limit($limit);

		 	$fetch_never_msg_fri = $message_select->query()->fetchAll();
		 	//Condition for "undefine offset 0" && "if there are no record return then array should be empty".
		 	if(!empty($fetch_never_msg_fri)){
		 		$message_friend['messagefriend_' . $fetch_never_msg_fri[0]['user_id']] = $fetch_never_msg_fri[0]['user_id'];
		 	}
		 	//In this query message come if user send message to all his friend.
		 	if(empty($message_friend))
		 	{
				//Query for pick a friend to whom i've messaged last.
				// @todo: Use database query.
		  	$message_select = $recipient_table->select()
		  		->setIntegrityCheck(false)
		  		->from($message_name, array())
					->joinInner($recipient_name, "$recipient_name.conversation_id = $message_name.conversation_id", array('user_id'))
					->joinInner($member_name, "$member_name.user_id = $recipient_name.user_id", array())
					->where($member_name . '.resource_id = ?', $user_id)
					->where($member_name . '.active = ?', 1)
					->where($member_name . ".user_id NOT IN ($dis_message)")
				  ->where($message_name . '.user_id = ?', $user_id)
				  ->where($recipient_name . '.user_id != ?', $user_id)
				  ->where('NOT EXISTS (SELECT `entity_id` FROM `engine4_suggestion_rejected` WHERE `engine4_suggestion_rejected`.`owner_id` = ' . $user_id . ' AND `engine4_suggestion_rejected`.`entity`= "messagefriend" AND `engine4_suggestion_rejected`.`entity_id`= ' . $member_name . '.user_id)')
				  ->order($message_name . '.date ASC')
			 		->limit($limit);
			 	$fetch_last_msg_fri = $message_select->query()->fetchAll();
			 	//Insert the value in protected array.
		 		//Condition for "undefine offset 0" && "if there are no record return then array should be empty".
			 	if(!empty($fetch_last_msg_fri)){
			 		$message_friend['messagefriend_' . $fetch_last_msg_fri[0]['user_id']] = $fetch_last_msg_fri[0]['user_id'];
			 	}
		 	}
		}
		if(!empty($message_friend))
		{
			$mix_array_key = count($this->mix_suggestion);
			// Assign value in mix suggestion array.
			$this->mix_suggestion[$mix_array_key] = $message_friend;
			// Unset the message array value.
			$array_sugg_key = array_keys($message_friend);
			$this->mix_select_sugg .= ',' . $array_sugg_key[0];
			$unset_key = implode(",", $array_sugg_key);
			unset($message_friend[$unset_key]);
			return 1;
		}
		else
		{
			return 0;
		}
 }

 /**
 * @param $message_path_array : message id in the form of array.
 * @return Object.
 */
	public function messagefriend_info($message_path_array)
	{
		$msg_sugg = $this->suggestion_users_information($message_path_array, '');
		return $msg_sugg;
	}

 /**
 * @param $friend_path_array : user id in the form of array.
 * @return Object.
 */
	public function friend_info($friend_path_array)
	{
		$friend_sugg = $this->suggestion_users_information($friend_path_array, '');
		return $friend_sugg;
	}

 /**
 * @param $few_path_array : user id in the form of array.
 * @return Object.
 */
	public function friendfewfriend_info($few_path_array)
	{
		$few_sugg = $this->suggestion_users_information($few_path_array, '');
		return $few_sugg;
	}

 /**
 * @param $photo_path_array : user id in the form of array.
 * @return Object.
 */
	public function friendphoto_info($photo_path_array)
	{
		$photo_sugg = $this->suggestion_users_information($photo_path_array, '');
		return $photo_sugg;
	}

 /**
 * @param $photo_array : photo id in the form of array.
 * @return Object.
 */
	public function photo_info($photo_array)
	{
  	//FETCH RECORD FROM USER TABLE
  	$table = Engine_Api::_()->getItemTable('suggestion');
		$select_table = $table->select()->where('suggestion_id = ?', $photo_array[0]);
		$photo_info_array = $table->fetchAll($select_table);
  	return $photo_info_array;
	}

	// --------------------------------- MIX SUGGESTION -----------------------------------

 /**
 * @param $display_sugg_str : Suggestion which are display on the page.
 * @param $limit : limit which are set in the table.
 * @param $user_status : user is "logged_in" or "logged_out".
 * @return Array which has randum value that are change in every calling.
 */
	protected $mix_suggestion = array();
	protected $mix_select_sugg;

	public function mix_suggestions($display_sugg_str, $limit, $user_status)
	{
		// Getting the list of plugins enabled on the site
		$enabledModuleNames = Engine_Api::_()->getDbtable('modules', 'core')->getEnabledModuleNames();
		// Getting admin settings for the types of suggestions to be shown in mixed suggestions block
		$mix_widget_dis_array = unserialize(Engine_Api::_()->getApi('settings', 'core')->mix_serialize);
		// Condition only for "friend suggestion", "message suggestion", "few friend suggestion", "profile picture suggestion" and user should be loggedin.
		if(in_array('friend', $mix_widget_dis_array) == 1 && $user_status == 'logged_in')
		{
			$enabledModuleNames[] = 'friend';
		}
		if(in_array('messagefriend', $mix_widget_dis_array) == 1 && $user_status == 'logged_in')
		{
			$enabledModuleNames[] = 'messagefriend';
		}
		if(in_array('friendfewfriend', $mix_widget_dis_array) == 1 && $user_status == 'logged_in')
		{
			$enabledModuleNames[] = 'friendfewfriend';
		}
		if(in_array('friendphoto', $mix_widget_dis_array) == 1 && $user_status == 'logged_in')
		{
			$enabledModuleNames[] = 'friendphoto';
		}
		// Only those types should come in mixed suggestions which the admin has chosen, and for whom their plugins are also enabled.
		$widget_dis_array = array_intersect($mix_widget_dis_array, $enabledModuleNames);
		$level = 0;

		// The function sets based on their main queries. One of these functions is called randomly to return suggestions

		while($level != $limit)
		{

			$current_set_id = array_rand($widget_dis_array, 1);
			$randum_widget_name = $widget_dis_array[$current_set_id];

			$dis_sugg_str = $display_sugg_str;
			if(empty($dis_sugg_str)){
				$dis_sugg_str = ltrim($this->mix_select_sugg, ",");
			}
		  //Display widget.
		  $explode_display_str = explode(",", $dis_sugg_str);
		  $mix_dis_str = '';
		  foreach($explode_display_str as $row_explode_str)
		  {
			  $mix_explode = explode("_", $row_explode_str);
			  if($mix_explode[0] == $randum_widget_name)
			  {
				  $mix_dis_str .= "," . $row_explode_str;
			  }
		  }
		  $mix_dis_str = ltrim($mix_dis_str, ",");

			// Calling the randomly picked up function
			if($user_status == 'logged_in')
			{
				$function_name = $randum_widget_name . '_loggedin_suggestions';
			}
			else {
				$function_name = $randum_widget_name . '_loggedout_suggestions';
			}
			$mix_sugg_set = $this->$function_name($mix_dis_str, 1, 'mix_sugg');
			//Condition only for if function does not return any value then we unset array.
			if($mix_sugg_set == 0)
			{
				unset($widget_dis_array[$current_set_id]);
			}

			if(count($widget_dis_array) == 0)
			{
				break;
			}
			$level = count($this->mix_suggestion);
		}
		return $this->mix_suggestion;
	}

	/**
	* @return Array suggestion as keys and number of suggestion as values.
	**/
	protected $display_sugg_array;
	public function sugg_display()
	{
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();//Login user id.
		$mix_widget_dis_array = array('friend', 'group', 'friendphoto', 'event', 'classified', 'album', 'video', 'music', 'blog', 'poll', 'forum');
		// Getting the list of plugins enabled on the site
		$enabledModuleNames = Engine_Api::_()->getDbtable('modules', 'core')->getEnabledModuleNames();
		$enabledModuleNames[] = 'friend';
		$enabledModuleNames[] = 'friendphoto';
		// Which widget are enable we are tacking in array.
		$rec_entity = array_intersect($mix_widget_dis_array, $enabledModuleNames);
		// We replace the name "friendphoto" with "photo".
		if(in_array('friendphoto', $rec_entity))
		{
			$rec_entity = str_replace('friendphoto', 'photo', $rec_entity);
		}

		//Here we are  use foreach for every entity.
		foreach($rec_entity as $row_entity)
		{
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');

			$received_select = $received_table->select()
				->from($received_name, array('COUNT(suggestion_id) AS sugg_count'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', $row_entity)
				->group('entity');
			$fetch_rec_suggestion = $received_select->query()->fetchAll();

			if(!empty($fetch_rec_suggestion))
			{
				$this->display_sugg_array[$row_entity] = $fetch_rec_suggestion[0]['sugg_count'];
			}
		}
		return $this->display_sugg_array;
	}

	/**
	 * @return Array of givieng suggestion array.
	 **/
	public function see_suggestion_display()
	{
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();//Login user id.
		$mix_widget_dis_array = array('friend', 'group', 'friendphoto', 'event', 'classified', 'album', 'video', 'music', 'blog', 'poll', 'forum');
		// Getting the list of plugins enabled on the site
		$enabledModuleNames = Engine_Api::_()->getDbtable('modules', 'core')->getEnabledModuleNames();
		$enabledModuleNames[] = 'friend';
		$enabledModuleNames[] = 'friendphoto';
		// Which widget are enable we are tacking in array.
		$rec_entity = array_intersect($mix_widget_dis_array, $enabledModuleNames);
		// We replace the name "friendphoto" with "photo".
		if(in_array('friendphoto', $rec_entity))
		{
			$rec_entity = str_replace('friendphoto', 'photo', $rec_entity);
		}
		//Here we are  use foreach for every entity but every time one entity come.
		$sugg_array = array();
		foreach($rec_entity as $row_entity)
		{
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');

			$received_select = $received_table->select()
				->from($received_name, array('entity', 'entity_id', 'sender_id', 'suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', $row_entity);
			// Array of one type entity record.
			$fetch_rec_suggestion = $received_select->query()->fetchAll();
			if(!empty($fetch_rec_suggestion))
			{
				// fetch one by one record of one type entity.
				foreach ($fetch_rec_suggestion as $check_same_sender_id)
				{
					// This condition for [If same suggestion given by more then one friend].
					if(array_key_exists($check_same_sender_id['entity'] . '_' . $check_same_sender_id['entity_id'], $sugg_array))
					{
						// old sender Id.
						$before_sender_id = $sugg_array[$check_same_sender_id['entity'] . '_' . $check_same_sender_id['entity_id']]['sender_id'];			// New sender Id with old sender Id seprate by commas.
						$after_sender_id = $before_sender_id . ',' . $check_same_sender_id['sender_id'];
						// Insert new sender Id.
						$sugg_array[$check_same_sender_id['entity'] . '_' . $check_same_sender_id['entity_id']]['sender_id'] = $after_sender_id;
						// old received Id.
						$before_suggestion_id = $sugg_array[$check_same_sender_id['entity'] . '_' . $check_same_sender_id['entity_id']]['suggestion_id'];	// New received Id with old received Id seprate by commas.
						$after_suggestion_id = $before_suggestion_id . ',' . $check_same_sender_id['suggestion_id'];
						// Insert new received Id.
						$sugg_array[$check_same_sender_id['entity'] . '_' . $check_same_sender_id['entity_id']]['suggestion_id'] = $after_suggestion_id;
					}
					else {
						$sugg_array[$check_same_sender_id['entity'] . '_' . $check_same_sender_id['entity_id']] = $check_same_sender_id;
					}

				}
			}
		}
		return $sugg_array;
	}

   /**
   *
   * @param $title: String which are require for truncate
   * @return string
   */
	public function truncateTitle($title)
  {
    $tmpBody = strip_tags($title);
    return ( Engine_String::strlen($tmpBody) > 10 ? Engine_String::substr($tmpBody, 0, 12) . '..' : $tmpBody );
  }
}