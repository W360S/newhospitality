<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: Groups.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Group_Model_DbTable_Groups extends Engine_Db_Table
{
  protected $_rowClass = 'Group_Model_Group';
  public function getRecentActivityActions(){
        $actions_table = Engine_Api::_()->getDbtable('actions', 'activity');
        $activities = ($actions_table->fetchAll($actions_table->select()
            // ->where('`date` > ?', $previous_date)
            ->where('(`type` IN ("group_create","group_join","group_photo_upload","group_topic_create","group_topic_reply")) OR (`type`="post" AND `object_type`="group") OR (`type`="post_self" AND `object_type`="group")')
            ->order('date DESC')
            ->limit(10)
            ));
        
        return $activities;
        

        // subject_type alway user
        // object_type may be group, group_topic
        // type may be 
            // group_create
            // group_join
            // group_photo_upload

            // group_topic_create
            // group_topic_reply

            // post
            // post_selfs

    }
}