<?php

/**
 * SocialEngine
 * @author     bangvn
 */
class Group_Widget_RecentGroupsActivityController extends Engine_Content_Widget_Abstract {

    public function indexAction() {
        $groups_notifications = Engine_Api::_()->getDbtable('notifications', 'activity')->getNotificationsByObjectType('group');
        $groups_activities = Engine_Api::_()->getDbtable('actions', 'activity')->getAvtivitiesByObjectType('group');
    
        $this->view->actions = $groups_activities;
    }

}