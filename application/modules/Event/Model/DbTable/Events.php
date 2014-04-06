<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Events.php 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */

/**
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @author     Sami
 */
class Event_Model_DbTable_Events extends Engine_Db_Table
{
	
  protected $_rowClass = "Event_Model_Event";
  public function listAllEvents(){
  	
  	$eventsTable = Engine_Api::_()->getDbtable('events', 'event');
  	$catTable = Engine_Api::_()->getDbtable('categories', 'event');
  	$userTable = Engine_Api::_()->getDbtable('users', 'user');
  	
    $select = $eventsTable->select()
      ->setIntegrityCheck(false)
      ->from($eventsTable->info('name'), new Zend_Db_Expr('engine4_event_events.*, engine4_users.username, engine4_event_categories.title as category_name'))
      ->join($catTable->info('name'),'engine4_event_categories.category_id = engine4_event_events.category_id',array())
      ->join($userTable->info('name'),'engine4_users.user_id = engine4_event_events.user_id',array())
      ->order('creation_date desc')
      ->limit(4);
     
    $events = $eventsTable->fetchAll($select);
   	
    return $events;
  }
  public function getTable()
	{
		return $this;
	}
}